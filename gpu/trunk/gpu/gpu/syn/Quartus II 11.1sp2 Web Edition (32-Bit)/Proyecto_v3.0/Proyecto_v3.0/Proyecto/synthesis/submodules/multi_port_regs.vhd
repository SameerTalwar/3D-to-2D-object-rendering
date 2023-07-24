library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multi_port_regs is
    generic(
        REGS_INIT_1 : std_logic := '0';
        REGS_INIT_2 : std_logic_vector := "0";
        USE_RESET : boolean := true;
        WRITE_PORTS : natural := 1;
        ADDR_WIDTH : natural := 2;
        DATA_WIDTH : natural := 8;
        READ_PORTS : natural := 1;
        RDATA_REG : boolean := true
    );
    port(
        clk, cke, reset : in std_logic;
        we : in std_logic_vector(WRITE_PORTS-1 downto 0);
        waddr : in unsigned(WRITE_PORTS*ADDR_WIDTH-1 downto 0);
        wdata : in std_logic_vector(WRITE_PORTS*DATA_WIDTH-1 downto 0);
        raddr : in unsigned(READ_PORTS*ADDR_WIDTH-1 downto 0);
        rdata : out std_logic_vector(READ_PORTS*DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of multi_port_regs is
    type regs_t is array(2**ADDR_WIDTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
    
    function regs_init_f return regs_t is
        variable regs : regs_t := (others=> (others=> REGS_INIT_1));
        alias regs_init : std_logic_vector(REGS_INIT_2'length-1 downto 0) is REGS_INIT_2;
    begin
        for i in 0 to 2**ADDR_WIDTH-1 loop
            if REGS_INIT_2'length-1-(DATA_WIDTH*(i+1)-1) >= 0 then
                regs(i) := regs_init(REGS_INIT_2'length-1-DATA_WIDTH*i downto REGS_INIT_2'length-1-(DATA_WIDTH*(i+1)-1));
            else
                exit;
            end if;
        end loop;
        return regs;
    end function;
    
    signal regs : regs_t := regs_init_f;
begin
    process(clk, cke, reset, we, waddr, wdata, raddr, regs)
    begin
        if USE_RESET and (reset = '1') then
            regs <= (others=> (others=> '0'));
        elsif rising_edge(clk) and (cke = '1') then
            for i in WRITE_PORTS-1 downto 0 loop
                if we(i) = '1' then
                    regs(to_integer(waddr(ADDR_WIDTH*(i+1)-1 downto ADDR_WIDTH*i))) <= wdata(DATA_WIDTH*(i+1)-1 downto DATA_WIDTH*i);
                end if;
            end loop;
        end if;
        if USE_RESET and RDATA_REG and (reset = '1') then
            rdata <= (others=> '0');
        elsif not(RDATA_REG) or (rising_edge(clk) and (cke = '1')) then
            for i in READ_PORTS-1 downto 0 loop
                rdata(DATA_WIDTH*(i+1)-1 downto DATA_WIDTH*i) <= regs(to_integer(raddr(ADDR_WIDTH*(i+1)-1 downto ADDR_WIDTH*i)));
            end loop;
        end if;
    end process;
end architecture;