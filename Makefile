
##########################################################
## START DEFINITIONS 
##########################################################

# Project name
PROJ_NAME=myproject

# Path to your arm gcc
ARM_CC_PATH=/Users/artemgolovinskij/electronic/gcc-arm-none-eabi-5_3-2016q1
STLINK=/Users/artemgolovinskij/electronic/stlink
##########################################################
## END DEFINITIONS 
##########################################################

# Declare command line tools - assume these are in the path
BIN_PATH  = $(ARM_CC_PATH)/bin
CC	  = $(BIN_PATH)/arm-none-eabi-gcc
LD	  = $(BIN_PATH)/arm-none-eabi-ld
AS	  = $(BIN_PATH)/arm-none-eabi-as
CP	  = $(BIN_PATH)/arm-none-eabi-objcopy
OD	  = $(BIN_PATH)/arm-none-eabi-objdump

# Declare library source paths
SRC = $(realpath .)
CORE_SRC = $(SRC)/lib/CMSIS/CM3/CoreSupport
DEVICE_SRC = $(SRC)/lib/CMSIS/CM3/DeviceSupport/ST/STM32F10x
STD_PERIPH = $(SRC)/lib/STM32F10x_StdPeriph_Driver
STD_PERIPH_SRC = $(STD_PERIPH)/src

# List common and system library source files
# (i.e. for accessing STM32/Cortex M3 hardware) 
COMMON_FILES = $(CORE_SRC)/core_cm3.c
COMMON_FILES += $(DEVICE_SRC)/system_stm32f10x.c
COMMON_FILES += $(DEVICE_SRC)/startup/gcc_ride7/startup_stm32f10x_md.s

## Add dependencies library files here
COMMON_FILES += $(STD_PERIPH_SRC)/stm32f10x_rcc.c
COMMON_FILES += $(STD_PERIPH_SRC)/stm32f10x_gpio.c
COMMON_FILES += $(STD_PERIPH_SRC)/stm32f10x_spi.c
COMMON_FILES += $(STD_PERIPH_SRC)/stm32f10x_bkp.c
COMMON_FILES += $(STD_PERIPH_SRC)/stm32f10x_rtc.c
COMMON_FILES += $(STD_PERIPH_SRC)/stm32f10x_pwr.c

COMMON_FILES += $(wildcard src/*.c)
COMMON_FILES += $(wildcard src/fatfs/*.c)
COMMON_FILES += $(wildcard src/fatfs/option/*.c)


INCLUDE_FILES = -Ilibopencm3/include -Isrc -Isrc/fatfs -I$(DEVICE_SRC)  -I$(CORE_SRC)  -I$(CORE_SRC) -I$(STD_PERIPH)/inc

CDEFS        = -DSTM32F1

CFLAGS		+= -Os -g -Wall -Wextra -I. $(INCLUDE_FILES) -fno-common -mthumb -MD
CFLAGS		+= -ffunction-sections -fdata-sections
CFLAGS		+= -mcpu=cortex-m3 -DSTM32F1 -msoft-float
CFLAGS		+= $(CDEFS)

LDSCRIPT     	= stm32-h103.ld

LDFLAGS		+= -I . -lc -T$(LDSCRIPT) -Llibopencm3/lib -nostartfiles -Wl,--gc-sections -mthumb
LDFLAGS		+= -march=armv7 -mfix-cortex-m3-ldrd -msoft-float -lopencm3_stm32f1

OBJS = $(COMMON_FILES:.c=.o)

.PHONY: all burn clean

all: bld/$(PROJ_NAME).elf burn

bld/$(PROJ_NAME).elf: $(OBJS)
#	echo $(COMMON_FILES)	
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)
	$(CP) -O ihex bld/$(PROJ_NAME).elf bld/$(PROJ_NAME).hex	
	$(CP) -O binary bld/$(PROJ_NAME).elf bld/$(PROJ_NAME).bin	
	$(OD) -S bld/$(PROJ_NAME).elf > bld/$(PROJ_NAME).list

clean:
	find ./lib/ -name "*.o" -type f -delete
	find ./src/ -name "*.o" -type f -delete
	find ./lib/ -name "*.d" -type f -delete
	find ./src/ -name "*.d" -type f -delete
	rm -rf bld/*

burn: all
	sudo $(STLINK)/st-flash write bld/$(PROJ_NAME).bin 0x08000000	
