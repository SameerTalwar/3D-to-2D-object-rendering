// Diego Andrés González Idárraga

#ifndef ps2_h
#define ps2_h

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <time.h>

#ifdef __cplusplus
extern "C" {
#endif

void ps2_irq(void *, uint32_t);
void ps2_ic_isr(void *);

typedef enum _PS2_DEVICE {
	PS2_KEYBOARD,
	PS2_MOUSE,
	PS2_UNKNOWN,
} PS2_DEVICE;

typedef enum _PS2_MAKE_BREAK {
	PS2_BREAK = 0,
	PS2_MAKE  = 1,
} PS2_MAKE_BREAK;

typedef enum _PS2_SET {
	PS2_SET_1 = 1,
	PS2_SET_2 = 2,
	PS2_SET_3 = 3,
} PS2_SET;

typedef enum _PS2_SET_1_SCAN_CODE {
    PS2_S1_A            = 0x1E,
    PS2_S1_B            = 0x30,
    PS2_S1_C            = 0x2E,
    PS2_S1_D            = 0x20,
    PS2_S1_E            = 0x12,
    PS2_S1_F            = 0x21,
    PS2_S1_G            = 0x22,
    PS2_S1_H            = 0x23,
    PS2_S1_I            = 0x17,
    PS2_S1_J            = 0x24,
    PS2_S1_K            = 0x25,
    PS2_S1_L            = 0x26,
    PS2_S1_M            = 0x32,
    PS2_S1_N            = 0x31,
    PS2_S1_O            = 0x18,
    PS2_S1_P            = 0x19,
    PS2_S1_Q            = 0x10,
    PS2_S1_R            = 0x13,
    PS2_S1_S            = 0x1F,
    PS2_S1_T            = 0x14,
    PS2_S1_U            = 0x16,
    PS2_S1_V            = 0x2F,
    PS2_S1_W            = 0x11,
    PS2_S1_X            = 0x2D,
    PS2_S1_Y            = 0x15,
    PS2_S1_Z            = 0x2C,
    PS2_S1_0            = 0x0B,
    PS2_S1_1            = 0x02,
    PS2_S1_2            = 0x03,
    PS2_S1_3            = 0x04,
    PS2_S1_4            = 0x05,
    PS2_S1_5            = 0x06,
    PS2_S1_6            = 0x07,
    PS2_S1_7            = 0x08,
    PS2_S1_8            = 0x09,
    PS2_S1_9            = 0x0A,
    PS2_S1_GRAVE_ACCENT = 0x29,
    PS2_S1_MINUS        = 0x0C,
    PS2_S1_EQUAL        = 0x0D,
    PS2_S1_BACKSLASH    = 0x2B,
    PS2_S1_BKSP         = 0x0E,
    PS2_S1_SPACE        = 0x39,
    PS2_S1_TAB          = 0x0F,
    PS2_S1_CAPS         = 0x3A,
    PS2_S1_L_SHFT       = 0x2A,
    PS2_S1_L_CTRL       = 0x1D,
    PS2_S1_L_GUI        = 0xE05B,
    PS2_S1_L_ALT        = 0x38,
    PS2_S1_R_SHFT       = 0x36,
    PS2_S1_R_CTRL       = 0xE01D,
    PS2_S1_R_GUI        = 0xE05C,
    PS2_S1_R_ALT        = 0xE038,
    PS2_S1_APPS         = 0xE05D,
    PS2_S1_ENTER        = 0x1C,

    PS2_S1_ESC = 0x01,

    PS2_S1_F1 = 0x3B,
    PS2_S1_F2 = 0x3C,
    PS2_S1_F3 = 0x3D,
    PS2_S1_F4 = 0x3E,

    PS2_S1_F5 = 0x3F,
    PS2_S1_F6 = 0x40,
    PS2_S1_F7 = 0x41,
    PS2_S1_F8 = 0x42,

    PS2_S1_F9  = 0x43,
    PS2_S1_F10 = 0x44,
    PS2_S1_F11 = 0x57,
    PS2_S1_F12 = 0x58,

    PS2_S1_PRNT_SCRN = 0xE02AE037,
    PS2_S1_SCROLL    = 0x46,
    PS2_S1_PAUSE     = 0xE11D45,

    PS2_S1_L_BRACKET = 0x1A,

    PS2_S1_INSERT = 0xE052,
    PS2_S1_HOME   = 0xE047,
    PS2_S1_PG_UP  = 0xE049,
    PS2_S1_DELETE = 0xE053,
    PS2_S1_END    = 0xE04F,
    PS2_S1_PG_DN  = 0xE051,

    PS2_S1_U_ARROW = 0xE048,
    PS2_S1_L_ARROW = 0xE04B,
    PS2_S1_D_ARROW = 0xE050,
    PS2_S1_R_ARROW = 0xE04D,

    PS2_S1_NUM         = 0x45,
    PS2_S1_KP_SLASH    = 0xE035,
    PS2_S1_KP_ASTERISK = 0x37,
    PS2_S1_KP_MINUS    = 0x4A,
    PS2_S1_KP_PLUS     = 0x4E,
    PS2_S1_KP_EN       = 0xE01C,
    PS2_S1_KP_DOT      = 0x53,
    PS2_S1_KP_0        = 0x52,
    PS2_S1_KP_1        = 0x4F,
    PS2_S1_KP_2        = 0x50,
    PS2_S1_KP_3        = 0x51,
    PS2_S1_KP_4        = 0x4B,
    PS2_S1_KP_5        = 0x4C,
    PS2_S1_KP_6        = 0x4D,
    PS2_S1_KP_7        = 0x47,
    PS2_S1_KP_8        = 0x48,
    PS2_S1_KP_9        = 0x49,

    PS2_S1_R_BRACKET  = 0x1B,
    PS2_S1_SEMICOLON  = 0x27,
    PS2_S1_APOSTROPHE = 0x28,
    PS2_S1_COMMA      = 0x33,
    PS2_S1_DOT        = 0x34,
    PS2_S1_SLASH      = 0x35,

    PS2_S1_POWER = 0xE05E,
    PS2_S1_SLEEP = 0xE05F,
    PS2_S1_WAKE  = 0xE063,

    PS2_S1_NEXT_TRACK     = 0xE019,
    PS2_S1_PREVIOUS_TRACK = 0xE010,
    PS2_S1_STOP           = 0xE024,
    PS2_S1_PLAY_PAUSE     = 0xE022,
    PS2_S1_MUTE           = 0xE020,
    PS2_S1_VOLUME_UP      = 0xE030,
    PS2_S1_VOLUME_DOWN    = 0xE02E,
    PS2_S1_MEDIA_SELECT   = 0xE06D,
    PS2_S1_E_MAIL         = 0xE06C,
    PS2_S1_CALCULATOR     = 0xE021,
    PS2_S1_MY_COMPUTER    = 0xE06B,
    PS2_S1_WWW_SEARCH     = 0xE065,
    PS2_S1_WWW_HOME       = 0xE032,
    PS2_S1_WWW_BACK       = 0xE06A,
    PS2_S1_WWW_FORWARD    = 0xE069,
    PS2_S1_WWW_STOP       = 0xE068,
    PS2_S1_WWW_REFRESH    = 0xE067,
    PS2_S1_WWW_FAVORITES  = 0xE066,

    PS2_S1_DEFAULT = 0x00,
} PS2_SET_1_SCAN_CODE;

typedef enum _PS2_SET_2_SCAN_CODE {
	PS2_S2_A            = 0x1C,
	PS2_S2_B            = 0x32,
	PS2_S2_C            = 0x21,
	PS2_S2_D            = 0x23,
	PS2_S2_E            = 0x24,
	PS2_S2_F            = 0x2B,
	PS2_S2_G            = 0x34,
	PS2_S2_H            = 0x33,
	PS2_S2_I            = 0x43,
	PS2_S2_J            = 0x3B,
	PS2_S2_K            = 0x42,
	PS2_S2_L            = 0x4B,
	PS2_S2_M            = 0x3A,
	PS2_S2_N            = 0x31,
	PS2_S2_O            = 0x44,
	PS2_S2_P            = 0x4D,
	PS2_S2_Q            = 0x15,
	PS2_S2_R            = 0x2D,
	PS2_S2_S            = 0x1B,
	PS2_S2_T            = 0x2C,
	PS2_S2_U            = 0x3C,
	PS2_S2_V            = 0x2A,
	PS2_S2_W            = 0x1D,
	PS2_S2_X            = 0x22,
	PS2_S2_Y            = 0x35,
	PS2_S2_Z            = 0x1A,
	PS2_S2_0            = 0x45,
	PS2_S2_1            = 0x16,
	PS2_S2_2            = 0x1E,
	PS2_S2_3            = 0x26,
	PS2_S2_4            = 0x25,
	PS2_S2_5            = 0x2E,
	PS2_S2_6            = 0x36,
	PS2_S2_7            = 0x3D,
	PS2_S2_8            = 0x3E,
	PS2_S2_9            = 0x46,
	PS2_S2_GRAVE_ACCENT = 0x0E,
	PS2_S2_MINUS        = 0x4E,
	PS2_S2_EQUAL        = 0x55,
	PS2_S2_BACKSLASH    = 0x5D,
	PS2_S2_BKSP         = 0x66,
	PS2_S2_SPACE        = 0x29,
	PS2_S2_TAB          = 0x0D,
	PS2_S2_CAPS         = 0x58,
	PS2_S2_L_SHFT       = 0x12,
	PS2_S2_L_CTRL       = 0x14,
	PS2_S2_L_GUI        = 0xE01F,
	PS2_S2_L_ALT        = 0x11,
	PS2_S2_R_SHFT       = 0x59,
	PS2_S2_R_CTRL       = 0xE014,
	PS2_S2_R_GUI        = 0xE027,
	PS2_S2_R_ALT        = 0xE011,
	PS2_S2_APPS         = 0xE02F,
	PS2_S2_ENTER        = 0x5A,

	PS2_S2_ESC = 0x76,

	PS2_S2_F1 = 0x05,
	PS2_S2_F2 = 0x06,
	PS2_S2_F3 = 0x04,
	PS2_S2_F4 = 0x0C,

	PS2_S2_F5 = 0x03,
	PS2_S2_F6 = 0x0B,
	PS2_S2_F7 = 0x83,
	PS2_S2_F8 = 0x0A,

	PS2_S2_F9  = 0x01,
	PS2_S2_F10 = 0x09,
	PS2_S2_F11 = 0x78,
	PS2_S2_F12 = 0x07,

	PS2_S2_PRNT_SCRN = 0xE012E07C,
	PS2_S2_SCROLL    = 0x7E,
	PS2_S2_PAUSE     = 0xE11477,

	PS2_S2_L_BRACKET = 0x54,

	PS2_S2_INSERT = 0xE070,
	PS2_S2_HOME   = 0xE06C,
	PS2_S2_PG_UP  = 0xE07D,
	PS2_S2_DELETE = 0xE071,
	PS2_S2_END    = 0xE069,
	PS2_S2_PG_DN  = 0xE07A,

	PS2_S2_U_ARROW = 0xE075,
	PS2_S2_L_ARROW = 0xE06B,
	PS2_S2_D_ARROW = 0xE072,
	PS2_S2_R_ARROW = 0xE074,

	PS2_S2_NUM         = 0x77,
	PS2_S2_KP_SLASH    = 0xE04A,
	PS2_S2_KP_ASTERISK = 0x7C,
	PS2_S2_KP_MINUS    = 0x7B,
	PS2_S2_KP_PLUS     = 0x79,
	PS2_S2_KP_EN       = 0xE05A,
	PS2_S2_KP_DOT      = 0x71,
	PS2_S2_KP_0        = 0x70,
	PS2_S2_KP_1        = 0x69,
	PS2_S2_KP_2        = 0x72,
	PS2_S2_KP_3        = 0x7A,
	PS2_S2_KP_4        = 0x6B,
	PS2_S2_KP_5        = 0x73,
	PS2_S2_KP_6        = 0x74,
	PS2_S2_KP_7        = 0x6C,
	PS2_S2_KP_8        = 0x75,
	PS2_S2_KP_9        = 0x7D,

	PS2_S2_R_BRACKET  = 0x5B,
	PS2_S2_SEMICOLON  = 0x4C,
	PS2_S2_APOSTROPHE = 0x52,
	PS2_S2_COMMA      = 0x41,
	PS2_S2_DOT        = 0x49,
	PS2_S2_SLASH      = 0x4A,

	PS2_S2_POWER = 0xE037,
	PS2_S2_SLEEP = 0xE03F,
	PS2_S2_WAKE  = 0xE05E,

	PS2_S2_NEXT_TRACK     = 0xE04D,
	PS2_S2_PREVIOUS_TRACK = 0xE015,
	PS2_S2_STOP           = 0xE03B,
	PS2_S2_PLAY_PAUSE     = 0xE034,
	PS2_S2_MUTE           = 0xE023,
	PS2_S2_VOLUME_UP      = 0xE032,
	PS2_S2_VOLUME_DOWN    = 0xE021,
	PS2_S2_MEDIA_SELECT   = 0xE050,
	PS2_S2_E_MAIL         = 0xE048,
	PS2_S2_CALCULATOR     = 0xE02B,
	PS2_S2_MY_COMPUTER    = 0xE040,
	PS2_S2_WWW_SEARCH     = 0xE010,
	PS2_S2_WWW_HOME       = 0xE03A,
	PS2_S2_WWW_BACK       = 0xE038,
	PS2_S2_WWW_FORWARD    = 0xE030,
	PS2_S2_WWW_STOP       = 0xE028,
	PS2_S2_WWW_REFRESH    = 0xE020,
	PS2_S2_WWW_FAVORITES  = 0xE018,

	PS2_S2_DEFAULT = 0x00,
} PS2_SET_2_SCAN_CODE;

typedef enum _PS2_SET_3_SCAN_CODE {
    PS2_S3_A            = 0x1C,
    PS2_S3_B            = 0x32,
    PS2_S3_C            = 0x21,
    PS2_S3_D            = 0x23,
    PS2_S3_E            = 0x24,
    PS2_S3_F            = 0x2B,
    PS2_S3_G            = 0x34,
    PS2_S3_H            = 0x33,
    PS2_S3_I            = 0x43,
    PS2_S3_J            = 0x3B,
    PS2_S3_K            = 0x42,
    PS2_S3_L            = 0x4B,
    PS2_S3_M            = 0x3A,
    PS2_S3_N            = 0x31,
    PS2_S3_O            = 0x44,
    PS2_S3_P            = 0x4D,
    PS2_S3_Q            = 0x15,
    PS2_S3_R            = 0x2D,
    PS2_S3_S            = 0x1B,
    PS2_S3_T            = 0x2C,
    PS2_S3_U            = 0x3C,
    PS2_S3_V            = 0x2A,
    PS2_S3_W            = 0x1D,
    PS2_S3_X            = 0x22,
    PS2_S3_Y            = 0x35,
    PS2_S3_Z            = 0x1A,
    PS2_S3_0            = 0x45,
    PS2_S3_1            = 0x16,
    PS2_S3_2            = 0x1E,
    PS2_S3_3            = 0x26,
    PS2_S3_4            = 0x25,
    PS2_S3_5            = 0x2E,
    PS2_S3_6            = 0x36,
    PS2_S3_7            = 0x3D,
    PS2_S3_8            = 0x3E,
    PS2_S3_9            = 0x46,
    PS2_S3_GRAVE_ACCENT = 0x0E,
    PS2_S3_MINUS        = 0x4E,
    PS2_S3_EQUAL        = 0x55,
    PS2_S3_BACKSLASH    = 0x5C,
    PS2_S3_BKSP         = 0x66,
    PS2_S3_SPACE        = 0x29,
    PS2_S3_TAB          = 0x0D,
    PS2_S3_CAPS         = 0x14,
    PS2_S3_L_SHFT       = 0x12,
    PS2_S3_L_CTRL       = 0x11,
    PS2_S3_L_GUI        = 0x8B,
    PS2_S3_L_ALT        = 0x19,
    PS2_S3_R_SHFT       = 0x59,
    PS2_S3_R_CTRL       = 0x58,
    PS2_S3_R_GUI        = 0x8C,
    PS2_S3_R_ALT        = 0x39,
    PS2_S3_APPS         = 0x8D,
    PS2_S3_ENTER        = 0x5A,

    PS2_S3_ESC = 0x08,

    PS2_S3_F1 = 0x07,
    PS2_S3_F2 = 0x0F,
    PS2_S3_F3 = 0x17,
    PS2_S3_F4 = 0x1F,

    PS2_S3_F5 = 0x27,
    PS2_S3_F6 = 0x2F,
    PS2_S3_F7 = 0x37,
    PS2_S3_F8 = 0x3F,

    PS2_S3_F9  = 0x47,
    PS2_S3_F10 = 0x4F,
    PS2_S3_F11 = 0x56,
    PS2_S3_F12 = 0x5E,

    PS2_S3_PRNT_SCRN = 0x57,
    PS2_S3_SCROLL    = 0x5F,
    PS2_S3_PAUSE     = 0x62,

    PS2_S3_L_BRACKET = 0x54,

    PS2_S3_INSERT = 0x67,
    PS2_S3_HOME   = 0x6E,
    PS2_S3_PG_UP  = 0x6F,
    PS2_S3_DELETE = 0x64,
    PS2_S3_END    = 0x65,
    PS2_S3_PG_DN  = 0x6D,

    PS2_S3_U_ARROW = 0x63,
    PS2_S3_L_ARROW = 0x61,
    PS2_S3_D_ARROW = 0x60,
    PS2_S3_R_ARROW = 0x6A,

    PS2_S3_NUM         = 0x76,
    PS2_S3_KP_SLASH    = 0x4A,
    PS2_S3_KP_ASTERISK = 0x7E,
    PS2_S3_KP_MINUS    = 0x4E,
    PS2_S3_KP_PLUS     = 0x7C,
    PS2_S3_KP_EN       = 0x79,
    PS2_S3_KP_DOT      = 0x71,
    PS2_S3_KP_0        = 0x70,
    PS2_S3_KP_1        = 0x69,
    PS2_S3_KP_2        = 0x72,
    PS2_S3_KP_3        = 0x7A,
    PS2_S3_KP_4        = 0x6B,
    PS2_S3_KP_5        = 0x73,
    PS2_S3_KP_6        = 0x74,
    PS2_S3_KP_7        = 0x6C,
    PS2_S3_KP_8        = 0x75,
    PS2_S3_KP_9        = 0x7D,

    PS2_S3_R_BRACKET  = 0x5B,
    PS2_S3_SEMICOLON  = 0x4C,
    PS2_S3_APOSTROPHE = 0x52,
    PS2_S3_COMMA      = 0x41,
    PS2_S3_DOT        = 0x49,
    PS2_S3_SLASH      = 0x4A,

    PS2_S3_DEFAULT = 0x00,
} PS2_SET_3_SCAN_CODE;

typedef enum _PS2_COMMAND {
	PS2_GET_DEVICE_ID  = 0xF2,
	PS2_SET_RATE_DELAY = 0xF3,
	PS2_ENABLE         = 0xF4,
	PS2_DISABLE        = 0xF5,
	PS2_SET_DEFAULT    = 0xF6,
	PS2_RESEND         = 0xFE,
	PS2_RESET          = 0xFF,

	PS2_KB_SET_LEDS                          = 0xED,
	PS2_KB_ECHO                              = 0xEE,
	PS2_KB_GET_SET_SCAN_CODE                 = 0xF0,
	PS2_KB_SET_ALL_KEYS_TYPEMATIC            = 0xF7,
	PS2_KB_SET_ALL_KEYS_MAKE_BREAK           = 0xF8,
	PS2_KB_SET_ALL_KEYS_MAKE                 = 0xF9,
	PS2_KB_SET_ALL_KEYS_TYPEMATIC_MAKE_BREAK = 0xFA,
	PS2_KB_SET_KEY_TYPEMATIC                 = 0xFB,
	PS2_KB_SET_KEY_MAKE_BREAK                = 0xFC,
	PS2_KB_SET_KEY_MAKE                      = 0xFD,

	PS2_M_SET_SCALING_1_1 = 0xE6,
	PS2_M_SET_SCALING_2_1 = 0xE7,
	PS2_M_SET_RESOLUTION  = 0xE8,
	PS2_M_STATUS_REQUEST  = 0xE9,
	PS2_M_SET_STREAM_MODE = 0xEA,
	PS2_M_GET_DATA        = 0xEB,
	PS2_M_RESET_WARP_MODE = 0xEC,
	PS2_M_SET_WARP_MODE   = 0xEE,
	PS2_M_SET_REMOTE_MODE = 0xF0,
} PS2_COMMAND;

typedef struct _PS2_STRUCT {
	uint8_t (*bypass_cache_read8)(volatile const void *);
	void (*bypass_cache_write8)(volatile void *, uint8_t);
    uint8_t *base, x_lh, x_hl;
    PS2_DEVICE device;
    PS2_SET keyboard_set;
    PS2_MAKE_BREAK make_break;
	size_t i, read;
	bool prnt_scrn_make, prnt_scrn_break;
    void (*keyboard)(PS2_MAKE_BREAK, PS2_SET, uint32_t);
    void (*mouse)(int16_t, int16_t, PS2_MAKE_BREAK, PS2_MAKE_BREAK, PS2_MAKE_BREAK, int8_t, PS2_MAKE_BREAK, PS2_MAKE_BREAK);
    PS2_COMMAND command;
    uint8_t data, resend;
    bool use_data, wait, ack;
} PS2_STRUCT;

PS2_SET_2_SCAN_CODE ps2_s1_to_s2(PS2_SET_1_SCAN_CODE);
PS2_SET_1_SCAN_CODE ps2_s2_to_s1(PS2_SET_2_SCAN_CODE);
PS2_SET_3_SCAN_CODE ps2_s2_to_s3(PS2_SET_2_SCAN_CODE);
PS2_SET_2_SCAN_CODE ps2_s3_to_s2(PS2_SET_3_SCAN_CODE);
PS2_SET_3_SCAN_CODE ps2_s1_to_s3(PS2_SET_1_SCAN_CODE);
PS2_SET_1_SCAN_CODE ps2_s3_to_s1(PS2_SET_3_SCAN_CODE);
void ps2_command(volatile PS2_STRUCT *, PS2_COMMAND, uint8_t);

#ifdef __cplusplus
}
#endif

#endif
