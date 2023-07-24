library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gpu_pkg.all;

entity core_arbiter is
    generic(
        CORES : positive := 4
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        cke   : in std_logic;
        
        start_core_array : in  std_logic_vector(0 to CORES-1);
        pc_array         : in  address_array(0 to CORES-1);
        stop_core_array  : in  std_logic_vector(0 to CORES-1);
        core_count       : out unsigned(31 downto 0);
        
        pc_aload_array : out std_logic_vector(0 to CORES-1);
        pc_adata       : out unsigned(31 downto 0);
        reset_array    : out std_logic_vector(0 to CORES-1);
        cke_array      : out std_logic_vector(0 to CORES-1);
        
        address_array   : in address_array(0 to CORES-1);
        read_array      : in std_logic_vector(0 to CORES-1);
        write_array     : in std_logic_vector(0 to CORES-1);
        writedata_array : in data_array(0 to CORES-1);
        
        address   : out unsigned(31 downto 0);
        read      : out std_logic;
        write     : out std_logic;
        writedata : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of core_arbiter is
    signal request_array : std_logic_vector(0 to CORES-1);
    signal core          : natural range 0 to CORES-1;
    signal core_array    : std_logic_vector(0 to CORES-1);
    
    function new_core(
        core_array : std_logic_vector;
        core       : natural
    ) return natural is
    begin
        if core_array'length = 0 then
            return core;
        else
            if core_array(core_array'low) = '0' then
                return core_array'low;
            else
                return new_core(core_array(core_array'low+1 to core_array'high), core);
            end if;
        end if;
    end function;
    
    function next_core(
        request_array : std_logic_vector(0 to CORES-1);
        core          : natural range 0 to CORES-1;
        bias          : integer := 1
    ) return natural is
    begin
        if bias = 0 then
            return core;
        elsif core+bias = CORES then
            return next_core(request_array, core, -core);
        else
            if request_array(core+bias) = '1' then
                return core+bias;
            else
                return next_core(request_array, core, bias+1);
            end if;
        end if;
    end function;
    
    function count(core_array : std_logic_vector) return unsigned is
        variable core_count   : unsigned(31 downto 0)                      := to_unsigned(0, 32);
        alias    core_array_1 : std_logic_vector(core_array'reverse_range) is core_array;
    begin
        for i in core_array_1'range loop
            core_count := core_count+unsigned(core_array_1(i downto i));
        end loop;
        
        return core_count;
    end function;
begin
    process(clk, reset, cke,
            start_core_array, pc_array, stop_core_array,
            address_array, read_array, write_array, writedata_array,
            request_array, core, core_array)
        type next_core_1_t is array(0 to CORES-1) of natural;
        
        variable next_core_1 : next_core_1_t;
        variable new_core_1  : natural;
    begin
        request_array <= start_core_array or read_array or write_array;
        new_core_1 := new_core(core_array, core);
        
        if reset = '1' then
            core <= 0;
            core_array <= (others=> '0');
            core_array(0) <= '1'; -- corregir
            pc_aload_array <= (others=> '0');
            pc_adata <= (others=> '0');
        elsif rising_edge(clk) and (cke = '1') then
            for i in 0 to CORES-1 loop
                next_core_1(i) := next_core(request_array, i);
            end loop;
            
            core <= next_core_1(core);
            
            if start_core_array(core) = '1' then
                core_array(new_core_1) <= '1';
            end if;
            
            for i in 0 to CORES-1 loop
                if stop_core_array(i) = '1' then
                    core_array(i) <= '0';
                end if;
            end loop;
            
            pc_aload_array <= (others=> '0');
            pc_aload_array(new_core_1) <= start_core_array(core);
            pc_adata <= pc_array(core);
        end if;
        
        core_count <= count(core_array);
        reset_array <= (others=> '0');
        reset_array(new_core_1) <= start_core_array(core);
        cke_array <= core_array and not(request_array);
        cke_array(core) <= core_array(core) and cke;
        address <= address_array(core);
        read <= read_array(core);
        write <= write_array(core);
        writedata <= writedata_array(core);
    end process;
end architecture;