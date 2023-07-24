-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pfloat_pkg.all;

package core_pkg is
    component registers is
        generic(
            ADDR_WIDTH : natural;
            DATA_WIDTH : natural;
            USE_RESET  : boolean
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            cke   : in std_logic;
            
            addra : in  unsigned(ADDR_WIDTH-1 downto 0);
            dataa : out std_logic_vector(DATA_WIDTH-1 downto 0);
            
            addrb : in  unsigned(ADDR_WIDTH-1 downto 0);
            datab : out std_logic_vector(DATA_WIDTH-1 downto 0);
            
            addrc : in unsigned(ADDR_WIDTH-1 downto 0);
            wec   : in std_logic;
            datac : in std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;
    
    component ftou8 is
        generic(
            DATAC_REG : boolean
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            cke   : in std_logic;
            
            dataa       : in std_logic_vector(31 downto 0);
            ll_lh_hl_hh : in std_logic_vector(1 downto 0);
            datab       : in std_logic_vector(31 downto 0);
            
            datac : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component ftou16 is
        generic(
            DATAC_REG : boolean
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            cke   : in std_logic;
            
            dataa : in std_logic_vector(31 downto 0);
            l_h   : in std_logic;
            datab : in std_logic_vector(31 downto 0);
            
            datac : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component ftou32 is
        generic(
            DATAC_REG : boolean
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            cke   : in std_logic;
            
            dataa : in  std_logic_vector(31 downto 0);
            datac : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component u8tof is
        generic(
            DATAC_REG : boolean
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            cke   : in std_logic;
            
            ll_lh_hl_hh : in std_logic_vector(1 downto 0);
            datab       : in std_logic_vector(31 downto 0);
            
            datac : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component u16tof is
        generic(
            DATAC_REG : boolean
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            cke   : in std_logic;
            
            l_h   : in std_logic;
            datab : in std_logic_vector(31 downto 0);
            
            datac : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component u32tof is
        generic(
            DATAC_REG : boolean
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            cke   : in std_logic;
            
            datab : in  std_logic_vector(31 downto 0);
            datac : out std_logic_vector(31 downto 0)
        );
    end component;
    
    type addrc_t is array(natural range <>) of unsigned(4 downto 0);
    type datac_t is array(natural range <>) of std_logic_vector(31 downto 0);
    
    component portc_tristate_bridge is
        generic(
            PORTS : natural
        );
        port(
            iaddrc : in addrc_t(PORTS-1 downto 0);
            iwec   : in std_logic_vector(PORTS-1 downto 0);
            idatac : in datac_t(PORTS-1 downto 0);
            
            oaddrc : out unsigned(4 downto 0);
            owec   : out std_logic;
            odatac : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component core is
        generic(
            USE_SUBNORMAL       : boolean;
            ROUND_STYLE         : float_round_style;
            DEDICATED_REGISTERS : boolean;
            LATENCY_1           : boolean;
            FADD_LATENCY        : natural;
            EMBEDDED_MULTIPLIER : boolean;
            FMUL_LATENCY        : natural;
            FDIV_LATENCY        : natural;
            FCOMP_LATENCY       : natural
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            cke   : in std_logic;
            
            pc          : buffer unsigned(31 downto 0);
            instruction : in     std_logic_vector(31 downto 0);
            
            address   : out    unsigned(31 downto 0);
            read      : buffer std_logic;
            readdata  : in     std_logic_vector(31 downto 0);
            write     : buffer std_logic;
            writedata : out    std_logic_vector(31 downto 0);
            
            stop_core : out std_logic;
            irq       : out std_logic
        );
    end component;
end package;