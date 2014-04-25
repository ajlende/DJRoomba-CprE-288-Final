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
#include "open_interface.h"
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
	
	oi_t *sensor_data = oi_alloc();
	oi_init(sensor_data); // should turn the iRobot Create's power LED yellow
	
	int degrees = 80;
	float IRDistance = 0;
	float PingDistance = 0;
	unsigned int raw = 0;
	int i = 0;
	char serialInput = 0;
	
	servo_turn(degrees);
	
	char OutputString[100];
	
	//sprintf(OutputString, "%s%1s%1s", "Degrees", "IR Distance (cm)", "Sonar Distance (cm)");
	
	//USART_SendString(OutputString);
	while(1)
	{
		
		serialInput = USART_Receive();
	
		//Big Scan
		if(serialInput == 'S')
		{
			lprintf("Big Scan\n");
			while(degrees <= 180) {
		
				// Average IR distances for a more stable measurement
				raw = 0;
				for(i = 0;i<3;i++)
				{
					raw += ADC_read(2);
					wait_ms(20);
				}

				IRDistance = calcCm(raw/3);
				PingDistance = ping_read();
		
				sprintf(OutputString, "%d %.2f %.2f", degrees, IRDistance, PingDistance);
		
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
		
		//Small Scan
		if(serialInput == 's')
		{
			lprintf("Small Scan\n");
			degrees = 45;
			servo_turn(degrees);
			while(degrees <= 135) {
				
				// Average IR distances for a more stable measurement
				raw = 0;
				for(i = 0;i<3;i++)
				{
					raw += ADC_read(2);
					wait_ms(20);
				}

				IRDistance = calcCm(raw/3);
				PingDistance = ping_read();
				
				sprintf(OutputString, "%d %.2f %.2f", degrees, IRDistance, PingDistance);
				
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
		
		if(serialInput == 'f')
		{
			lprintf("Moving Forward\n");
			move_forward(sensor_data, 20);
		}
		
		if(serialInput == 'r')
		{
			lprintf("Rotating Right\n");
			turn_clockwise(sensor_data, 45);
		}
		
		if(serialInput == 'l')
		{
			lprintf("Rotating Left\n");
			turn_counterclockwise(sensor_data, 45);
		}
		// USART_SendString("Small Scan Complete");
		
		if(serialInput == 'Q')
		{
			lprintf("Quitting...\n");
			oi_free(sensor_data);
			return;
		}
	}
}