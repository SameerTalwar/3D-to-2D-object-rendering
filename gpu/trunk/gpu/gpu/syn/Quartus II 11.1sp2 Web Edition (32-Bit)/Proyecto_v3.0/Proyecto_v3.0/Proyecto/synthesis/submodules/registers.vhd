-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is
    generic(
        ADDR_WIDTH : natural := 2;
        DATA_WIDTH : natural := 4;
        USE_RESET  : boolean := true
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        addra : in  unsigned(ADDR_WIDTH-1 downto 0);
        dataa : out std_logic_vector(DATA_WIDTH-1 downto 0);
        
        addrb : in  unsigned(ADDR_WIDTH-1 downto 0);
        datab : out std_logic_vector(DATA_WIDTH-1 downto 0);
        
        addrc : in unsigned(ADDR_WIDTH-1 downto 0);
        wec   : in std_logic;
        datac : in std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of registers is
    type regs_t is array(0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    
    signal regs : regs_t;
begin
    dataa <= regs(to_integer(addra));
    datab <= regs(to_integer(addrb));
    
    process(clk, reset, cke,
            addrc, wec, datac)
    begin
        if USE_RESET and (reset = '1') then
            regs <= (others=> (others=> '0'));
        elsif rising_edge(clk) and (cke = '1') and (wec = '1') then
            regs(to_integer(addrc)) <= datac;
        end if;
    end process;
end architecture;