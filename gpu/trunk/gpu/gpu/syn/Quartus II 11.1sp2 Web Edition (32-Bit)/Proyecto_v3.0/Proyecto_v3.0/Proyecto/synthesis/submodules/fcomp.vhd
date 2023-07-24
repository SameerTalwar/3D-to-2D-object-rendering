library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pfloat_pkg.all;

entity fcomp is
    generic(
        USE_SUBNORMAL : boolean := false;
        LATENCY       : natural := 1
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        sel : in std_logic;
        
        x1 : in pfloat;
        x2 : in pfloat;
        
        x1_l_x2   : out std_logic;
        x1_le_x2  : out std_logic;
        x1_e_x2   : out std_logic;
        x1_ge_x2  : out std_logic;
        x1_g_x2   : out std_logic;
        x1_ne_x2  : out std_logic;
        unordered : out std_logic;
        
        y : out pfloat
    );
end entity;

architecture rtl of fcomp is
    type x1_comp_x2_1_t is array(0 to LATENCY) of std_logic_vector(6 downto 0);
    type y_1_t is array(0 to LATENCY) of pfloat;
    
    signal x1_comp_x2 : x1_comp_x2_1_t;
    signal y_1 : y_1_t;
begin
    process(clk, reset, cke, sel, x1, x2, x1_comp_x2, y_1)
        type comp_t is (nanx1, nanx2, less, equal, greater);
        type x1_x2_t is (isx1, isx2);
        
        variable x1_c, x2_c : pfloat_c;
        variable comp : comp_t;
        variable x1_x2 : x1_x2_t;
    begin
        x1_c := to_pfloat_c(x1, USE_SUBNORMAL);
        x2_c := to_pfloat_c(x2, USE_SUBNORMAL);
        
        if x1_c.nan then
            comp := nanx1;
        elsif x2_c.nan then
            comp := nanx2;
        elsif x1_c.zero and x2_c.zero then
            comp := equal;
        elsif (x1.sign xor x2.sign) = '1' then
            if x1.sign = '1' then
                comp := less;
            else
                comp := greater;
            end if;
        else
            if x1.exponent < x2.exponent then
                if x1.sign = '1' then
                    comp := greater;
                else
                    comp := less;
                end if;
            elsif x1.exponent = x2.exponent then
                if x1.fraction < x2.fraction then
                    if x1.sign = '1' then
                        comp := greater;
                    else
                        comp := less;
                    end if;
                elsif x1.fraction = x2.fraction then
                    comp := equal;
                else
                    if x1.sign = '1' then
                        comp := less;
                    else
                        comp := greater;
                    end if;
                end if;
            else
                if x1.sign = '1' then
                    comp := less;
                else
                    comp := greater;
                end if;
            end if;
        end if;
        
        case comp is
        when nanx1|nanx2=>
            x1_comp_x2(0) <= "1100000";
        when less=>
            x1_comp_x2(0) <= "0100011";
        when equal=>
            x1_comp_x2(0) <= "0001110";
        when greater=>
            x1_comp_x2(0) <= "0111000";
        end case;
        
        case sel is
        when '0'=>
            case comp is
            when nanx1|greater=>
                x1_x2 := isx2;
            when nanx2|less|equal=>
                x1_x2 := isx1;
            end case;
        when '1'=>
            case comp is
            when nanx1|less|equal=>
                x1_x2 := isx2;
            when nanx2|greater=>
                x1_x2 := isx1;
            end case;
        when others=>
            null;
        end case;
        
        case x1_x2 is
        when isx1=>
            y_1(0) <= x1;
        when isx2=>
            y_1(0) <= x2;
        end case;
        
        for i in 1 to LATENCY loop
            if reset = '1' then
                x1_comp_x2(i) <= (others=> '0');
                y_1(i) <= ('0', (others=> '0'), (others=> '0'));
            elsif rising_edge(clk) and (cke = '1') then
                x1_comp_x2(i) <= x1_comp_x2(i-1);
                y_1(i) <= y_1(i-1);
            end if;
        end loop;
        
        x1_l_x2 <= x1_comp_x2(LATENCY)(0);
        x1_le_x2 <= x1_comp_x2(LATENCY)(1);
        x1_e_x2 <= x1_comp_x2(LATENCY)(2);
        x1_ge_x2 <= x1_comp_x2(LATENCY)(3);
        x1_g_x2 <= x1_comp_x2(LATENCY)(4);
        x1_ne_x2 <= x1_comp_x2(LATENCY)(5);
        unordered <= x1_comp_x2(LATENCY)(6);
        y <= y_1(LATENCY);
    end process;
end architecture;