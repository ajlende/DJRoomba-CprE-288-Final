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
	
	song_init();
	
	oi_t *sensor_data = oi_alloc();
	oi_init(sensor_data); // should turn the iRobot Create's power LED yellow
	
	int degrees = 89;
	float IRDistance = 0;
	float PingDistance = 0;
	unsigned int raw = 0;
	int i = 0;
	char serialInput = 0;
	int count = 0;
	
	char echoString[20];
	
	servo_turn(degrees);
	
	char OutputString[100];

	while(1) {
		
		serialInput = USART_Receive();
		lprintf("%c", serialInput);
		
		//Big Scan
		if(serialInput == 'S') {
			
			degrees = 0;
			servo_turn(degrees);
			
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
				USART_SendString(OutputString);
		
				degrees += 2;
		
				servo_turn(degrees);

			}
			
			degrees = 90;
			servo_turn(degrees);
		}
		
		//Small Scan
		if(serialInput == 's') {
			
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
				USART_SendString(OutputString);
				
				degrees += 2;
				
				servo_turn(degrees);

			}
			
			degrees = 90;
			servo_turn(degrees);
		}
		
		
		if(serialInput == 'f')
		{

			char nextletter = 0;
			while(nextletter == 0) {
				nextletter = USART_Receive();
			}
			int actualnumber = (((int) nextletter)-48) * 10;
			//lprintf("%c", nextletter);
			//wait_ms(500);
			move_forward(sensor_data, actualnumber);
		}
		
		if(serialInput == 'r')
		{
			//int tempDegrees = atoi(numRecieved);
						
			char nextletter = 0;
			while(nextletter == 0)
				nextletter = USART_Receive();
			int actualnumber = (((int) nextletter)-48) * 10;
			//lprintf("actual %d\n", actualnumber);
			turn_clockwise(sensor_data, actualnumber);
			//actualnumber -= 10;
			// sprintf(turnMessage,"Turned right %d degrees", actualnumber);
			// USART_SendString(turnMessage);
		}
		
		if(serialInput == 'l')
		{
			//int tempDegrees = atoi(numRecieved);
			//char turnMessage[40];	
			char nextletter = 0;
			while(nextletter == 0)
				nextletter = USART_Receive();
			int actualnumber = (((int) nextletter)-48) * 10;
			turn_counterclockwise(sensor_data, actualnumber);
			//actualnumber -= 10;
			// sprintf(turnMessage,"Turned left %d degrees", actualnumber);
			// USART_SendString(turnMessage);			
		}
		// USART_SendString("Small Scan Complete");
		/*
		if(serialInput == 'c' || serialInput == '!') {
			USART_Flush();
			lprintf("Flushed!\n");
		}
		*/
		
		if(serialInput == 'b')
		{
			move_backward(sensor_data, 5);
		}
		
			
		if(serialInput == 'd')
		{
			reportData(sensor_data);
		}
		
		
		if(serialInput == 'Q')
		{
			//Play song cuz we're done lol
			oi_byte_tx(141);
			oi_byte_tx(1);
			//oi_free(sensor_data);
			//return;
		}
		
	}
}