-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.pfloat_pkg.all;

entity div is
    generic(
        DATA_WIDTH : positive := 24;
        LATENCY    : natural  := 13
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        x1 : in unsigned(DATA_WIDTH-1 downto 0);
        x2 : in unsigned(DATA_WIDTH-1 downto 0);
        
        y      : out unsigned(DATA_WIDTH downto 0);
        round  : out std_logic;
        sticky : out std_logic
    );
end entity;

architecture rtl of div is
    type div_reg_t is array(DATA_WIDTH+2 downto 0) of unsigned(DATA_WIDTH+1 downto 0);
    type y_reg_t   is array(DATA_WIDTH+2 downto 0) of unsigned(DATA_WIDTH+2 downto 0);
    type x_reg_t   is array(DATA_WIDTH+2 downto 0) of unsigned(DATA_WIDTH-1 downto 0);
    
    signal div_reg : div_reg_t;
    signal y_reg   : y_reg_t;
    signal x2_reg  : x_reg_t;
    
    constant latency_1 : natural := maximum(0, LATENCY-(DATA_WIDTH+2));
    
    type y_1_t          is array(latency_1 downto 0) of unsigned(DATA_WIDTH downto 0);
    type round_sticky_t is array(latency_1 downto 0) of std_logic;
    
    signal y_1      : y_1_t;
    signal round_1  : round_sticky_t;
    signal sticky_1 : round_sticky_t;
begin
    process(clk, cke, reset,
            x1, x2,
            div_reg, y_reg, x2_reg,
            y_1, round_1, sticky_1)
        variable x1_var  : unsigned(DATA_WIDTH+1 downto 0);
        variable reg     : boolean;
        variable div_var : unsigned(DATA_WIDTH+1 downto 0);
    begin
        div_reg(DATA_WIDTH+2) <= "100"&x1(DATA_WIDTH-1 downto 1);
        x1_var := (others=> '0');
        x1_var(DATA_WIDTH+1) := x1(0);
        y_reg(DATA_WIDTH+2)(DATA_WIDTH+2) <= '1';
        x2_reg(DATA_WIDTH+2) <= x2;
        
        for i in DATA_WIDTH+1 downto 0 loop
            reg := (LATENCY /= 0) and ((real(DATA_WIDTH+2-i) mod (real(DATA_WIDTH+2)/real(LATENCY))) < 1.0);
            
            if reg and (reset = '1') then
                y_reg(i)(DATA_WIDTH+1 downto i+1) <= (others=> '0');
                div_reg(i) <= (others=> '0');
                x2_reg(i) <= (others=> '0');
                
                if i = 0 then
                    sticky_1(0) <= '0';
                end if;
            elsif not(reg) or (rising_edge(clk) and (cke = '1')) then
                y_reg(i)(DATA_WIDTH+1 downto i+1) <= y_reg(i+1)(DATA_WIDTH+1 downto i+1);
                div_var := add_sub_f(div_reg(i+1)(DATA_WIDTH-1 downto 0)&x1_var(i), '0'&x2_reg(i+1), y_reg(i+1)(i+1));
                div_reg(i) <= div_var;
                x2_reg(i) <= x2_reg(i+1);
                
                if i = 0 then
                    if div_var(DATA_WIDTH+1) = '0' then
                        sticky_1(0) <= or_reduce(div_reg(i+1)(DATA_WIDTH-2 downto 0)&x1_var(i));
                    else
                        sticky_1(0) <= or_reduce(div_var(DATA_WIDTH-1 downto 0));
                    end if;
                end if;
            end if;
            
            y_reg(i)(i) <= div_reg(i)(DATA_WIDTH+1);
        end loop;
        
        y_1(0) <= y_reg(0)(DATA_WIDTH+1 downto 1);
        round_1(0) <= y_reg(0)(0);
        
        for i in 1 to latency_1 loop
            if reset = '1' then
                y_1(i) <= (others=> '0');
                round_1(i) <= '0';
                sticky_1(i) <= '0';
            elsif rising_edge(clk) and (cke = '1') then
                y_1(i) <= y_1(i-1);
                round_1(i) <= round_1(i-1);
                sticky_1(i) <= sticky_1(i-1);
            end if;
        end loop;
        
        y <= y_1(latency_1);
        round <= round_1(latency_1);
        sticky <= sticky_1(latency_1);
    end process;
end architecture;