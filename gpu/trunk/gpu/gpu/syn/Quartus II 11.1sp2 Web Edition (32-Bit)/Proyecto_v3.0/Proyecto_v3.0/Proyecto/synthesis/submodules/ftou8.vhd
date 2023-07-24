-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pfloat_pkg.all;

entity ftou8 is
    generic(
        DATAC_REG : boolean := true
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        dataa       : in std_logic_vector(31 downto 0);
        ll_lh_hl_hh : in std_logic_vector(1 downto 0);
        datab       : in std_logic_vector(31 downto 0);
        
        datac : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of ftou8 is
begin
    process(clk, reset, cke,
            dataa, ll_lh_hl_hh, datab)
        variable u8 : unsigned(7 downto 0);
    begin
        u8 := to_unsigned(to_pfloat(dataa), 8);
        
        if DATAC_REG and (reset = '1') then
            datac <= (others=> '0');
        elsif not(DATAC_REG) or (rising_edge(clk) and (cke = '1')) then
            case ll_lh_hl_hh is
            when "00"=>
                datac <= datab(31 downto 8)&std_logic_vector(u8);
            when "01"=>
                datac <= datab(31 downto 16)&std_logic_vector(u8)&datab(7 downto 0);
            when "10"=>
                datac <= datab(31 downto 24)&std_logic_vector(u8)&datab(15 downto 0);
            when "11"=>
                datac <= std_logic_vector(u8)&datab(23 downto 0);
            when others=>
                null;
            end case;
        end if;
    end process;
end architecture;