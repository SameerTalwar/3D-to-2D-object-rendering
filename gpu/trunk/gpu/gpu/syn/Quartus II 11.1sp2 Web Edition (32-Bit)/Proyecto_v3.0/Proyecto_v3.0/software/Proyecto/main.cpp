// Diego Andrés González Idárraga

#include <iostream>
#include <vector>
#include <ctime>
#include <sys/alt_irq.h>
#include <altera_avalon_sgdma_regs.h>
#include <altera_avalon_sgdma.h>
#include "includes.h"
#include "gpu_sw/gpu.h"
#include "ps2_sw/ps2.h"

const std::size_t task_stacksize(2048);
OS_STK task1_stk[task_stacksize], task2_stk[task_stacksize];

void task1(void *);
void task2(void *);
void keyboard(PS2_MAKE_BREAK, PS2_SET, uint32_t);
void mouse(int16_t, int16_t, PS2_MAKE_BREAK, PS2_MAKE_BREAK, PS2_MAKE_BREAK, int8_t, PS2_MAKE_BREAK, PS2_MAKE_BREAK);
void construct_mem_to_stream_descs(const alt_u32 *const&, const std::size_t &, const alt_u8 &, alt_sgdma_descriptor *const&);
void callback(void *);
void gpu_irq(void *, uint32_t);
void gpu_ic_isr(void *);

enum USE_BUFFER {
	USE_1, USE_2, USE_3
} use_buffer(USE_3);

enum BUFFER {
	_1, _2, _3
} buffer(_1);

uint8_t  bypass_cache_read8 (volatile const void *addr) {return IORD_8DIRECT (addr, 0);}
uint32_t bypass_cache_read32(volatile const void *addr) {return IORD_32DIRECT(addr, 0);}
void bypass_cache_write8 (volatile void *addr, uint8_t  data) {IOWR_8DIRECT (addr, 0, data);}
void bypass_cache_write32(volatile void *addr, uint32_t data) {IOWR_32DIRECT(addr, 0, data);}

volatile PS2_STRUCT ps2_0_struct = {
	bypass_cache_read8,
	bypass_cache_write8,
	(alt_u8 *)(PS2_0_BASE),
	0x00,
	0x00,
	PS2_KEYBOARD,
	PS2_SET_2,
	PS2_MAKE,
	0,
	0,
	false,
	false,
	keyboard,
	mouse,
	PS2_GET_DEVICE_ID,
	0x00,
	0x00,
	false,
	false,
	false
};

volatile PS2_STRUCT ps2_1_struct = {
	bypass_cache_read8,
	bypass_cache_write8,
	(alt_u8 *)(PS2_1_BASE),
	0x00,
	0x00,
	PS2_MOUSE,
	PS2_SET_2,
	PS2_MAKE,
	0,
	0,
	false,
	false,
	keyboard,
	mouse,
	PS2_GET_DEVICE_ID,
	0x00,
	0x00,
	false,
	false,
	false
};

const std::size_t ancho(640), alto(480);
bool use_alpha(true), plt_iplt(false);
gpu_vector3 right, up, look, t(-20.f, 20.f, -20.f);
float rx(gpu::pi/5.f), ry(gpu::pi/4.f), _grosor = 4.f;
gpu::PLT tipo(gpu::LISTA_TRIANGULOS);
uint8_t kb_leds = 0x02;

const std::size_t vs1_size(36);
gpu::vertex1 vs1[vs1_size] = {
	gpu::vertex1(gpu_vector3(-10.f, -10.f, -10.f), gpu_vector2(0.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f,  10.f, -10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3( 10.f, -10.f, -10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3( 10.f, -10.f, -10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f,  10.f, -10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3( 10.f,  10.f, -10.f), gpu_vector2(1.f, 1.f)),

	gpu::vertex1(gpu_vector3(-10.f, -10.f,  10.f), gpu_vector2(0.f, 0.f)),
	gpu::vertex1(gpu_vector3( 10.f, -10.f,  10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3(-10.f,  10.f,  10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f,  10.f,  10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3( 10.f, -10.f,  10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3( 10.f,  10.f,  10.f), gpu_vector2(1.f, 1.f)),

	gpu::vertex1(gpu_vector3(-10.f,  10.f, -10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f, -10.f, -10.f), gpu_vector2(0.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f, -10.f,  10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3(-10.f,  10.f, -10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f, -10.f,  10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3(-10.f,  10.f,  10.f), gpu_vector2(1.f, 1.f)),

	gpu::vertex1(gpu_vector3( 10.f, -10.f, -10.f), gpu_vector2(0.f, 0.f)),
	gpu::vertex1(gpu_vector3( 10.f,  10.f, -10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3( 10.f, -10.f,  10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3( 10.f, -10.f,  10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3( 10.f,  10.f, -10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3( 10.f,  10.f,  10.f), gpu_vector2(1.f, 1.f)),

	gpu::vertex1(gpu_vector3(-10.f, -10.f, -10.f), gpu_vector2(0.f, 0.f)),
	gpu::vertex1(gpu_vector3( 10.f, -10.f, -10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3(-10.f, -10.f,  10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f, -10.f,  10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3( 10.f, -10.f, -10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3( 10.f, -10.f,  10.f), gpu_vector2(1.f, 1.f)),

	gpu::vertex1(gpu_vector3( 10.f,  10.f, -10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f,  10.f, -10.f), gpu_vector2(0.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f,  10.f,  10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3( 10.f,  10.f, -10.f), gpu_vector2(1.f, 0.f)),
	gpu::vertex1(gpu_vector3(-10.f,  10.f,  10.f), gpu_vector2(0.f, 1.f)),
	gpu::vertex1(gpu_vector3( 10.f,  10.f,  10.f), gpu_vector2(1.f, 1.f)),
};

const std::size_t is2_size(36);
uint8_t is2[is2_size] = {
	0, 2, 1, 1, 2, 3,
	4, 5, 6, 6, 5, 7,
	2, 0, 4, 2, 4, 6,
	1, 3, 5, 5, 3, 7,
	0, 1, 4, 4, 1, 5,
	3, 2, 6, 3, 6, 7,
};

const std::size_t vs2_size(8);
gpu::vertex0 vs2[vs2_size] = {
	gpu::vertex0(gpu_vector3(-10.f, -10.f, -10.f), gpu::a8r8g8b8(  0,   0,   0)),
	gpu::vertex0(gpu_vector3( 10.f, -10.f, -10.f), gpu::a8r8g8b8(255,   0,   0)),
	gpu::vertex0(gpu_vector3(-10.f,  10.f, -10.f), gpu::a8r8g8b8(  0, 255,   0)),
	gpu::vertex0(gpu_vector3( 10.f,  10.f, -10.f), gpu::a8r8g8b8(255, 255,   0)),
	gpu::vertex0(gpu_vector3(-10.f, -10.f,  10.f), gpu::a8r8g8b8(  0,   0, 255)),
	gpu::vertex0(gpu_vector3( 10.f, -10.f,  10.f), gpu::a8r8g8b8(255,   0, 255)),
	gpu::vertex0(gpu_vector3(-10.f,  10.f,  10.f), gpu::a8r8g8b8(  0, 255, 255)),
	gpu::vertex0(gpu_vector3( 10.f,  10.f,  10.f), gpu::a8r8g8b8(255, 255, 255)),
};

const std::size_t t1_ancho(8), t1_alto(8), t1_size(t1_ancho*t1_alto);

gpu *gpu0;
gpu::vertex1 *vs1_data((gpu::vertex1 *)(SDRAM_1_BASE+7372800));
uint32_t *is2_data((uint32_t *)(vs1_data+vs1_size*sizeof(gpu::vertex1)));
gpu::vertex0 *vs2_data((gpu::vertex0 *)(is2_data+is2_size*sizeof(uint8_t)));
gpu::a8r8g8b8 *t1((gpu::a8r8g8b8 *)(vs2_data+vs2_size*sizeof(gpu::vertex0)));
alt_sgdma_dev *dev;
alt_sgdma_descriptor *descs1((alt_sgdma_descriptor *)(ONCHIP_MEMORY2_0_BASE));
alt_sgdma_descriptor *descs2((alt_sgdma_descriptor *)(ONCHIP_MEMORY2_0_BASE+1024));
alt_sgdma_descriptor *descs3((alt_sgdma_descriptor *)(ONCHIP_MEMORY2_0_BASE+2048));

int main() {
    int x;
	std::size_t i;

    std::cout<<"main()\n";

	#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
    x = alt_ic_isr_register(GPU_0_CONTROL_SLAVE_IRQ_INTERRUPT_CONTROLLER_ID, GPU_0_CONTROL_SLAVE_IRQ, gpu_ic_isr, NULL, NULL);
    #else
    x = alt_irq_register(GPU_0_CONTROL_SLAVE_IRQ, NULL, gpu_irq);
    #endif
    if (x != 0) std::cout<<"gpu_0 error\n";

    #ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
    x = alt_ic_isr_register(PS2_0_IRQ_INTERRUPT_CONTROLLER_ID, PS2_0_IRQ, ps2_ic_isr, (void *)(&ps2_0_struct), NULL);
    #else
    x = alt_irq_register(PS2_0_IRQ, (void *)(&ps2_0_struct), ps2_irq);
    #endif
    if (x != 0) std::cout<<"ps2_0 error\n";
    ps2_command(&ps2_0_struct, PS2_RESET, 0);

    switch (ps2_0_struct.device) {
    case PS2_KEYBOARD:
    	std::cout<<"ps2_0: KEYBOARD\n";
		ps2_command(&ps2_0_struct, PS2_KB_GET_SET_SCAN_CODE, 0);
		ps2_command(&ps2_0_struct, PS2_KB_SET_LEDS, kb_leds);
		break;
    case PS2_MOUSE:
    	std::cout<<"ps2_0: MOUSE\n";
		break;
    case PS2_UNKNOWN:
    	std::cout<<"ps2_0: UNKNOWN\n";
		break;
    }

	#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
    x = alt_ic_isr_register(PS2_1_IRQ_INTERRUPT_CONTROLLER_ID, PS2_1_IRQ, ps2_ic_isr, (void *)(&ps2_1_struct), NULL);
    #else
    x = alt_irq_register(PS2_1_IRQ, (void *)(&ps2_1_struct), ps2_irq);
    #endif
    if (x != 0) std::cout<<"ps2_1 error\n";
    ps2_command(&ps2_1_struct, PS2_RESET, 0);

    switch (ps2_1_struct.device) {
	case PS2_KEYBOARD:
		std::cout<<"ps2_1: KEYBOARD\n";
		ps2_command(&ps2_1_struct, PS2_KB_GET_SET_SCAN_CODE, 0);
		ps2_command(&ps2_1_struct, PS2_KB_SET_LEDS, kb_leds);
		break;
	case PS2_MOUSE:
		std::cout<<"ps2_1: MOUSE\n";
		break;
	case PS2_UNKNOWN:
		std::cout<<"ps2_1: UNKNOWN\n";
		break;
	}

    if ((dev = alt_avalon_sgdma_open(SGDMA_0_NAME)) == NULL) std::cout<<"sgdma_open error\n";
    construct_mem_to_stream_descs((alt_u32 *)(      0), ancho*alto, 0, descs1);
    construct_mem_to_stream_descs((alt_u32 *)(2457600), ancho*alto, 0, descs2);
    construct_mem_to_stream_descs((alt_u32 *)(4915200), ancho*alto, 0, descs3);
    alt_avalon_sgdma_register_callback(dev, callback, ALTERA_AVALON_SGDMA_CONTROL_PARK_MSK|ALTERA_AVALON_SGDMA_CONTROL_IE_GLOBAL_MSK|ALTERA_AVALON_SGDMA_CONTROL_IE_CHAIN_COMPLETED_MSK, NULL);
    callback(NULL);

    gpu0 = new gpu(
    	bypass_cache_read8,
    	bypass_cache_read32,
    	bypass_cache_write8,
    	bypass_cache_write32,
    	(uint8_t *)(GPU_0_CONTROL_SLAVE_BASE),
    	(uint32_t *)(GPU_0_INSTRUCTION_SLAVE_BASE),
    	(gpu::_data_addr *)(ONCHIP_MEMORY2_1_BASE),
    	ancho,
    	alto,
    	(gpu::a8r8g8b8 *)(SDRAM_1_BASE),
    	(float *)(SDRAM_1_BASE+1228800)
    );
    gpu0->texture(t1, t1_ancho, t1_alto);

    for (i = 0; i < vs1_size; i++) vs1_data[i] = vs1[i];
    for (i = 0; i < is2_size; i++) is2_data[i] = is2[i];
    for (i = 0; i < vs2_size; i++) vs2_data[i] = vs2[i];
    for (i = 0; i < t1_size; i++) t1[i] = gpu::a8r8g8b8(rand()%256, rand()%256, rand()%256, rand()%256);

    std::cout<<"while (true)\n";
    OSInit();
    OSTaskCreate(task1, NULL, &task1_stk[task_stacksize-1], 1);
	OSTaskCreate(task2, NULL, &task2_stk[task_stacksize-1], 2);
	OSStart();

	delete gpu0;
    return 0;
}

void task1(void *) {
	gpu_matrix view;
	float w_ry(0.f);
    clock_t _t1, _t2;

	while (true) {
		switch (use_buffer) {
		case USE_1:
			gpu0->buffer_addr((gpu::a8r8g8b8 *)(SDRAM_1_BASE));
			gpu0->bufferZ_addr((float *)(SDRAM_1_BASE+1228800));
			buffer = _1;
			break;
		case USE_2:
			switch (buffer) {
			case _1:
				gpu0->buffer_addr((gpu::a8r8g8b8 *)(SDRAM_1_BASE+2457600));
				gpu0->bufferZ_addr((float *)(SDRAM_1_BASE+3686400));
				buffer = _2;
				break;
			case _2:
			case _3:
				gpu0->buffer_addr((gpu::a8r8g8b8 *)(SDRAM_1_BASE));
				gpu0->bufferZ_addr((float *)(SDRAM_1_BASE+1228800));
				buffer = _1;
				break;
			}
			break;
		case USE_3:
			switch (buffer) {
			case _1:
				gpu0->buffer_addr((gpu::a8r8g8b8 *)(SDRAM_1_BASE+2457600));
				gpu0->bufferZ_addr((float *)(SDRAM_1_BASE+3686400));
				buffer = _2;
				break;
			case _2:
				gpu0->buffer_addr((gpu::a8r8g8b8 *)(SDRAM_1_BASE+4915200));
				gpu0->bufferZ_addr((float *)(SDRAM_1_BASE+6144000));
				buffer = _3;
				break;
			case _3:
				gpu0->buffer_addr((gpu::a8r8g8b8 *)(SDRAM_1_BASE));
				gpu0->bufferZ_addr((float *)(SDRAM_1_BASE+1228800));
				buffer = _1;
				break;
			}
			break;
		}

		view = gpu_matrix::t(-t)*gpu_matrix::ry(-ry)*gpu_matrix::rx(-rx);
		right = gpu_vector3(view._11, view._21, view._31);
		up = gpu_vector3(view._12, view._22, view._32);
		look = gpu_vector3(view._13, view._23, view._33);

		switch (ps2_0_struct.device) {
		case PS2_KEYBOARD:
		case PS2_UNKNOWN:
			break;
		case PS2_MOUSE:
			ps2_command(&ps2_0_struct, PS2_M_GET_DATA, 0);
			break;
		}

		switch (ps2_1_struct.device) {
		case PS2_KEYBOARD:
		case PS2_UNKNOWN:
			break;
		case PS2_MOUSE:
			ps2_command(&ps2_1_struct, PS2_M_GET_DATA, 0);
			break;
		}

		switch (use_buffer) {
		case USE_1:
		case USE_2:
			gpu0->borrar(true, gpu::a8r8g8b8(128, 128, 128));
			break;
		case USE_3:
			OSTaskChangePrio(2, 0);
			OSTaskChangePrio(0, 2);
			OSTaskResume(2);
			break;
		}

		gpu0->world_view_projection(gpu_matrix::ry(w_ry += 0.1f)*view*gpu_matrix::p(gpu::pi/2.f, 640.f/480.f, 1.f, 1000.f));
		gpu0->grosor(_grosor);
		gpu0->use_alpha(use_alpha);
		gpu0->mode = gpu::ASYNC;

		if (plt_iplt) {
			gpu0->caras_sh(true);
			gpu0->caras_sah(false);
			gpu0->iplt(tipo, is2_data, is2_size, vs2_data);
			OSTaskSuspend(OS_PRIO_SELF);
		} else {
			gpu0->caras_sh(false);
			gpu0->caras_sah(true);
			gpu0->plt(tipo, vs1_data, vs1_size);
			OSTaskSuspend(OS_PRIO_SELF);
			gpu0->caras_sh(true);
			gpu0->caras_sah(false);
			gpu0->plt(tipo, vs1_data, vs1_size);
			OSTaskSuspend(OS_PRIO_SELF);
		}

		_t2 = clock();
		std::cout<<"fps: "<<float(CLOCKS_PER_SEC)/float(_t2-_t1)<<'\n';
		_t1 = _t2;
	}
}

void task2(void *) {
	gpu::a8r8g8b8 *buffer_addr;
	float *bufferZ_addr;

	OSTaskSuspend(OS_PRIO_SELF);
	while (true) {
		switch (use_buffer) {
		case USE_1:
		case USE_2:
			break;
		case USE_3:
			switch (buffer) {
			case _1:
				buffer_addr = (gpu::a8r8g8b8 *)(SDRAM_1_BASE+2457600);
				bufferZ_addr = (float *)(SDRAM_1_BASE+3686400);
				break;
			case _2:
				buffer_addr = (gpu::a8r8g8b8 *)(SDRAM_1_BASE+4915200);
				bufferZ_addr = (float *)(SDRAM_1_BASE+6144000);
				break;
			case _3:
				buffer_addr = (gpu::a8r8g8b8 *)(SDRAM_1_BASE);
				bufferZ_addr = (float *)(SDRAM_1_BASE+1228800);
				break;
			}

			gpu0->borrar(true, gpu::a8r8g8b8(128, 128, 128), true, 1.f, buffer_addr, bufferZ_addr);
			break;
		}
		OSTaskSuspend(OS_PRIO_SELF);
	}
}

void keyboard(PS2_MAKE_BREAK make_break, PS2_SET keyboard_set, uint32_t scan_code) {
	switch (keyboard_set) {
	case PS2_SET_1:
		scan_code = ps2_s1_to_s2((PS2_SET_1_SCAN_CODE)(scan_code));
		break;
	case PS2_SET_2:
		break;
	case PS2_SET_3:
		scan_code = ps2_s3_to_s2((PS2_SET_3_SCAN_CODE)(scan_code));
		break;
	}

	switch (make_break) {
	case PS2_BREAK:
		break;
	case PS2_MAKE:
        switch (scan_code) {
        case PS2_S2_A:
            t -= right;
            break;
        case PS2_S2_D:
            t += right;
            break;
        case PS2_S2_L_CTRL:
            t -= up;
            break;
		case PS2_S2_SPACE:
			t += up;
			break;
        case PS2_S2_S:
            t -= look;
            break;
        case PS2_S2_W:
            t += look;
            break;
        case PS2_S2_L_ARROW:
            ry -= 0.1f;
            break;
        case PS2_S2_R_ARROW:
            ry += 0.1f;
            break;
        case PS2_S2_D_ARROW:
            rx += 0.1f;
            break;
        case PS2_S2_U_ARROW:
            rx -= 0.1f;
            break;
        case PS2_S2_1:
        	tipo = gpu::LISTA_PUNTOS;
        	break;
        case PS2_S2_2:
			tipo = gpu::LISTA_LINEAS;
			break;
        case PS2_S2_3:
        	tipo = gpu::TIRA_LINEAS;
            break;
        case PS2_S2_4:
        	tipo = gpu::LISTA_TRIANGULOS;
            break;
        case PS2_S2_5:
			tipo = gpu::TIRA_TRIANGULOS;
			break;
        case PS2_S2_6:
			tipo = gpu::ABANICO_TRIANGULOS;
			break;
        case PS2_S2_KP_SLASH:
        	_grosor /= 2.f;
        	break;
        case PS2_S2_KP_ASTERISK:
            _grosor *= 2.f;
            break;
        case PS2_S2_KP_0:
			use_alpha = !use_alpha;
			break;
        case PS2_S2_KP_1:
			plt_iplt = false;
			break;
        case PS2_S2_KP_2:
        	plt_iplt = true;
			break;
        case PS2_S2_F1:
			use_buffer = USE_1;
			break;
        case PS2_S2_F2:
			use_buffer = USE_2;
			break;
        case PS2_S2_F3:
			use_buffer = USE_3;
			break;
        case PS2_S2_CAPS:
        	kb_leds = (kb_leds&(~0x04))|((~kb_leds)&0x04);
        	ps2_command(&ps2_0_struct, PS2_KB_SET_LEDS, kb_leds);
        	break;
        case PS2_S2_SCROLL:
        	kb_leds = (kb_leds&(~0x01))|((~kb_leds)&0x01);
        	ps2_command(&ps2_0_struct, PS2_KB_SET_LEDS, kb_leds);
        	break;
        case PS2_S2_NUM:
        	kb_leds = (kb_leds&(~0x02))|((~kb_leds)&0x02);
        	ps2_command(&ps2_0_struct, PS2_KB_SET_LEDS, kb_leds);
        	break;
        default:
            break;
        }
        break;
	}
}

void mouse(int16_t x, int16_t y, PS2_MAKE_BREAK l, PS2_MAKE_BREAK r, PS2_MAKE_BREAK m, int8_t z, PS2_MAKE_BREAK _4, PS2_MAKE_BREAK _5) {
	if ((l == PS2_MAKE) && (r == PS2_BREAK)) t -= right;
	else if ((l == PS2_BREAK) && (r == PS2_MAKE)) t += right;

	switch (m) {
	case PS2_BREAK:
		if (z < 0) t -= look;
		else if (z > 0) t += look;
		break;
	case PS2_MAKE:
		if (z < 0) t -= up;
		else if (z > 0) t += up;
		break;
	}

	ry += float(x)/256.f;
	rx -= float(y)/256.f;
}

void construct_mem_to_stream_descs(const alt_u32 *const&buffer, const std::size_t &buffer_size, const alt_u8 &atlantic_chanel, alt_sgdma_descriptor *const&descs) {
    std::size_t bytes_to_transfer, i;
    std::size_t descs_size;
    alt_u16 length;
    int generate_eop;

    bytes_to_transfer = 4*buffer_size;
    descs_size = (bytes_to_transfer/65532)+std::size_t(bytes_to_transfer%65532 != 0);
    for (i = 0; i < descs_size; i++) {
    	if (i+1 < descs_size) {
    		length = 65532;
    		generate_eop = 0;
    	}
    	else {
    		length = bytes_to_transfer-65532*i;
    		generate_eop = 1;
    	}
    	alt_avalon_sgdma_construct_mem_to_stream_desc(&descs[i], &descs[i+1], (alt_u32 *)(&buffer[16383*i]), length, 0, int(i == 0), generate_eop, atlantic_chanel);
    }
}

void callback(void *) {
	alt_sgdma_descriptor *descs;

	switch (use_buffer) {
	case USE_1:
		descs = descs1;
		break;
	case USE_2:
		switch (buffer) {
		case _1:
			descs = descs2;
			break;
		case _2:
		case _3:
			descs = descs1;
			break;
		}
		break;
	case USE_3:
		switch (buffer) {
		case _1:
			descs = descs3;
			break;
		case _2:
			descs = descs1;
			break;
		case _3:
			descs = descs2;
			break;
		}
		break;
	}

	alt_avalon_sgdma_do_async_transfer(dev, descs);
}

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
void gpu_ic_isr(void *) {
#else
void gpu_irq(void *, uint32_t) {
#endif
	gpu0->reset_irq();
	OSTaskResume(1);
}
