-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pfloat_pkg.all;

entity ftou16 is
    generic(
        DATAC_REG : boolean := true
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        dataa : in std_logic_vector(31 downto 0);
        l_h   : in std_logic;
        datab : in std_logic_vector(31 downto 0);
        
        datac : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of ftou16 is
begin
    process(clk, reset, cke,
            dataa, l_h, datab)
        variable u16 : unsigned(15 downto 0);
    begin
        u16 := to_unsigned(to_pfloat(dataa), 16);
        
        if DATAC_REG and (reset = '1') then
            datac <= (others=> '0');
        elsif not(DATAC_REG) or (rising_edge(clk) and (cke = '1')) then
            case l_h is
            when '0'=>
                datac <= datab(31 downto 16)&std_logic_vector(u16);
            when '1'=>
                datac <= std_logic_vector(u16)&datab(15 downto 0);
            when others=>
                null;
            end case;
        end if;
    end process;
end architecture;