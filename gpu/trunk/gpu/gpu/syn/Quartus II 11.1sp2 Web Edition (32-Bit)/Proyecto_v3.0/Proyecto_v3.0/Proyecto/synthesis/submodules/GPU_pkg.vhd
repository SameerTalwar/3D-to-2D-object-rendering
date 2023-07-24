library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package gpu_pkg is
    type address_array is array(natural range <>) of unsigned(31 downto 0);
    type data_array    is array(natural range <>) of std_logic_vector(31 downto 0);
    
    component instruction_memory is
        generic(
            ADDR_WIDTH  : natural;
            MEMORY_INIT : data_array
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
    end component;
    
    component core_arbiter is
        generic(
            CORES : positive
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
    end component;
    
    component gpu is
        generic(
            AVS_S0_ADDRESS_WIDTH : natural range 0 to 32;
            CORES                : positive
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            
            avs_s0_address   : in  std_logic_vector(AVS_S0_ADDRESS_WIDTH-1 downto 0);
            avs_s0_write     : in  std_logic;
            avs_s0_writedata : in  std_logic_vector(31 downto 0);
            
            avm_m0_address     : out    std_logic_vector(31 downto 0);
            avm_m0_read        : buffer std_logic;
            avm_m0_readdata    : in     std_logic_vector(31 downto 0);
            avm_m0_write       : buffer std_logic;
            avm_m0_writedata   : out    std_logic_vector(31 downto 0);
            avm_m0_waitrequest : in     std_logic
        );
    end component;
end package;