-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;

entity ps2 is
    generic(
        clk_frequency : natural := 100_000_000
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        
        avs_byteenable : in  std_logic_vector(3 downto 0);
        avs_read       : in  std_logic;
        avs_readdata   : out std_logic_vector(31 downto 0);
        avs_write      : in  std_logic;
        avs_writedata  : in  std_logic_vector(31 downto 0);
        
        ins_irq : out std_logic;
        
        coe_clock : inout std_logic;
        coe_data  : inout std_logic
    );
end entity;

architecture rtl of ps2 is
    type state_t is (idle, device_to_host, host_to_device_0, host_to_device_1, host_to_device_2);
    
    constant t_100us : natural := clk_frequency/10_000;
    
    function odd_parity(x : std_logic_vector) return std_logic is
        variable y : std_logic := '0';
    begin
        for i in x'range loop
            y := y xor x(i);
        end loop;
        
        return not(y);
    end function;
    
    signal state         : state_t;
    signal shift         : std_logic_vector(9 downto 0);
    signal coe_clock_reg : std_logic_vector(0 to 1);
    signal coe_data_reg  : std_logic;
    signal bits          : natural range 0 to 9;
    signal irq           : std_logic;
    signal parity_error  : std_logic;
    signal stop_error    : std_logic;
    signal data          : std_logic_vector(7 downto 0);
    signal t             : natural range 0 to t_100us;
    signal ack_error     : std_logic;
begin
    process(clk, reset,
            avs_byteenable, avs_read, avs_write, avs_writedata,
            coe_clock, coe_data,
            state, shift, coe_clock_reg, coe_data_reg, bits, irq, parity_error, stop_error, data, t, ack_error)
        variable falling_edge_clock_reg : boolean;
    begin
        case state is
        when idle|device_to_host|host_to_device_2=>
            coe_clock <= 'Z';
            coe_data <= 'Z';
        when host_to_device_0=>
            coe_clock <= '0';
            coe_data <= 'Z';
        when host_to_device_1=>
            coe_clock <= 'Z';
            coe_data <= shift(0);
        end case;
        
        if reset = '1' then
            avs_readdata(11 downto 0) <= (others=> '0');
            state <= idle;
            shift <= (others=> '0');
            coe_clock_reg <= (others=> '1');
            coe_data_reg <= '1';
            bits <= 0;
            irq <= '0';
            parity_error <= '0';
            stop_error <= '0';
            data <= (others=> '0');
            t <= 0;
            ack_error <= '0';
        elsif rising_edge(clk) then
            coe_clock_reg(0) <= coe_clock;
            coe_clock_reg(1) <= coe_clock_reg(0);
            coe_data_reg <= coe_data;
            falling_edge_clock_reg := (coe_clock_reg(1) = '1') and (coe_clock_reg(0) = '0');
            
            case state is
            when idle=>
                if falling_edge_clock_reg then
                    shift(9) <= coe_data_reg;
                    shift(8 downto 0) <= shift(9 downto 1);
                    
                    if coe_data_reg = '0' then
                        state <= device_to_host;
                    end if;
                end if;
            when device_to_host=>
                if falling_edge_clock_reg then
                    shift(9) <= coe_data_reg;
                    shift(8 downto 0) <= shift(9 downto 1);
                    
                    if bits = 9 then
                        irq <= '1';
                        
                        if shift(9) = odd_parity(shift(8 downto 1)) then
                            parity_error <= '0';
                        else
                            parity_error <= '1';
                        end if;
                        
                        if coe_data_reg = '1' then
                            stop_error <= '0';
                        else
                            stop_error <= '1';
                        end if;
                        
                        data <= shift(8 downto 1);
                        bits <= 0;
                        state <= idle;
                    else
                        bits <= bits+1;
                    end if;
                end if;
            when host_to_device_0=>
                if t = t_100us then
                    t <= 0;
                    state <= host_to_device_1;
                else
                    t <= t+1;
                end if;
            when host_to_device_1=>
                if falling_edge_clock_reg then
                    shift(9) <= coe_data_reg;
                    shift(8 downto 0) <= shift(9 downto 1);
                    
                    if bits = 9 then
                        bits <= 0;
                        state <= host_to_device_2;
                    else
                        bits <= bits+1;
                    end if;
                end if;
            when host_to_device_2=>
                if falling_edge_clock_reg then
                    irq <= '1';
                    
                    if coe_data_reg = '0' then
                        ack_error <= '0';
                    else
                        ack_error <= '1';
                    end if;
                    
                    state <= idle;
                end if;
            end case;
            
            if (avs_byteenable(0) = '1') and (avs_read = '1') then
                avs_readdata(7 downto 0) <= data;
            end if;
            
            if (avs_byteenable(1) = '1') and (avs_read = '1') then
                avs_readdata(11 downto 8) <= ack_error & stop_error & parity_error & irq;
            end if;
            
            if (avs_byteenable(0) = '1') and (avs_write = '1') then
                shift(0) <= '0';
                shift(8 downto 1) <= avs_writedata(7 downto 0);
                shift(9) <= odd_parity(avs_writedata(7 downto 0));
                bits <= 0;
                state <= host_to_device_0;
            end if;
            
            if (avs_byteenable(1) = '1') and (avs_write = '1') then
                irq <= avs_writedata(8);
                parity_error <= avs_writedata(9);
                stop_error <= avs_writedata(10);
                ack_error <= avs_writedata(11);
            end if;
        end if;
        
        avs_readdata(31 downto 12) <= (others=> '0');
        ins_irq <= irq;
    end process;
end architecture;