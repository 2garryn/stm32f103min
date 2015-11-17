#include "stm32f10x.h"
#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"

void init_led(void)
{
    GPIO_InitTypeDef GPIO_InitStructure;

    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);

    GPIO_InitStructure.GPIO_Pin =  GPIO_Pin_13;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOC, &GPIO_InitStructure);
}

void busyLoop(uint32_t delay )
{
  while(delay) delay--;
}

int main(void)
{
    init_led();

    while(1) {
       GPIOC->BRR = 0x00002000;
       busyLoop(2500000);
       GPIOC->BSRR = 0x00002000;
       busyLoop(2500000);
    }
}
