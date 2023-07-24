-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;

use work.pfloat_pkg.all;

entity ftou32 is
    generic(
        DATAC_REG : boolean := true
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        dataa : in  std_logic_vector(31 downto 0);
        datac : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of ftou32 is
begin
    process(clk, reset, cke,
            dataa)
    begin
        if DATAC_REG and (reset = '1') then
            datac <= (others=> '0');
        elsif not(DATAC_REG) or (rising_edge(clk) and (cke = '1')) then
            datac <= std_logic_vector(to_unsigned(to_pfloat(dataa), 32));
        end if;
    end process;
end architecture;