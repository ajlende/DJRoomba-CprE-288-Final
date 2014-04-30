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
#include <stdio.h>
#include <stdlib.h>

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
	char serialInput;
	int count = 0;
	char* numRecieved;
	
	char echoString[20];
	
	servo_turn(degrees);
	
	char OutputString[100];
 
	
	//sprintf(OutputString, "%s%1s%1s", "Degrees", "IR Distance (cm)", "Sonar Distance (cm)");
	
	//USART_SendString(OutputString);
	while(1)
	{
		
		/*wait_ms(500);
		oi_update(sensor_data);
		lprintf("Left: %d\nRight: %d", sensor_data->cliff_frontleft_signal, sensor_data->cliff_frontright_signal);
		*/
		//numRecieved = USART_RecieveString(count);
		//USART_SendString(numRecieved);
		
		serialInput = USART_Receive();
		
		//if (serialInput) {
		//	USART_SendString(serialInput);
		//}
		
		//Big Scan
		if(serialInput == 'S')
		{
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
						
			//int tempDistance = atoi(numRecieved);
			char nextletter = 0;
			while(nextletter == 0)
				nextletter = USART_Receive();
			int actualnumber = (((int) nextletter)-48) * 10;
			move_forward(sensor_data, 50);
		}
		
		if(serialInput == 'r')
		{
			//int tempDegrees = atoi(numRecieved);
			
			char nextletter = 0;
			while(nextletter == 0)
				nextletter = USART_Receive();
			int actualnumber = (((int) nextletter)-48) * 10;
			// llprintf("actual %d\n", actualnumber);
			turn_clockwise(sensor_data, actualnumber);
		}
		
		if(serialInput == 'l')
		{
			//int tempDegrees = atoi(numRecieved);
			char nextletter = 0;
			while(nextletter == 0)
				nextletter = USART_Receive();
			int actualnumber = (((int) nextletter)-48) * 10;
			turn_counterclockwise(sensor_data, actualnumber);
		}
		// USART_SendString("Small Scan Complete");
		
		if(serialInput == 'c' || serialInput == '!') {
			USART_Flush();
			lprintf("Flushed!\n");
		}
		
		if(serialInput == 'b')
		{
			move_backward(sensor_data, 5);
		}
				
		if(serialInput == 'd')
		{
			void reportData(sensor_data);
		}
		if(serialInput == 'Q')
		{
			oi_free(sensor_data);
			return;
		}
	}
}