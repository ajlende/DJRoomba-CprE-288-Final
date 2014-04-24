/*
 * drop_sensors.c
 *
 * Created: 4/15/2014 7:05:52 PM
 *  Author: npdubois
 */ 


#include <avr/io.h>
#include "open_interface.h"
#include "lcd.h"
#include "util.h"

int main(void)
{
	int paramater = 450;
	lcd_init();
	oi_t *sensor_data = oi_alloc();
	while(1){
		oi_init(sensor_data);
		
		oi_set_wheels(100,100);
		
		if((sensor_data->cliff_frontleft_signal > 550) || (sensor_data->cliff_frontright_signal > 450))
		{
			lprintf("Line Detected");
			oi_set_wheels(0,0);
			USART_Transmit('b');
			break;
		}
		
		else if((sensor_data->wheeldrop_caster == 1) || (sensor_data->wheeldrop_left == 1) || (sensor_data->wheeldrop_right == 1) || (sensor_data->cliff_frontleft_signal < 10) || (sensor_data->cliff_frontright_signal < 10))
		{
			lprintf("Wheel Drop Detected");
			oi_set_wheels(-250,-250);
			wait_ms(2000);
		}
				
		
		
		lprintf("frontleft: %d\nfrontright: %d\nright:  %d\nleft: %d",sensor_data->cliff_frontleft_signal,sensor_data->cliff_frontright_signal,sensor_data->cliff_right_signal,sensor_data->cliff_left_signal);
		
		//move_forward(sensor_data,200);

		oi_free(sensor_data);
		wait_ms(50);
	}
}

void move_forward(oi_t *sensor, int centimeters)
{
	int sum = 0;
	int dist = 0;
	int new_dist = 0;
	oi_set_wheels(250, 250); // move forward; full speed
	
	while (sum < centimeters*10)
	{
		oi_update(sensor);
		sum += sensor->distance;
		
		if(sensor->bumper_left)
		{
			oi_set_wheels(0, 0); // stop
			dist = sensor->distance;
			
			move_backward(sensor,15);
			turn_clockwise(sensor,90);
			move_forward(sensor,25);
			turn_counterclockwise(sensor,90);
			oi_set_wheels(250, 250); // move forward; full speed
			sum = sum - 250;
			
			//move_forward(sensor,);
		}
		if(sensor->bumper_right)
		{
			oi_set_wheels(0, 0); // stop
			dist = sensor->distance;
			
			move_backward(sensor,15);
			turn_counterclockwise(sensor,90);
			move_forward(sensor,25);
			turn_clockwise(sensor,90);
			//new_dist = (centimeters*10)-sum;
			oi_set_wheels(250, 250); // move forward; full speed
			sum = sum - 250;
			//move_forward(sensor,new_dist);
		}
	}
	
	oi_set_wheels(0, 0); // stop
	
}


void move_backward(oi_t *sensor, int centimeters)
{
	int sum = 0;
	oi_set_wheels(-250, -250); // move forward; full speed
	while (sum < centimeters*10) {
		oi_update(sensor);
		sum -= sensor->distance;
	}
	
	oi_set_wheels(0, 0); // stop
}

void turn_clockwise(oi_t *sensor, int degrees)
{
	int sum = 0;
	
	oi_set_wheels(-200, 200);
	while (sum < degrees-12) {
		oi_update(sensor);
		sum -= sensor->angle;
		
	}
	oi_set_wheels(0, 0); // stop
	
}

void turn_counterclockwise(oi_t *sensor, int degrees)
{
	int sum = 0;
	
	oi_set_wheels(200, -200);
	while (sum < degrees-12) {
		oi_update(sensor);
		sum += sensor->angle; //maybe
		
	}
	oi_set_wheels(0, 0); // stop
}
