library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gpu_pkg.all;

entity instruction_memory is
    generic(
        ADDR_WIDTH  : natural    := 10;
        MEMORY_INIT : data_array := (0 to -1 => (others=> '0'))
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        
        re    : in  std_logic;
        raddr : in  unsigned(ADDR_WIDTH-1 downto 0);
        rdata : out std_logic_vector(31 downto 0);
        
        we    : in std_logic;
        waddr : in unsigned(ADDR_WIDTH-1 downto 0);
        wdata : in std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of instruction_memory is
    function memory_init_f return data_array is
        variable memory : data_array(0 to 2**ADDR_WIDTH-1);
    begin
        for i in MEMORY_INIT'range loop
            if i < 2**ADDR_WIDTH then
                memory(i) := MEMORY_INIT(i);
            end if;
        end loop;
        
        return memory;
    end function;
    
    signal memory : data_array(0 to 2**ADDR_WIDTH-1) := memory_init_f;
begin
    process(clk, reset,
            re, raddr,
            we, waddr, wdata,
            memory)
    begin
        if reset = '1' then
            rdata <= (others=> '0');
        elsif rising_edge(clk) and (re = '1') then
            rdata <= memory(to_integer(raddr));
        end if;
        
        if rising_edge(clk) and (we = '1') then
            memory(to_integer(waddr)) <= wdata;
        end if;
    end process;
end architecture;