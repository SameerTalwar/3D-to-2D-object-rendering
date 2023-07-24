-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pfloat_pkg.all;

entity u16tof is
    generic(
        DATAC_REG : boolean := true
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        l_h   : in std_logic;
        datab : in std_logic_vector(31 downto 0);
        
        datac : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of u16tof is
begin
    process(clk, reset, cke,
            l_h, datab)
        variable u16 : unsigned(15 downto 0);
    begin
        case l_h is
        when '0'=>
            u16 := unsigned(datab(15 downto 0));
        when '1'=>
            u16 := unsigned(datab(31 downto 16));
        when others=>
            null;
        end case;
        
        if DATAC_REG and (reset = '1') then
            datac <= (others=> '0');
        elsif not(DATAC_REG) or (rising_edge(clk) and (cke = '1')) then
            datac <= to_stdlogicvector(to_pfloat(u16, 2));
        end if;
    end process;
end architecture;