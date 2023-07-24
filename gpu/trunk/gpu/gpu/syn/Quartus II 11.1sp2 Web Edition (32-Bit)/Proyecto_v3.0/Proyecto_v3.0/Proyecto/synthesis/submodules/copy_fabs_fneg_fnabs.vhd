library ieee;
use ieee.std_logic_1164.all;

use work.pfloat_pkg.all;

entity copy_fabs_fneg_fnabs is
    port(
        ra  : in std_logic_vector(31 downto 0);
        sel : in std_logic_vector(1 downto 0);
        
        rc : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of copy_fabs_fneg_fnabs is
begin
    process(ra, sel)
    begin
        case sel is
        when "00"=>
            rc <= ra;
        when "01"=>
            rc <= to_stdlogicvector(abs(to_pfloat(ra)));
        when "10"=>
            rc <= to_stdlogicvector(-to_pfloat(ra));
        when "11"=>
            rc <= to_stdlogicvector(-abs(to_pfloat(ra)));
        when others=>
            null;
        end case;
    end process;
end architecture;