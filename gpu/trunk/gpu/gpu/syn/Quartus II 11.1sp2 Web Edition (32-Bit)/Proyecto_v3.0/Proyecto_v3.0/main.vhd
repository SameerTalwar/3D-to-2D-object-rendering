-- Diego Andrés González Idárraga

library ieee;
use ieee.std_logic_1164.all;

entity main is
    port(
        CLK_50        : in std_logic;
        reset_reset_n : in std_logic;
        
        sdram_0_wire_addr  : out   std_logic_vector(12 downto 0);
        sdram_0_wire_dq    : inout std_logic_vector(15 downto 0);
        sdram_0_wire_ba    : out   std_logic_vector(1 downto 0);
        sdram_0_wire_dqm   : out   std_logic_vector(1 downto 0);
        sdram_0_wire_ras_n : out   std_logic;
        sdram_0_wire_cas_n : out   std_logic;
        sdram_0_wire_cke   : out   std_logic;
        DRAM0_CLK          : out   std_logic;
        sdram_0_wire_we_n  : out   std_logic;
        sdram_0_wire_cs_n  : out   std_logic;
        
        lcd_0_external_data : inout std_logic_vector(7 downto 0);
        lcd_0_external_RW   : out   std_logic;
        lcd_0_external_E    : out   std_logic;
        lcd_0_external_RS   : out   std_logic;
        LCD_ON              : out   std_logic;
        LCD_BLON            : out   std_logic;
        
        PS2_KBCLK : inout std_logic;
        PS2_KBDAT : inout std_logic;
        
        PS2_MSCLK : inout std_logic;
        PS2_MSDAT : inout std_logic;
        
        sdram_1_wire_addr  : out   std_logic_vector(12 downto 0);
        sdram_1_wire_dq    : inout std_logic_vector(15 downto 0);
        sdram_1_wire_ba    : out   std_logic_vector(1 downto 0);
        sdram_1_wire_dqm   : out   std_logic_vector(1 downto 0);
        sdram_1_wire_ras_n : out   std_logic;
        sdram_1_wire_cas_n : out   std_logic;
        sdram_1_wire_cke   : out   std_logic;
        DRAM1_CLK          : out   std_logic;
        sdram_1_wire_we_n  : out   std_logic;
        sdram_1_wire_cs_n  : out   std_logic;
        
        video_sync_generator_0_sync_RGB_OUT : out    std_logic_vector(23 downto 0);
        VGA_R                               : out    std_logic_vector(1 downto 0);
        VGA_G                               : out    std_logic_vector(1 downto 0);
        VGA_B                               : out    std_logic_vector(1 downto 0);
        VGA_CLK                             : out    std_logic;
        video_sync_generator_0_sync_DEN     : out    std_logic;
        video_sync_generator_0_sync_HD      : buffer std_logic;
        video_sync_generator_0_sync_VD      : buffer std_logic;
        VGA_SYNC                            : out    std_logic
    );
end entity;

architecture rtl of main is
    component pll is
        port(
            inclk0 : in  std_logic;

            c0 : out std_logic;
            c1 : out std_logic
        );
    end component;

    signal CLK_100 : std_logic;
    signal CLK_25  : std_logic;
    
    component Proyecto is
        port(
            clk_clk                   : in std_logic;
            clock_bridge_0_in_clk_clk : in std_logic;
            clock_bridge_1_in_clk_clk : in std_logic;
            reset_reset_n             : in std_logic;
            
            sdram_0_wire_addr  : out   std_logic_vector(12 downto 0);
            sdram_0_wire_dq    : inout std_logic_vector(15 downto 0);
            sdram_0_wire_ba    : out   std_logic_vector(1 downto 0);
            sdram_0_wire_dqm   : out   std_logic_vector(1 downto 0);
            sdram_0_wire_ras_n : out   std_logic;
            sdram_0_wire_cas_n : out   std_logic;
            sdram_0_wire_cke   : out   std_logic;
            sdram_0_wire_we_n  : out   std_logic;
            sdram_0_wire_cs_n  : out   std_logic;
            
            lcd_0_external_data : inout std_logic_vector(7 downto 0);
            lcd_0_external_RW   : out   std_logic;
            lcd_0_external_E    : out   std_logic;
            lcd_0_external_RS   : out   std_logic;
            
            ps2_0_conduit_end_clock : inout std_logic;
            ps2_0_conduit_end_data  : inout std_logic;
            
            ps2_1_conduit_end_clock : inout std_logic;
            ps2_1_conduit_end_data  : inout std_logic;
            
            sdram_1_wire_addr  : out   std_logic_vector(12 downto 0);
            sdram_1_wire_dq    : inout std_logic_vector(15 downto 0);
            sdram_1_wire_ba    : out   std_logic_vector(1 downto 0);
            sdram_1_wire_dqm   : out   std_logic_vector(1 downto 0);
            sdram_1_wire_ras_n : out   std_logic;
            sdram_1_wire_cas_n : out   std_logic;
            sdram_1_wire_cke   : out   std_logic;
            sdram_1_wire_we_n  : out   std_logic;
            sdram_1_wire_cs_n  : out   std_logic;
            
            video_sync_generator_0_sync_RGB_OUT : out std_logic_vector(23 downto 0);
            video_sync_generator_0_sync_DEN     : out std_logic;
            video_sync_generator_0_sync_HD      : out std_logic;
            video_sync_generator_0_sync_VD      : out std_logic
        );
    end component;
begin
    u0 : pll
    port map(
        inclk0=> CLK_50,

        c0=> CLK_100,
        c1=> CLK_25
    );

    u1 : Proyecto
    port map(
        clk_clk=>                   CLK_100,
        clock_bridge_0_in_clk_clk=> CLK_25,
        clock_bridge_1_in_clk_clk=> CLK_50,
        reset_reset_n=>             reset_reset_n,
        
        sdram_0_wire_addr=>  sdram_0_wire_addr,
        sdram_0_wire_dq=>    sdram_0_wire_dq,
        sdram_0_wire_ba=>    sdram_0_wire_ba,
        sdram_0_wire_dqm=>   sdram_0_wire_dqm,
        sdram_0_wire_ras_n=> sdram_0_wire_ras_n,
        sdram_0_wire_cas_n=> sdram_0_wire_cas_n,
        sdram_0_wire_cke=>   sdram_0_wire_cke,
        sdram_0_wire_we_n=>  sdram_0_wire_we_n,
        sdram_0_wire_cs_n=>  sdram_0_wire_cs_n,
        
        lcd_0_external_data=> lcd_0_external_data,
        lcd_0_external_RW=>   lcd_0_external_RW,
        lcd_0_external_E=>    lcd_0_external_E,
        lcd_0_external_RS=>   lcd_0_external_RS,
        
        ps2_0_conduit_end_clock=> PS2_KBCLK,
        ps2_0_conduit_end_data=>  PS2_KBDAT,
        
        ps2_1_conduit_end_clock=> PS2_MSCLK,
        ps2_1_conduit_end_data=>  PS2_MSDAT,
        
        sdram_1_wire_addr=>  sdram_1_wire_addr,
        sdram_1_wire_dq=>    sdram_1_wire_dq,
        sdram_1_wire_ba=>    sdram_1_wire_ba,
        sdram_1_wire_dqm=>   sdram_1_wire_dqm,
        sdram_1_wire_ras_n=> sdram_1_wire_ras_n,
        sdram_1_wire_cas_n=> sdram_1_wire_cas_n,
        sdram_1_wire_cke=>   sdram_1_wire_cke,
        sdram_1_wire_we_n=>  sdram_1_wire_we_n,
        sdram_1_wire_cs_n=>  sdram_1_wire_cs_n,
        
        video_sync_generator_0_sync_RGB_OUT=> video_sync_generator_0_sync_RGB_OUT,
        video_sync_generator_0_sync_DEN=>     video_sync_generator_0_sync_DEN,
        video_sync_generator_0_sync_HD=>      video_sync_generator_0_sync_HD,
        video_sync_generator_0_sync_VD=>      video_sync_generator_0_sync_VD
    );
    
    DRAM0_CLK <= CLK_100;
    
    LCD_ON   <= '1';
    LCD_BLON <= '1';
    
    DRAM1_CLK <= CLK_100;
    
    VGA_R    <= (others=> '0');
    VGA_G    <= (others=> '0');
    VGA_B    <= (others=> '0');
    VGA_CLK  <= CLK_25;
    VGA_SYNC <= not(video_sync_generator_0_sync_HD xor video_sync_generator_0_sync_VD);
end architecture;