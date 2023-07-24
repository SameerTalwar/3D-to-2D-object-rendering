-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pfloat_pkg.all;

entity u32tof is
    generic(
        DATAC_REG : boolean := true
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        datab : in  std_logic_vector(31 downto 0);
        datac : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of u32tof is
begin
    process(clk, reset, cke,
            datab)
    begin
        if DATAC_REG and (reset = '1') then
            datac <= (others=> '0');
        elsif not(DATAC_REG) or (rising_edge(clk) and (cke = '1')) then
            datac <= to_stdlogicvector(to_pfloat(unsigned(datab), 4));
        end if;
    end process;
end architecture;