-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pkg.all;

entity portc_tristate_bridge is
    generic(
        PORTS : natural := 2
    );
    port(
        iaddrc : in addrc_t(0 to PORTS-1);
        iwec   : in std_logic_vector(0 to PORTS-1);
        idatac : in datac_t(0 to PORTS-1);
        
        oaddrc : out unsigned(4 downto 0);
        owec   : out std_logic;
        odatac : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of portc_tristate_bridge is
begin
    u0 : for i in 0 to PORTS-1 generate
        oaddrc <= iaddrc(i) when iwec(i) = '1' else (others=> 'Z');
        odatac <= idatac(i) when iwec(i) = '1' else (others=> 'Z');
    end generate;
    
    process(iwec)
        variable owec_1 : std_logic;
    begin
        owec_1 := '0';
        for i in 0 to PORTS-1 loop
            owec_1 := owec_1 or iwec(i);
        end loop;
        owec <= owec_1;
    end process;
end architecture;