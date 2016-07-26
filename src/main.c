#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include "ff.h"

char mystring[100];

int fresult = -1;

void init_led(void) {
  rcc_periph_clock_enable(RCC_GPIOC);
  gpio_set_mode(GPIOC, GPIO_MODE_OUTPUT_50_MHZ,
                GPIO_CNF_OUTPUT_PUSHPULL, GPIO13);
}

void init_fatfs(void) {
  FRESULT fr;
  FATFS fs;
  fresult = f_mount(&fs, "", 1);
  
}

int main(void)
{
    init_led();
    int i;
    init_fatfs();
    while(1) {
      
      gpio_toggle(GPIOC, GPIO13);
      for (i = 0; i < 200000; i++)	/* Wait a bit. */
        __asm__("nop");
    }
    
}
