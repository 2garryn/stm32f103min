#include "stm32f10x.h"
#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"

#include "FreeRTOS.h"

#include "task.h"

void vApplicationTickHook( void ) {};

char mystring[100];

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

void vTaskLED1(void *pvParameters) {

  for (;;) {
    GPIOC->BRR = 0x00002000;
    vTaskDelay(100);
    GPIOC->BSRR = 0x00002000;
    vTaskDelay(200);
  }

}


int main(void)
{
    init_led();
    xTaskCreate( vTaskLED1, ( signed char * ) "LED1", configMINIMAL_STACK_SIZE, NULL, 2, ( xTaskHandle * ) NULL);
    vTaskStartScheduler();
    
}
