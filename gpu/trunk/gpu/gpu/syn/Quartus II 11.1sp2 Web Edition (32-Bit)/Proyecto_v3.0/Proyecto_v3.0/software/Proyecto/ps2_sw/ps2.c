// Diego Andrés González Idárraga

#include "ps2.h"

void ps2_irq(void *context, uint32_t id) {
	ps2_ic_isr(context);
}

void ps2_ic_isr(void *context) {
	volatile PS2_STRUCT *ps2_struct;
	uint8_t x_ll;
	uint32_t keyboard_scan_codes;

	ps2_struct = (PS2_STRUCT *)(context);
	x_ll = ps2_struct->bypass_cache_read8(&ps2_struct->base[0]);
	ps2_struct->bypass_cache_write8(&ps2_struct->base[1], 0x00);

    if (ps2_struct->ack) {
		ps2_struct->ack = false;
		return;
	}

    if (ps2_struct->read > 0) {
    	switch (ps2_struct->command) {
		case PS2_GET_DEVICE_ID:
			switch (x_ll) {
			case 0x00:
			case 0x03:
			case 0x04:
				ps2_struct->device = PS2_MOUSE;
				break;
			case 0xAB:
				ps2_struct->device = PS2_KEYBOARD;
				break;
			default:
				ps2_struct->device = PS2_UNKNOWN;
			}
			break;
		case PS2_KB_GET_SET_SCAN_CODE:
			switch (x_ll) {
			case 1:
				ps2_struct->keyboard_set = PS2_SET_1;
				break;
			case 2:
				ps2_struct->keyboard_set = PS2_SET_2;
				break;
			case 3:
				ps2_struct->keyboard_set = PS2_SET_3;
				break;
			default:
				break;
			}
			break;
		default:
			break;
    	}

    	ps2_struct->read--;
    }

    switch (ps2_struct->device) {
    case PS2_KEYBOARD:
		switch (x_ll) {
		case 0xE0:
			switch (ps2_struct->keyboard_set) {
			case PS2_SET_1:
			case PS2_SET_2:
				ps2_struct->x_lh = x_ll;
				break;
			case PS2_SET_3:
				break;
			}
			break;
		case 0xF0:
			switch (ps2_struct->keyboard_set) {
			case PS2_SET_1:
				break;
			case PS2_SET_2:
			case PS2_SET_3:
				ps2_struct->make_break = PS2_BREAK;
				break;
			}
			break;
		case 0xFA:
			if (ps2_struct->use_data) {
				ps2_struct->use_data = false;
				ps2_struct->ack = true;
				ps2_struct->resend = ps2_struct->data;
				ps2_struct->bypass_cache_write8(&ps2_struct->base[0], ps2_struct->data);
			} else {
				switch (ps2_struct->command) {
				case PS2_GET_DEVICE_ID:
					ps2_struct->read = 1;
					break;
				case PS2_KB_GET_SET_SCAN_CODE:
					switch (ps2_struct->data) {
					case 0:
						ps2_struct->read = 1;
						break;
					case 1:
						ps2_struct->keyboard_set = PS2_SET_1;
						break;
					case 2:
						ps2_struct->keyboard_set = PS2_SET_2;
						break;
					case 3:
						ps2_struct->keyboard_set = PS2_SET_3;
						break;
					default:
						break;
					}
					break;
				default:
					break;
				}

				ps2_struct->wait = false;
			}
			break;
		case 0xFE:
			ps2_struct->ack = true;
			ps2_struct->bypass_cache_write8(&ps2_struct->base[0], ps2_struct->resend);
			break;
		default:
			switch (ps2_struct->keyboard_set) {
			case PS2_SET_1:
				if ((x_ll&0x80) != 0x00) {
					ps2_struct->make_break = PS2_BREAK;
					x_ll &= 0x7F;
				}
			case PS2_SET_2:
			case PS2_SET_3:
				keyboard_scan_codes = (ps2_struct->x_hl<<16)|(ps2_struct->x_lh<<8)|x_ll;
				if (keyboard_scan_codes == 0x000000E1) ps2_struct->i = 2;

				if (ps2_struct->i > 0) {
					ps2_struct->x_hl = ps2_struct->x_lh;
					ps2_struct->x_lh = x_ll;
					ps2_struct->i--;
					return;
				}
				break;
			}

			switch (ps2_struct->keyboard_set) {
			case PS2_SET_1:
				if ((keyboard_scan_codes == 0x0000E02A) && (ps2_struct->make_break == PS2_MAKE)) {
					ps2_struct->prnt_scrn_make = true;
					ps2_struct->prnt_scrn_break = false;
					return;
				}

				if ((keyboard_scan_codes == 0x0000E0B7) && (ps2_struct->make_break == PS2_BREAK)) {
					ps2_struct->prnt_scrn_make = false;
					ps2_struct->prnt_scrn_break = true;
					return;
				}

				if ((ps2_struct->prnt_scrn_make  && (keyboard_scan_codes == 0x0000E037) && (ps2_struct->make_break == PS2_MAKE)) ||
				    (ps2_struct->prnt_scrn_break && (keyboard_scan_codes == 0x0000E0AA) && (ps2_struct->make_break == PS2_BREAK))) {
					keyboard_scan_codes = PS2_S1_PRNT_SCRN;
				} else {
					ps2_struct->prnt_scrn_make = false;
					ps2_struct->prnt_scrn_break = false;
				}

				break;
			case PS2_SET_2:
				if ((keyboard_scan_codes == 0x0000E012) && (ps2_struct->make_break == PS2_MAKE)) {
					ps2_struct->prnt_scrn_make = true;
					ps2_struct->prnt_scrn_break = false;
					return;
				}

				if ((keyboard_scan_codes == 0x0000E07C) && (ps2_struct->make_break == PS2_BREAK)) {
					ps2_struct->prnt_scrn_make = false;
					ps2_struct->prnt_scrn_break = true;
					return;
				}

				if ((ps2_struct->prnt_scrn_make  && (keyboard_scan_codes == 0x0000E07C) && (ps2_struct->make_break == PS2_MAKE)) ||
				    (ps2_struct->prnt_scrn_break && (keyboard_scan_codes == 0x0000E012) && (ps2_struct->make_break == PS2_BREAK))) {
					keyboard_scan_codes = PS2_S2_PRNT_SCRN;
				} else {
					ps2_struct->prnt_scrn_make = false;
					ps2_struct->prnt_scrn_break = false;
				}

				break;
			case PS2_SET_3:
				break;
			}

			ps2_struct->keyboard(ps2_struct->make_break, ps2_struct->keyboard_set, keyboard_scan_codes);
			ps2_struct->make_break = PS2_MAKE;
			ps2_struct->x_lh = 0x00;
			ps2_struct->x_hl = 0x00;
			break;
		}
		break;
	case PS2_MOUSE:
		if (ps2_struct->wait) {
			switch (x_ll) {
			case 0xFA:
				if (ps2_struct->use_data) {
					ps2_struct->use_data = false;
					ps2_struct->ack = true;
					ps2_struct->resend = ps2_struct->data;
					ps2_struct->bypass_cache_write8(&ps2_struct->base[0], ps2_struct->data);
				} else {
					switch (ps2_struct->command) {
					case PS2_GET_DEVICE_ID:
						ps2_struct->read = 1;
						break;
					default:
						break;
					}

					ps2_struct->wait = false;
				}
				return;
			case 0xFE:
				ps2_struct->ack = true;
				ps2_struct->bypass_cache_write8(&ps2_struct->base[0], ps2_struct->resend);
				return;
			default:
				break;
			}
		}

		switch (ps2_struct->i) {
		case 0:
			ps2_struct->x_hl = x_ll;
			if ((x_ll&0x08) != 0x00) ps2_struct->i++;
			break;
		case 1:
			ps2_struct->x_lh = x_ll;
			ps2_struct->i++;
			break;
		case 2:
			ps2_struct->mouse(
				(((ps2_struct->x_hl&0x10) != 0x00)?
					(((ps2_struct->x_hl&0x40) != 0x00)? 0xFE00 : 0xFF00) :
					(((ps2_struct->x_hl&0x40) != 0x00)? 0x0100 : 0x0000)
				)|ps2_struct->x_lh,
				(((ps2_struct->x_hl&0x20) != 0x00)?
					(((ps2_struct->x_hl&0x80) != 0x00)? 0xFE00 : 0xFF00) :
					(((ps2_struct->x_hl&0x80) != 0x00)? 0x0100 : 0x0000)
				)|x_ll,
				((ps2_struct->x_hl&0x01) != 0x00)? PS2_MAKE : PS2_BREAK,
				((ps2_struct->x_hl&0x02) != 0x00)? PS2_MAKE : PS2_BREAK,
				((ps2_struct->x_hl&0x04) != 0x00)? PS2_MAKE : PS2_BREAK,
				0,
				PS2_BREAK,
				PS2_BREAK
			);
		default:
			ps2_struct->i = 0;
		}
		break;
	case PS2_UNKNOWN:
		break;
    }
}

#define sA_to_sB(A, B, case_KP_SLASH, case_KP_MINUS, case_ACPI_MULTIMEDIA) \
PS2_SET_##B##_SCAN_CODE ps2_s##A##_to_s##B(PS2_SET_##A##_SCAN_CODE set_##A##scan_code) {\
    switch (set_##A##scan_code) {\
    case PS2_S##A##_A:            return PS2_S##B##_A;\
    case PS2_S##A##_B:            return PS2_S##B##_B;\
    case PS2_S##A##_C:            return PS2_S##B##_C;\
    case PS2_S##A##_D:            return PS2_S##B##_D;\
    case PS2_S##A##_E:            return PS2_S##B##_E;\
    case PS2_S##A##_F:            return PS2_S##B##_F;\
    case PS2_S##A##_G:            return PS2_S##B##_G;\
    case PS2_S##A##_H:            return PS2_S##B##_H;\
    case PS2_S##A##_I:            return PS2_S##B##_I;\
    case PS2_S##A##_J:            return PS2_S##B##_J;\
    case PS2_S##A##_K:            return PS2_S##B##_K;\
    case PS2_S##A##_L:            return PS2_S##B##_L;\
    case PS2_S##A##_M:            return PS2_S##B##_M;\
    case PS2_S##A##_N:            return PS2_S##B##_N;\
    case PS2_S##A##_O:            return PS2_S##B##_O;\
    case PS2_S##A##_P:            return PS2_S##B##_P;\
    case PS2_S##A##_Q:            return PS2_S##B##_Q;\
    case PS2_S##A##_R:            return PS2_S##B##_R;\
    case PS2_S##A##_S:            return PS2_S##B##_S;\
    case PS2_S##A##_T:            return PS2_S##B##_T;\
    case PS2_S##A##_U:            return PS2_S##B##_U;\
    case PS2_S##A##_V:            return PS2_S##B##_V;\
    case PS2_S##A##_W:            return PS2_S##B##_W;\
    case PS2_S##A##_X:            return PS2_S##B##_X;\
    case PS2_S##A##_Y:            return PS2_S##B##_Y;\
    case PS2_S##A##_Z:            return PS2_S##B##_Z;\
    case PS2_S##A##_0:            return PS2_S##B##_0;\
    case PS2_S##A##_1:            return PS2_S##B##_1;\
    case PS2_S##A##_2:            return PS2_S##B##_2;\
    case PS2_S##A##_3:            return PS2_S##B##_3;\
    case PS2_S##A##_4:            return PS2_S##B##_4;\
    case PS2_S##A##_5:            return PS2_S##B##_5;\
    case PS2_S##A##_6:            return PS2_S##B##_6;\
    case PS2_S##A##_7:            return PS2_S##B##_7;\
    case PS2_S##A##_8:            return PS2_S##B##_8;\
    case PS2_S##A##_9:            return PS2_S##B##_9;\
    case PS2_S##A##_GRAVE_ACCENT: return PS2_S##B##_GRAVE_ACCENT;\
    case PS2_S##A##_MINUS:        return PS2_S##B##_MINUS;\
    case PS2_S##A##_EQUAL:        return PS2_S##B##_EQUAL;\
    case PS2_S##A##_BACKSLASH:    return PS2_S##B##_BACKSLASH;\
    case PS2_S##A##_BKSP:         return PS2_S##B##_BKSP;\
    case PS2_S##A##_SPACE:        return PS2_S##B##_SPACE;\
    case PS2_S##A##_TAB:          return PS2_S##B##_TAB;\
    case PS2_S##A##_CAPS:         return PS2_S##B##_CAPS;\
    case PS2_S##A##_L_SHFT:       return PS2_S##B##_L_SHFT;\
    case PS2_S##A##_L_CTRL:       return PS2_S##B##_L_CTRL;\
    case PS2_S##A##_L_GUI:        return PS2_S##B##_L_GUI;\
    case PS2_S##A##_L_ALT:        return PS2_S##B##_L_ALT;\
    case PS2_S##A##_R_SHFT:       return PS2_S##B##_R_SHFT;\
    case PS2_S##A##_R_CTRL:       return PS2_S##B##_R_CTRL;\
    case PS2_S##A##_R_GUI:        return PS2_S##B##_R_GUI;\
    case PS2_S##A##_R_ALT:        return PS2_S##B##_R_ALT;\
    case PS2_S##A##_APPS:         return PS2_S##B##_APPS;\
    case PS2_S##A##_ENTER:        return PS2_S##B##_ENTER;\
\
    case PS2_S##A##_ESC: return PS2_S##B##_ESC;\
\
    case PS2_S##A##_F1: return PS2_S##B##_F1;\
    case PS2_S##A##_F2: return PS2_S##B##_F2;\
    case PS2_S##A##_F3: return PS2_S##B##_F3;\
    case PS2_S##A##_F4: return PS2_S##B##_F4;\
\
    case PS2_S##A##_F5: return PS2_S##B##_F5;\
    case PS2_S##A##_F6: return PS2_S##B##_F6;\
    case PS2_S##A##_F7: return PS2_S##B##_F7;\
    case PS2_S##A##_F8: return PS2_S##B##_F8;\
\
    case PS2_S##A##_F9:  return PS2_S##B##_F9;\
    case PS2_S##A##_F10: return PS2_S##B##_F10;\
    case PS2_S##A##_F11: return PS2_S##B##_F11;\
    case PS2_S##A##_F12: return PS2_S##B##_F12;\
\
    case PS2_S##A##_PRNT_SCRN: return PS2_S##B##_PRNT_SCRN;\
    case PS2_S##A##_SCROLL:    return PS2_S##B##_SCROLL;\
    case PS2_S##A##_PAUSE:     return PS2_S##B##_PAUSE;\
\
    case PS2_S##A##_L_BRACKET: return PS2_S##B##_L_BRACKET;\
\
    case PS2_S##A##_INSERT: return PS2_S##B##_INSERT;\
    case PS2_S##A##_HOME:   return PS2_S##B##_HOME;\
    case PS2_S##A##_PG_UP:  return PS2_S##B##_PG_UP;\
    case PS2_S##A##_DELETE: return PS2_S##B##_DELETE;\
    case PS2_S##A##_END:    return PS2_S##B##_END;\
    case PS2_S##A##_PG_DN:  return PS2_S##B##_PG_DN;\
\
    case PS2_S##A##_U_ARROW: return PS2_S##B##_U_ARROW;\
    case PS2_S##A##_L_ARROW: return PS2_S##B##_L_ARROW;\
    case PS2_S##A##_D_ARROW: return PS2_S##B##_D_ARROW;\
    case PS2_S##A##_R_ARROW: return PS2_S##B##_R_ARROW;\
\
    case PS2_S##A##_NUM:         return PS2_S##B##_NUM;\
    case_KP_SLASH(A, B)\
    case PS2_S##A##_KP_ASTERISK: return PS2_S##B##_KP_ASTERISK;\
    case_KP_MINUS(A, B)\
    case PS2_S##A##_KP_PLUS:     return PS2_S##B##_KP_PLUS;\
    case PS2_S##A##_KP_EN:       return PS2_S##B##_KP_EN;\
    case PS2_S##A##_KP_DOT:      return PS2_S##B##_KP_DOT;\
    case PS2_S##A##_KP_0:        return PS2_S##B##_KP_0;\
    case PS2_S##A##_KP_1:        return PS2_S##B##_KP_1;\
    case PS2_S##A##_KP_2:        return PS2_S##B##_KP_2;\
    case PS2_S##A##_KP_3:        return PS2_S##B##_KP_3;\
    case PS2_S##A##_KP_4:        return PS2_S##B##_KP_4;\
    case PS2_S##A##_KP_5:        return PS2_S##B##_KP_5;\
    case PS2_S##A##_KP_6:        return PS2_S##B##_KP_6;\
    case PS2_S##A##_KP_7:        return PS2_S##B##_KP_7;\
    case PS2_S##A##_KP_8:        return PS2_S##B##_KP_8;\
    case PS2_S##A##_KP_9:        return PS2_S##B##_KP_9;\
\
    case PS2_S##A##_R_BRACKET:  return PS2_S##B##_R_BRACKET;\
    case PS2_S##A##_SEMICOLON:  return PS2_S##B##_SEMICOLON;\
    case PS2_S##A##_APOSTROPHE: return PS2_S##B##_APOSTROPHE;\
    case PS2_S##A##_COMMA:      return PS2_S##B##_COMMA;\
    case PS2_S##A##_DOT:        return PS2_S##B##_DOT;\
    case PS2_S##A##_SLASH:      return PS2_S##B##_SLASH;\
\
    case_ACPI_MULTIMEDIA(A, B)\
\
    default: return PS2_S##B##_DEFAULT;\
    }\
}

#define KP_SLASH(A, B) case PS2_S##A##_KP_SLASH: return PS2_S##B##_KP_SLASH;
#define KP_MINUS(A, B) case PS2_S##A##_KP_MINUS: return PS2_S##B##_KP_MINUS;

#define ACPI_MULTIMEDIA(A, B) \
    case PS2_S##A##_POWER: return PS2_S##B##_POWER;\
    case PS2_S##A##_SLEEP: return PS2_S##B##_SLEEP;\
    case PS2_S##A##_WAKE:  return PS2_S##B##_WAKE;\
\
    case PS2_S##A##_NEXT_TRACK:     return PS2_S##B##_NEXT_TRACK;\
    case PS2_S##A##_PREVIOUS_TRACK: return PS2_S##B##_PREVIOUS_TRACK;\
    case PS2_S##A##_STOP:           return PS2_S##B##_STOP;\
    case PS2_S##A##_PLAY_PAUSE:     return PS2_S##B##_PLAY_PAUSE;\
    case PS2_S##A##_MUTE:           return PS2_S##B##_MUTE;\
    case PS2_S##A##_VOLUME_UP:      return PS2_S##B##_VOLUME_UP;\
    case PS2_S##A##_VOLUME_DOWN:    return PS2_S##B##_VOLUME_DOWN;\
    case PS2_S##A##_MEDIA_SELECT:   return PS2_S##B##_MEDIA_SELECT;\
    case PS2_S##A##_E_MAIL:         return PS2_S##B##_E_MAIL;\
    case PS2_S##A##_CALCULATOR:     return PS2_S##B##_CALCULATOR;\
    case PS2_S##A##_MY_COMPUTER:    return PS2_S##B##_MY_COMPUTER;\
    case PS2_S##A##_WWW_SEARCH:     return PS2_S##B##_WWW_SEARCH;\
    case PS2_S##A##_WWW_HOME:       return PS2_S##B##_WWW_HOME;\
    case PS2_S##A##_WWW_BACK:       return PS2_S##B##_WWW_BACK;\
    case PS2_S##A##_WWW_FORWARD:    return PS2_S##B##_WWW_FORWARD;\
    case PS2_S##A##_WWW_STOP:       return PS2_S##B##_WWW_STOP;\
    case PS2_S##A##_WWW_REFRESH:    return PS2_S##B##_WWW_REFRESH;\
    case PS2_S##A##_WWW_FAVORITES:  return PS2_S##B##_WWW_FAVORITES;

#define NONE(A, B)

sA_to_sB(1, 2, KP_SLASH, KP_MINUS, ACPI_MULTIMEDIA)
sA_to_sB(2, 1, KP_SLASH, KP_MINUS, ACPI_MULTIMEDIA)
sA_to_sB(2, 3, KP_SLASH, KP_MINUS, NONE)
sA_to_sB(3, 2, NONE, NONE, NONE)
sA_to_sB(1, 3, KP_SLASH, KP_MINUS, NONE)
sA_to_sB(3, 1, NONE, NONE, NONE)

void ps2_command(volatile PS2_STRUCT *ps2_struct, PS2_COMMAND command, uint8_t data) {
	clock_t t;

	for (t = clock(); ps2_struct->wait && (clock()-t <= CLOCKS_PER_SEC/50);) ;
	ps2_struct->command = command;

	switch (command) {
	case PS2_SET_RATE_DELAY:
	case PS2_KB_SET_LEDS:
	case PS2_KB_GET_SET_SCAN_CODE:
	case PS2_KB_SET_KEY_TYPEMATIC:
	case PS2_KB_SET_KEY_MAKE_BREAK:
	case PS2_KB_SET_KEY_MAKE:
	case PS2_M_SET_RESOLUTION:
		ps2_struct->data = data;
		ps2_struct->use_data = true;
		break;
	default:
		ps2_struct->use_data = false;
	}

	ps2_struct->resend = command;
	ps2_struct->wait = true;
	ps2_struct->ack = true;
	ps2_struct->bypass_cache_write8(&ps2_struct->base[0], command);
}
