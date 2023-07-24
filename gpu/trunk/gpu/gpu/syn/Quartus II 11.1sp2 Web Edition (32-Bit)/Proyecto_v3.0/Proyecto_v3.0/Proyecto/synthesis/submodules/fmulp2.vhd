-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pfloat_pkg.all;

entity fmulp2 is
    generic(
        USE_SUBNORMAL : boolean := false;
        LATENCY       : natural := 1
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        x1        : in pfloat;
        exponent2 : in signed(8 downto 0);
        
        y : out pfloat
    );
end entity;

architecture rtl of fmulp2 is
    type y_1_t is array(LATENCY downto 0) of pfloat;
    
    signal y_1 : y_1_t;
begin
    process(clk, reset, cke,
            x1, exponent2,
            y_1)
        variable x1_c : pfloat_c;
        variable fraction1 : unsigned(23 downto 0);
        variable shift1 : natural;
        variable bias : natural;
        variable exponent : signed(9 downto 0);
    begin
        x1_c := to_pfloat_c(x1, USE_SUBNORMAL);
        
        if USE_SUBNORMAL then
            fraction1 := x1_c.exponent_or_reduce&x1.fraction;
            shift1 := shift_calc(fraction1, 3).i;
        else
            fraction1 := '1'&x1.fraction;
            shift1 := 0;
        end if;
        
        if x1_c.subnormal then
            bias := 1;
        else
            bias := 0;
        end if;
        
        exponent := signed("00"&x1.exponent)+exponent2+bias;
        
        if x1_c.nan then -- nan*x : nan
            y_1(0) <= NAN;
        else
            y_1(0) <= to_pfloat(x1.sign, exponent, fraction1, shift1,
                                round_toward_zero, '0', '0',
                                x1_c.zero, -- 0*x = 0
                                x1_c.infinity, -- inf*x = inf
                                USE_SUBNORMAL);
        end if;
        
        for i in 1 to LATENCY loop
            if reset = '1' then
                y_1(i) <= ('0', (others=> '0'), (others=> '0'));
            elsif rising_edge(clk) and (cke = '1') then
                y_1(i) <= y_1(i-1);
            end if;
        end loop;
        
        y <= y_1(LATENCY);
    end process;
end architecture;