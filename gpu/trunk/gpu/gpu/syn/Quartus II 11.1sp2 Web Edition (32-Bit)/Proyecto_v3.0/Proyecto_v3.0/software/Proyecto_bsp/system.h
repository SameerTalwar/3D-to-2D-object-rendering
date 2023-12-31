/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2_qsys_0' in SOPC Builder design 'Proyecto'
 * SOPC Builder design path: C:/Nueva_carpeta/Proyecto_v3.0/Proyecto.sopcinfo
 *
 * Generated: Mon Jun 09 14:35:21 COT 2014
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_qsys"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x6005820
#define ALT_CPU_CPU_FREQ 100000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1b
#define ALT_CPU_DCACHE_LINE_SIZE 32
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_DCACHE_SIZE 2048
#define ALT_CPU_EXCEPTION_ADDR 0x4000020
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 100000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 4096
#define ALT_CPU_INITDA_SUPPORTED
#define ALT_CPU_INST_ADDR_WIDTH 0x1b
#define ALT_CPU_NAME "nios2_qsys_0"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_RESET_ADDR 0x4000000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x6005820
#define NIOS2_CPU_FREQ 100000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0x1b
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_SIZE 2048
#define NIOS2_EXCEPTION_ADDR 0x4000020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_INITDA_SUPPORTED
#define NIOS2_INST_ADDR_WIDTH 0x1b
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_RESET_ADDR 0x4000000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_LCD_16207
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_SGDMA
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_NIOS2_QSYS
#define __GPU
#define __PS2


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone II"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/lcd_0"
#define ALT_STDERR_BASE 0x6006460
#define ALT_STDERR_DEV lcd_0
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_lcd_16207"
#define ALT_STDIN "/dev/lcd_0"
#define ALT_STDIN_BASE 0x6006460
#define ALT_STDIN_DEV lcd_0
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_lcd_16207"
#define ALT_STDOUT "/dev/lcd_0"
#define ALT_STDOUT_BASE 0x6006460
#define ALT_STDOUT_DEV lcd_0
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_lcd_16207"
#define ALT_SYSTEM_NAME "Proyecto"


/*
 * gpu_0_control_slave configuration
 *
 */

#define ALT_MODULE_CLASS_gpu_0_control_slave gpu
#define GPU_0_CONTROL_SLAVE_BASE 0x6006480
#define GPU_0_CONTROL_SLAVE_IRQ 4
#define GPU_0_CONTROL_SLAVE_IRQ_INTERRUPT_CONTROLLER_ID 0
#define GPU_0_CONTROL_SLAVE_NAME "/dev/gpu_0_control_slave"
#define GPU_0_CONTROL_SLAVE_SPAN 1
#define GPU_0_CONTROL_SLAVE_TYPE "gpu"


/*
 * gpu_0_instruction_slave configuration
 *
 */

#define ALT_MODULE_CLASS_gpu_0_instruction_slave gpu
#define GPU_0_INSTRUCTION_SLAVE_BASE 0x6000000
#define GPU_0_INSTRUCTION_SLAVE_IRQ -1
#define GPU_0_INSTRUCTION_SLAVE_IRQ_INTERRUPT_CONTROLLER_ID -1
#define GPU_0_INSTRUCTION_SLAVE_NAME "/dev/gpu_0_instruction_slave"
#define GPU_0_INSTRUCTION_SLAVE_SPAN 16384
#define GPU_0_INSTRUCTION_SLAVE_TYPE "gpu"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK TIMER_0
#define ALT_TIMESTAMP_CLK none


/*
 * lcd_0 configuration
 *
 */

#define ALT_MODULE_CLASS_lcd_0 altera_avalon_lcd_16207
#define LCD_0_BASE 0x6006460
#define LCD_0_IRQ -1
#define LCD_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LCD_0_NAME "/dev/lcd_0"
#define LCD_0_SPAN 16
#define LCD_0_TYPE "altera_avalon_lcd_16207"


/*
 * onchip_memory2_0 configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_memory2_0 altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_BASE 0x6004000
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE "Automatic"
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE "onchip_memory2_0"
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_0_INSTANCE_ID "NONE"
#define ONCHIP_MEMORY2_0_IRQ -1
#define ONCHIP_MEMORY2_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEMORY2_0_NAME "/dev/onchip_memory2_0"
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE "Auto"
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEMORY2_0_SINGLE_CLOCK_OP 0
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 4096u
#define ONCHIP_MEMORY2_0_SPAN 4096
#define ONCHIP_MEMORY2_0_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEMORY2_0_WRITABLE 1


/*
 * onchip_memory2_1 configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_memory2_1 altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_1_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_1_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_1_BASE 0x6006000
#define ONCHIP_MEMORY2_1_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_1_DUAL_PORT 0
#define ONCHIP_MEMORY2_1_GUI_RAM_BLOCK_TYPE "Automatic"
#define ONCHIP_MEMORY2_1_INIT_CONTENTS_FILE "onchip_memory2_1"
#define ONCHIP_MEMORY2_1_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_1_INSTANCE_ID "NONE"
#define ONCHIP_MEMORY2_1_IRQ -1
#define ONCHIP_MEMORY2_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEMORY2_1_NAME "/dev/onchip_memory2_1"
#define ONCHIP_MEMORY2_1_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEMORY2_1_RAM_BLOCK_TYPE "Auto"
#define ONCHIP_MEMORY2_1_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEMORY2_1_SINGLE_CLOCK_OP 0
#define ONCHIP_MEMORY2_1_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_1_SIZE_VALUE 1024u
#define ONCHIP_MEMORY2_1_SPAN 1024
#define ONCHIP_MEMORY2_1_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEMORY2_1_WRITABLE 1


/*
 * ps2_0 configuration
 *
 */

#define ALT_MODULE_CLASS_ps2_0 ps2
#define PS2_0_BASE 0x6006478
#define PS2_0_IRQ 2
#define PS2_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define PS2_0_NAME "/dev/ps2_0"
#define PS2_0_SPAN 4
#define PS2_0_TYPE "ps2"


/*
 * ps2_1 configuration
 *
 */

#define ALT_MODULE_CLASS_ps2_1 ps2
#define PS2_1_BASE 0x600647c
#define PS2_1_IRQ 3
#define PS2_1_IRQ_INTERRUPT_CONTROLLER_ID 0
#define PS2_1_NAME "/dev/ps2_1"
#define PS2_1_SPAN 4
#define PS2_1_TYPE "ps2"


/*
 * sdram_0 configuration
 *
 */

#define ALT_MODULE_CLASS_sdram_0 altera_avalon_new_sdram_controller
#define SDRAM_0_BASE 0x4000000
#define SDRAM_0_CAS_LATENCY 2
#define SDRAM_0_CONTENTS_INFO ""
#define SDRAM_0_INIT_NOP_DELAY 0.0
#define SDRAM_0_INIT_REFRESH_COMMANDS 8
#define SDRAM_0_IRQ -1
#define SDRAM_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_0_IS_INITIALIZED 1
#define SDRAM_0_NAME "/dev/sdram_0"
#define SDRAM_0_POWERUP_DELAY 200.0
#define SDRAM_0_REFRESH_PERIOD 7.8125
#define SDRAM_0_REGISTER_DATA_IN 1
#define SDRAM_0_SDRAM_ADDR_WIDTH 0x18
#define SDRAM_0_SDRAM_BANK_WIDTH 2
#define SDRAM_0_SDRAM_COL_WIDTH 9
#define SDRAM_0_SDRAM_DATA_WIDTH 16
#define SDRAM_0_SDRAM_NUM_BANKS 4
#define SDRAM_0_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_0_SDRAM_ROW_WIDTH 13
#define SDRAM_0_SHARED_DATA 0
#define SDRAM_0_SIM_MODEL_BASE 1
#define SDRAM_0_SPAN 33554432
#define SDRAM_0_STARVATION_INDICATOR 0
#define SDRAM_0_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_0_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_0_T_AC 6.5
#define SDRAM_0_T_MRD 3
#define SDRAM_0_T_RCD 20.0
#define SDRAM_0_T_RFC 67.5
#define SDRAM_0_T_RP 20.0
#define SDRAM_0_T_WR 14.0


/*
 * sdram_1 configuration
 *
 */

#define ALT_MODULE_CLASS_sdram_1 altera_avalon_new_sdram_controller
#define SDRAM_1_BASE 0x2000000
#define SDRAM_1_CAS_LATENCY 2
#define SDRAM_1_CONTENTS_INFO ""
#define SDRAM_1_INIT_NOP_DELAY 0.0
#define SDRAM_1_INIT_REFRESH_COMMANDS 8
#define SDRAM_1_IRQ -1
#define SDRAM_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_1_IS_INITIALIZED 1
#define SDRAM_1_NAME "/dev/sdram_1"
#define SDRAM_1_POWERUP_DELAY 200.0
#define SDRAM_1_REFRESH_PERIOD 7.8125
#define SDRAM_1_REGISTER_DATA_IN 1
#define SDRAM_1_SDRAM_ADDR_WIDTH 0x18
#define SDRAM_1_SDRAM_BANK_WIDTH 2
#define SDRAM_1_SDRAM_COL_WIDTH 9
#define SDRAM_1_SDRAM_DATA_WIDTH 16
#define SDRAM_1_SDRAM_NUM_BANKS 4
#define SDRAM_1_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_1_SDRAM_ROW_WIDTH 13
#define SDRAM_1_SHARED_DATA 0
#define SDRAM_1_SIM_MODEL_BASE 1
#define SDRAM_1_SPAN 33554432
#define SDRAM_1_STARVATION_INDICATOR 0
#define SDRAM_1_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_1_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_1_T_AC 6.5
#define SDRAM_1_T_MRD 3
#define SDRAM_1_T_RCD 20.0
#define SDRAM_1_T_RFC 67.5
#define SDRAM_1_T_RP 20.0
#define SDRAM_1_T_WR 14.0


/*
 * sdram_1 configuration as viewed by sgdma_0_m_read
 *
 */

#define SGDMA_0_M_READ_SDRAM_1_BASE 0x0
#define SGDMA_0_M_READ_SDRAM_1_CAS_LATENCY 2
#define SGDMA_0_M_READ_SDRAM_1_CONTENTS_INFO ""
#define SGDMA_0_M_READ_SDRAM_1_INIT_NOP_DELAY 0.0
#define SGDMA_0_M_READ_SDRAM_1_INIT_REFRESH_COMMANDS 8
#define SGDMA_0_M_READ_SDRAM_1_IRQ -1
#define SGDMA_0_M_READ_SDRAM_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SGDMA_0_M_READ_SDRAM_1_IS_INITIALIZED 1
#define SGDMA_0_M_READ_SDRAM_1_NAME "/dev/sdram_1"
#define SGDMA_0_M_READ_SDRAM_1_POWERUP_DELAY 200.0
#define SGDMA_0_M_READ_SDRAM_1_REFRESH_PERIOD 7.8125
#define SGDMA_0_M_READ_SDRAM_1_REGISTER_DATA_IN 1
#define SGDMA_0_M_READ_SDRAM_1_SDRAM_ADDR_WIDTH 0x18
#define SGDMA_0_M_READ_SDRAM_1_SDRAM_BANK_WIDTH 2
#define SGDMA_0_M_READ_SDRAM_1_SDRAM_COL_WIDTH 9
#define SGDMA_0_M_READ_SDRAM_1_SDRAM_DATA_WIDTH 16
#define SGDMA_0_M_READ_SDRAM_1_SDRAM_NUM_BANKS 4
#define SGDMA_0_M_READ_SDRAM_1_SDRAM_NUM_CHIPSELECTS 1
#define SGDMA_0_M_READ_SDRAM_1_SDRAM_ROW_WIDTH 13
#define SGDMA_0_M_READ_SDRAM_1_SHARED_DATA 0
#define SGDMA_0_M_READ_SDRAM_1_SIM_MODEL_BASE 1
#define SGDMA_0_M_READ_SDRAM_1_SPAN 33554432
#define SGDMA_0_M_READ_SDRAM_1_STARVATION_INDICATOR 0
#define SGDMA_0_M_READ_SDRAM_1_TRISTATE_BRIDGE_SLAVE ""
#define SGDMA_0_M_READ_SDRAM_1_TYPE "altera_avalon_new_sdram_controller"
#define SGDMA_0_M_READ_SDRAM_1_T_AC 6.5
#define SGDMA_0_M_READ_SDRAM_1_T_MRD 3
#define SGDMA_0_M_READ_SDRAM_1_T_RCD 20.0
#define SGDMA_0_M_READ_SDRAM_1_T_RFC 67.5
#define SGDMA_0_M_READ_SDRAM_1_T_RP 20.0
#define SGDMA_0_M_READ_SDRAM_1_T_WR 14.0


/*
 * sgdma_0 configuration
 *
 */

#define ALT_MODULE_CLASS_sgdma_0 altera_avalon_sgdma
#define SGDMA_0_ADDRESS_WIDTH 32
#define SGDMA_0_ALWAYS_DO_MAX_BURST 1
#define SGDMA_0_ATLANTIC_CHANNEL_DATA_WIDTH 4
#define SGDMA_0_AVALON_MM_BYTE_REORDER_MODE 0
#define SGDMA_0_BASE 0x6006400
#define SGDMA_0_BURST_DATA_WIDTH 8
#define SGDMA_0_BURST_TRANSFER 1
#define SGDMA_0_BYTES_TO_TRANSFER_DATA_WIDTH 16
#define SGDMA_0_CHAIN_WRITEBACK_DATA_WIDTH 32
#define SGDMA_0_COMMAND_FIFO_DATA_WIDTH 104
#define SGDMA_0_CONTROL_DATA_WIDTH 8
#define SGDMA_0_CONTROL_SLAVE_ADDRESS_WIDTH 0x4
#define SGDMA_0_CONTROL_SLAVE_DATA_WIDTH 32
#define SGDMA_0_DESCRIPTOR_READ_BURST 0
#define SGDMA_0_DESC_DATA_WIDTH 32
#define SGDMA_0_HAS_READ_BLOCK 1
#define SGDMA_0_HAS_WRITE_BLOCK 0
#define SGDMA_0_IN_ERROR_WIDTH 0
#define SGDMA_0_IRQ 0
#define SGDMA_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SGDMA_0_NAME "/dev/sgdma_0"
#define SGDMA_0_OUT_ERROR_WIDTH 0
#define SGDMA_0_READ_BLOCK_DATA_WIDTH 32
#define SGDMA_0_READ_BURSTCOUNT_WIDTH 4
#define SGDMA_0_SPAN 64
#define SGDMA_0_STATUS_TOKEN_DATA_WIDTH 24
#define SGDMA_0_STREAM_DATA_WIDTH 32
#define SGDMA_0_SYMBOLS_PER_BEAT 4
#define SGDMA_0_TYPE "altera_avalon_sgdma"
#define SGDMA_0_UNALIGNED_TRANSFER 0
#define SGDMA_0_WRITE_BLOCK_DATA_WIDTH 32
#define SGDMA_0_WRITE_BURSTCOUNT_WIDTH 4


/*
 * sysid_qsys_0 configuration
 *
 */

#define ALT_MODULE_CLASS_sysid_qsys_0 altera_avalon_sysid_qsys
#define SYSID_QSYS_0_BASE 0x6006470
#define SYSID_QSYS_0_ID 911120
#define SYSID_QSYS_0_IRQ -1
#define SYSID_QSYS_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_QSYS_0_NAME "/dev/sysid_qsys_0"
#define SYSID_QSYS_0_SPAN 8
#define SYSID_QSYS_0_TIMESTAMP 1402342180
#define SYSID_QSYS_0_TYPE "altera_avalon_sysid_qsys"


/*
 * timer_0 configuration
 *
 */

#define ALT_MODULE_CLASS_timer_0 altera_avalon_timer
#define TIMER_0_ALWAYS_RUN 1
#define TIMER_0_BASE 0x6006440
#define TIMER_0_COUNTER_SIZE 32
#define TIMER_0_FIXED_PERIOD 1
#define TIMER_0_FREQ 100000000u
#define TIMER_0_IRQ 1
#define TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TIMER_0_LOAD_VALUE 99999ull
#define TIMER_0_MULT 0.0010
#define TIMER_0_NAME "/dev/timer_0"
#define TIMER_0_PERIOD 1
#define TIMER_0_PERIOD_UNITS "ms"
#define TIMER_0_RESET_OUTPUT 0
#define TIMER_0_SNAPSHOT 0
#define TIMER_0_SPAN 32
#define TIMER_0_TICKS_PER_SEC 1000u
#define TIMER_0_TIMEOUT_PULSE_OUTPUT 0
#define TIMER_0_TYPE "altera_avalon_timer"


/*
 * ucosii configuration
 *
 */

#define OS_ARG_CHK_EN 1
#define OS_CPU_HOOKS_EN 1
#define OS_DEBUG_EN 1
#define OS_EVENT_NAME_SIZE 32
#define OS_FLAGS_NBITS 16
#define OS_FLAG_ACCEPT_EN 1
#define OS_FLAG_DEL_EN 1
#define OS_FLAG_EN 1
#define OS_FLAG_NAME_SIZE 32
#define OS_FLAG_QUERY_EN 1
#define OS_FLAG_WAIT_CLR_EN 1
#define OS_LOWEST_PRIO 20
#define OS_MAX_EVENTS 60
#define OS_MAX_FLAGS 20
#define OS_MAX_MEM_PART 60
#define OS_MAX_QS 20
#define OS_MAX_TASKS 10
#define OS_MBOX_ACCEPT_EN 1
#define OS_MBOX_DEL_EN 1
#define OS_MBOX_EN 1
#define OS_MBOX_POST_EN 1
#define OS_MBOX_POST_OPT_EN 1
#define OS_MBOX_QUERY_EN 1
#define OS_MEM_EN 1
#define OS_MEM_NAME_SIZE 32
#define OS_MEM_QUERY_EN 1
#define OS_MUTEX_ACCEPT_EN 1
#define OS_MUTEX_DEL_EN 1
#define OS_MUTEX_EN 1
#define OS_MUTEX_QUERY_EN 1
#define OS_Q_ACCEPT_EN 1
#define OS_Q_DEL_EN 1
#define OS_Q_EN 1
#define OS_Q_FLUSH_EN 1
#define OS_Q_POST_EN 1
#define OS_Q_POST_FRONT_EN 1
#define OS_Q_POST_OPT_EN 1
#define OS_Q_QUERY_EN 1
#define OS_SCHED_LOCK_EN 1
#define OS_SEM_ACCEPT_EN 1
#define OS_SEM_DEL_EN 1
#define OS_SEM_EN 1
#define OS_SEM_QUERY_EN 1
#define OS_SEM_SET_EN 1
#define OS_TASK_CHANGE_PRIO_EN 1
#define OS_TASK_CREATE_EN 1
#define OS_TASK_CREATE_EXT_EN 1
#define OS_TASK_DEL_EN 1
#define OS_TASK_IDLE_STK_SIZE 512
#define OS_TASK_NAME_SIZE 32
#define OS_TASK_PROFILE_EN 1
#define OS_TASK_QUERY_EN 1
#define OS_TASK_STAT_EN 1
#define OS_TASK_STAT_STK_CHK_EN 1
#define OS_TASK_STAT_STK_SIZE 512
#define OS_TASK_SUSPEND_EN 1
#define OS_TASK_SW_HOOK_EN 1
#define OS_TASK_TMR_PRIO 0
#define OS_TASK_TMR_STK_SIZE 512
#define OS_THREAD_SAFE_NEWLIB 1
#define OS_TICKS_PER_SEC TIMER_0_TICKS_PER_SEC
#define OS_TICK_STEP_EN 1
#define OS_TIME_DLY_HMSM_EN 1
#define OS_TIME_DLY_RESUME_EN 1
#define OS_TIME_GET_SET_EN 1
#define OS_TIME_TICK_HOOK_EN 1
#define OS_TMR_CFG_MAX 16
#define OS_TMR_CFG_NAME_SIZE 16
#define OS_TMR_CFG_TICKS_PER_SEC 10
#define OS_TMR_CFG_WHEEL_SIZE 2
#define OS_TMR_EN 0

#endif /* __SYSTEM_H_ */
