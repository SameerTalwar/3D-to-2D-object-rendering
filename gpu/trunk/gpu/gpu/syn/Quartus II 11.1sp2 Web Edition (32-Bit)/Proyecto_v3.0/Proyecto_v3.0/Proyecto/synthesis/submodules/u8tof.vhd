-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pfloat_pkg.all;

entity u8tof is
    generic(
        DATAC_REG : boolean := true
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        ll_lh_hl_hh : in std_logic_vector(1 downto 0);
        datab       : in std_logic_vector(31 downto 0);
        
        datac : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of u8tof is
begin
    process(clk, reset, cke,
            ll_lh_hl_hh, datab)
        variable u8 : unsigned(7 downto 0);
    begin
        case ll_lh_hl_hh is
        when "00"=>
            u8 := unsigned(datab(7 downto 0));
        when "01"=>
            u8 := unsigned(datab(15 downto 8));
        when "10"=>
            u8 := unsigned(datab(23 downto 16));
        when "11"=>
            u8 := unsigned(datab(31 downto 24));
        when others=>
            null;
        end case;
        
        if DATAC_REG and (reset = '1') then
            datac <= (others=> '0');
        elsif not(DATAC_REG) or (rising_edge(clk) and (cke = '1')) then
            datac <= to_stdlogicvector(to_pfloat(u8));
        end if;
    end process;
end architecture;