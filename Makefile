
##########################################################
## START DEFINITIONS 
##########################################################

# Project name
PROJ_NAME=myproject

# Path to your arm gcc
ARM_CC_PATH=/home/garry/arm/gcc-arm-none-eabi-4_9-2015q3
STLINK=/home/garry/arm/stlink
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

# Declare command line flags
CORE_CFLAGS = -I./ -I$(CORE_SRC) -I$(DEVICE_SRC) -I$(STD_PERIPH)/inc  -fno-common -O0 -g -mcpu=cortex-m3 -mthumb 
CFLAGS  = $(CORE_CFLAGS) -c 
CFLAGS_LINK = -Wl,-Tmain.ld -nostartfiles $(CORE_CFLAGS)
ASFLAGS = -mcpu=cortex-m3 -mthumb -g
LDFLAGS = -Tmain.ld -nostartfiles
CPFLAGS = -Obinary
ODFLAGS	= -S

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

COMMON_FILES += src/*.c


.PHONY: all burn clean

all: bld/$(PROJ_NAME).elf burn

bld/$(PROJ_NAME).elf: $(COMMON_FILES)
	$(CC) $(CFLAGS_LINK) -Isrc/ -o $@ $^
	$(CP) -O ihex bld/$(PROJ_NAME).elf bld/$(PROJ_NAME).hex	
	$(CP) -O binary bld/$(PROJ_NAME).elf bld/$(PROJ_NAME).bin	
	$(OD) -S bld/$(PROJ_NAME).elf > bld/$(PROJ_NAME).list

clean: 
	rm -rf bld/*

burn: all
	sudo $(STLINK)/st-flash write bld/$(PROJ_NAME).bin 0x08000000	
