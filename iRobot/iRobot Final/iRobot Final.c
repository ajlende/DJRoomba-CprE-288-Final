/*
 * PulseWidthMod.c
 *
 * Created: 3/13/2014 2:11:35 PM
 *  Author: Alex Lende, Nic Dubois, Nick Montelibano, Ben Williams, Chris Sheafe
 */ 


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
		
		///Big Scan
		/************************************************************************/
		/* Performs a 180 degree scan in front of the robot. This sweeps both   
		   the IR and sonar sensors from 0 degrees to 180 degrees relative to   
		   the robot. For each degree, the function pulls in sensor data,       
		   translates it into distance values, concatenates a string of these   
		   values, and sends this string via serial communication. This         
		   functioning is performed when an upper case 'S' is received via      
		   serial communication.                                                
		/************************************************************************/
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
		
		///Small Scan
		/************************************************************************/
		/* Performs a 90 degree scan in front of the robot. This sweeps both the 
		   IR and sonar sensors from 0 degrees to 90 degrees relative to the    
		   robot. For each degree, the function pulls in sensor data, translates
		   it into distance values, concatenates a string of these values, and  
		   sends this string via serial communication. This functioning is      
		   performed when a lower case 's' is received via serial communication.
		/************************************************************************/
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
		
		///Move Forward
		/************************************************************************/
		/* When a lower case 'f' is received via serial communication, this     
		   statement functions to call the move function, allowing for an input 
		   for the distance we would like to move the robot. The functioning    
		   polls for a second character via serial that will determine the    
		   distance (this should be a character 0-9, where the character value  
		   for each character is essential 10 times the decimal value of that   
		   character, e.g. 5 => 50cm). After the polling, the robot is told to  
		   move forward by the specified amount of centimeters.                 
		/************************************************************************/
		if(serialInput == 'f')
		{

			char nextletter = 0;
			while(nextletter == 0) {
				nextletter = USART_Receive();
			}
			int actualnumber = (((int) nextletter)-48) * 10;
			
			move_forward(sensor_data, actualnumber);
		}
		
		///Turn Right
		/************************************************************************/
		/* Turns the robot clockwise. This functioning allows for an input for  
		   the amount of degrees to be turned. The second character received    
		   after a lower case 'r' is received should be a 0-9, which will be    
		   translated to the degrees the robot should turn (where the character
		   value for each character is essential 10 times the decimal value of  
		   that character, e.g. 5 => 50cm). After the polling, the robot is told
		   to turn clockwise by the specified amount of degrees.                
		/************************************************************************/
		if(serialInput == 'r')
		{
						
			char nextletter = 0;
			while(nextletter == 0)
				nextletter = USART_Receive();
			int actualnumber = (((int) nextletter)-48) * 10;
			turn_clockwise(sensor_data, actualnumber);
			
		}
		
		///Turn Left
		/************************************************************************/
		/* Turns the robot counterclockwise. This functioning allows for an 
		   input for the amount of degrees to be turned. The second character 
		   received after a lower case 'l' is received should be a 0-9, which 
		   will be translated to the degrees the robot should turn (where the 
		   character value for each character is essential 10 times the decimal 
		   value of that character, e.g. 5 => 50cm). After the polling, the robot 
		   is told to turn counterclockwise by the specified amount of degrees.        
		/************************************************************************/
		if(serialInput == 'l')
		{
			
			char nextletter = 0;
			while(nextletter == 0)
				nextletter = USART_Receive();
			int actualnumber = (((int) nextletter)-48) * 10;
			turn_counterclockwise(sensor_data, actualnumber);
						
		}
		
		///Move Backward
		/************************************************************************/
		/* This functioning occurs following a lower case 'b' received via
		   serial. This section moves the robot back 5cm when called. There is
		   no changing the distance the robot is to be moved backwards as this
		   could be a dangerous practice when there are no sensors on the back
		   of the robot.
		/************************************************************************/
		if(serialInput == 'b')
		{
			move_backward(sensor_data, 5);
		}
		
		///Report Sensor Data
		/************************************************************************/
		/* This functioning sends a string containing the values of all the
		   cliff sensors and the wheel drop sensors on the robot via serial
		   communication. The functioning begins upon a lower case 'd' received
		   from a serial communication.
		/************************************************************************/	
		if(serialInput == 'd')
		{
			reportData(sensor_data);
		}
		
		///Play Song
		/************************************************************************/
		/* This section begins upon receiving an upper case 'Q' via serial
		   communication. The functioning loads and plays song 1 (Take on Me).
		/************************************************************************/
		if(serialInput == 'Q')
		{
			oi_byte_tx(141);
			oi_byte_tx(1);
		}
		
	}
}