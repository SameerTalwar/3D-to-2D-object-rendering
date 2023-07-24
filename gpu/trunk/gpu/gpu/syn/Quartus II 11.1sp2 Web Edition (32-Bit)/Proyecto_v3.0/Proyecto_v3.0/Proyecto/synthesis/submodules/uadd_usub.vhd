library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.pfloat_pkg.all;

entity uadd_usub is
    port(
        ra    : in std_logic_vector(31 downto 0);
        sel   : in std_logic;
        p2_rb : in std_logic;
        p2    : in unsigned(4 downto 0);
        rb    : in std_logic_vector(31 downto 0);
        
        rc : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of uadd_usub is
begin
    process(ra, sel, p2_rb, p2, rb)
        variable rb_1 : unsigned(31 downto 0);
        variable rc_1 : unsigned(32 downto 0);
    begin
        case p2_rb is
        when '0'=>
            rb_1 := (others=> '0');
            rb_1(to_integer(p2)) := '1';
        when '1'=>
            rb_1 := unsigned(rb);
        when others=>
            null;
        end case;
        
        rc_1 := add_sub_f(unsigned(ra), rb_1, sel);
        rc <= std_logic_vector(rc_1(31 downto 0));
    end process;
end architecture;