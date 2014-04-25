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
	float IRDistance_Prev = 0;
	float IRDistance = 0;
	char ping_count = 0;
	int degrees_start = 0;
	float PingDistance = 0;
	unsigned int raw = 0;
	object_t objects[20];
	int num_objects = 0;
	float smallest_width = 100;
	int smallest_width_index = 0;
	int i = 0;
	
	servo_turn(degrees);
	
	char OutputString[100];
	
	sprintf(OutputString, "%14s%20s%19s", "Degrees", "IR Distance (cm)", "Sonar Distance (cm)");
	
	USART_SendString(OutputString);
	
	while(degrees <= 180) {
		 
		 IRDistance_Prev = IRDistance;
/*
		if(degrees > 180)
		{
			degrees = 0;
			servo_turn(degrees);
		}
		if(degrees < 0)
		{
			degrees = 180;
			servo_turn(degrees);
		}*/
		
		// Average IR distances for a more stable measurement
		raw = 0;
		for(i = 0;i<5;i++)
		{
			raw += ADC_read(2);
			wait_ms(50);
		}

		IRDistance = calcCm(raw/5);
		


		//if leading edge, then begin saving pings
		if(IRDistance_Prev - IRDistance > 20 && IRDistance <= 100 && !ping_count)
		{
			degrees_start = degrees;
			ping_count = 1;
			PingDistance += ping_read();
		}
		
		//if trailing edge, stop saving pings.  Update object list
		if(ping_count && IRDistance - IRDistance_Prev > 20 && IRDistance_Prev <= 100)
		{
			
			objects[num_objects].degrees_end = degrees;
			objects[num_objects].degrees_start = degrees_start;
			objects[num_objects].distance = PingDistance/ping_count;
			//Tan takes in radians fyi
			objects[num_objects].width = 2.0 * objects[num_objects].distance * tan(((double)(objects[num_objects].degrees_end - objects[num_objects].degrees_start) * (3.14 / 180) /2.0));
			PingDistance = 0;
			ping_count = 0;
			lprintf("width:%f\ndeg_end:%d\ndist:%f\nnum_obj:%d", objects[num_objects].width, objects[num_objects].degrees_end, objects[num_objects].distance, num_objects + 1);
			num_objects++;
		}
		
		// Calculate PingDistance
		if(ping_count)
		{
			ping_count++;
			PingDistance += ping_read();
		}
		
		//lprintf("degrees = %.1f\nIRDistance = %.2f\nPingDistance = %.2f", degrees, IRDistance, PingDistance);
		
		//sprintf(OutputString, "%14.0f%20.2f%19.2f", degrees, IRDistance, PingDistance);
		
		// sprintf(OutputString, "%14.0f%20.2f\n", degrees, IRDistance);
		
		// USART_SendString(OutputString);
		
		degrees += 2;
		
		servo_turn(degrees);

	}
	
	//calculate the smallest object
	for(i=0; i < num_objects; i++)
	{
		if(objects[i].width < smallest_width)
		{
			smallest_width = objects[i].width;
			smallest_width_index = i;
		}
	}
	
	servo_turn((objects[smallest_width_index].degrees_start + objects[smallest_width_index].degrees_end) / 2);
	
	}
