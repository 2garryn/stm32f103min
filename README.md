
Simplified version of https://github.com/beckus/stm32_p103_demos

GCC-ARM-NON-EABI: https://launchpad.net/gcc-arm-embedded/+download

ST-LINK: https://github.com/texane/stlink


Tested on minimum development board with stm32f103c8t6. LED is connected to PC13.
Photos can be found here: http://www.rogerclark.net/stm32f103-and-maple-maple-mini-with-arduino-1-5-x-ide/



1. Define project name in Makefile
2. Set pathes to stlink and gcc-arm-none-eabi
3. Compile: make
4. Upload to MCU: make burn