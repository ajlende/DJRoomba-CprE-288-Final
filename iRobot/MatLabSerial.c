/*
 * PulseWidthMod.c
 *
 * Created: 3/13/2014 2:11:35 PM
 *  Author: ajlende
 */ 

// Note #3 has a bad IR sensor
#include <string.h>
#include <avr/io.h>
#include "util.h"
#include "lcd.h"
#include "usart.h"
#include <math.h>

typedef struct object_s {
	int degrees_start;
	int degrees_end;
	float distance;
	float width;
}object_t;

int main(void)
{
	
	serial_init(); // Initialize the Serial Communications
	
	ADC_init(); // Initialize the IR sensor
	
	ping_init(); // Initialize the Ping))) sensor
	
	lcd_init(); // Initialize the LCD
	
	init_push_buttons(); // Initialize the buttons
	
	timer3_init(); // Initialize the servo motor
	
	float degrees = 0;
	float IRDistance = 0;
	float PingDistance = 0;
	unsigned int raw = 0;
	int i = 0;
	
	servo_turn(degrees);
	
	char OutputString[100];
	
	//sprintf(OutputString, "%s%1s%1s", "Degrees", "IR Distance (cm)", "Sonar Distance (cm)");
	
	//USART_SendString(OutputString);
	while(1)
	{
	while(degrees <= 180) {
		
		// Average IR distances for a more stable measurement
		raw = 0;
		for(i = 0;i<5;i++)
		{
			raw += ADC_read(2);
			wait_ms(40);
		}

		IRDistance = calcCm(raw/5);
		PingDistance = ping_read();
		
		sprintf(OutputString, "%.0f %.2f %.2f", degrees, IRDistance, PingDistance);
		
		//lprintf(OutputString);
		//wait_ms(200);
		
		// sprintf(OutputString, "%14.0f%20.2f\n", degrees, IRDistance);
		
		USART_SendString(OutputString);
		
		degrees += 2;
		
		servo_turn(degrees);

	}
	degrees = 0;
	servo_turn(90);
	}
	
	}
