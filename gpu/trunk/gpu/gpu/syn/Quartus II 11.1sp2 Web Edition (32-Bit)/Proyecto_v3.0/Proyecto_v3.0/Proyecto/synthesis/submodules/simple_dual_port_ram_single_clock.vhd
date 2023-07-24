library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_dual_port_ram_single_clock is
    generic(
        DATA_WIDTH : natural := 8;
        ADDR_WIDTH : natural := 8
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        
        re    : in  std_logic;
        raddr : in  unsigned(ADDR_WIDTH-1 downto 0);
        rdata : out std_logic_vector(DATA_WIDTH-1 downto 0);
        
        we    : in std_logic;
        waddr : in unsigned(ADDR_WIDTH-1 downto 0);
        wdata : in std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of simple_dual_port_ram_single_clock is
    type ram_t is array(0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    
    signal ram : ram_t;
begin
    process(clk, reset,
            re, raddr,
            we, waddr, wdata,
            ram)
    begin
        if reset = '1' then
            rdata <= (others=> '0');
        elsif rising_edge(clk) and (re = '1') then
            rdata <= ram(to_integer(raddr));
        end if;
        
        if rising_edge(clk) and (we = '1') then
            ram(to_integer(waddr)) <= wdata;
        end if;
    end process;
end architecture;