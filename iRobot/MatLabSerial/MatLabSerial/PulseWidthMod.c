/*
 * PulseWidthMod.c
 *
 * Created: 3/13/2014 2:11:35 PM
 *  Author: ajlende
 */ 


#include <avr/io.h>
#include "util.h"
#include "lcd.h"

int main(void)
{
	
	lcd_init();
	
	init_push_buttons();
	
	timer3_init();
	
	//while(1);
	
	char direction = 1; // 0 is negative, !0 is positive
	int counter = 800;
	float degrees = 90.0;
	unsigned char button;
	
	servo_turn(90);
	
	while(1) {
		 button = read_push_buttons();

		switch(button) {
			case 1:
				// +-1 degree
				degrees = (direction) ? (degrees + 1) : (degrees - 1);
				servo_turn(degrees);
				// +- 80/9 count
				break;
			case 2:
				// +- 2.5 deg
				degrees = (direction) ? (degrees + 2.5) : (degrees - 2.5);
				servo_turn(degrees);
			break;
			case 3:
				// +- 5 deg
				degrees = (direction) ? (degrees + 5) : (degrees - 5);
				servo_turn(degrees);
				break;
			case 4:
				// +/- toggle
				direction = !direction;
				break;
			default:
				// do nothing
				break;
		}
		
		button = 0;
		if(degrees > 180)
		{
			degrees = 0;
			servo_turn(degrees);
		}
		if(degrees < 0)
		{
			degrees = 180;
			servo_turn(degrees);
		}
		
		
		(direction) ? lprintf("incrementing\ndegrees = %f", degrees) : lprintf("decrementing\ndegrees = %f", degrees);

	}
	
}
