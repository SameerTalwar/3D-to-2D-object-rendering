-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pfloat_pkg.all;

entity add_sub is
    generic(
        DATA_WIDTH : positive := 24;
        SHIFT_MAX  : natural  := 255;
        LATENCY    : natural  := 1
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        sel   : in std_logic;
        x1    : in unsigned(DATA_WIDTH-1 downto 0);
        x2    : in unsigned(DATA_WIDTH-1 downto 0);
        shift : in natural range 0 to SHIFT_MAX;
        
        y      : out unsigned(DATA_WIDTH+1 downto 0);
        round  : out std_logic;
        sticky : out std_logic
    );
end entity;

architecture rtl of add_sub is
    type y_1_t          is array(0 to LATENCY) of unsigned(DATA_WIDTH+1 downto 0);
    type round_sticky_t is array(0 to LATENCY) of std_logic;
    
    signal y_1      : y_1_t;
    signal round_1  : round_sticky_t;
    signal sticky_1 : round_sticky_t;
begin
    process(clk, cke, reset,
            sel, x1, x2, shift,
            y_1, round_1, sticky_1)
        variable a    : unsigned(DATA_WIDTH+1 downto 0);
        variable b    : unsigned(DATA_WIDTH+2 downto 0);
        variable c    : std_logic;
        variable x2_1 : unsigned(DATA_WIDTH+1 downto 0);
        variable y_2  : unsigned(DATA_WIDTH+3 downto 0);
    begin
        a := (others=> '1');
        a := not(shift_left(a, shift));
        b := (others=> sel);
        c := sel and not(sticky_1(0));
        x2_1 := shift_right(x2&"00", shift);
        y_2 := ('0'&x1&"00"&c)+((('0'&x2_1) xor b)&c);
        y_1(0) <= y_2(DATA_WIDTH+3 downto 2);
        round_1(0) <= y_2(1);
        sticky_1(0) <= or_reduce(x2 and a(DATA_WIDTH+1 downto 2));
        
        for i in 1 to LATENCY loop
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
        
        y <= y_1(LATENCY);
        round <= round_1(LATENCY);
        sticky <= sticky_1(LATENCY);
    end process;
end architecture;