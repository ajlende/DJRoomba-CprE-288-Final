/**
 * util.c: utility functions for the Atmel platform
 * 
 * For an overview of how timer based interrupts work, see
 * page 111 and 133-137 of the Atmel Mega128 User Guide
 *
 * @author Zhao Zhang & Chad Nelson
 * @date 06/26/2012
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include "util.h"
#include "lcd.h"

// Global used for interrupt driven delay functions
volatile unsigned int timer2_tick;
void timer2_start(char unit);
void timer2_stop();

// Times recorded from ISR(TIMER1_CAPT_vect) and the flag used with is
volatile unsigned current_time = 0;
volatile int update_flag = 0;

// Initialize the IR distance sensor
void ADC_init(void) {
	// Enable ADC
	ADCSRA |= (1 << ADEN);

	// ADC Prescaler setup - divide the clock speed by 128
	ADCSRA |= 0x07;

	// Set reference voltage to 2.56V
	ADMUX |= (1 << REFS1) | (1 << REFS0);
	
	// Make the result left adjusted
	// ADMUX |= _BV(ADLAR);
}





// Read the output from the ADC, currently using channel 2
unsigned int ADC_read(char channel) {
	
	ADMUX |= (channel & 0x1F);
	
	// Set Start Conversion
	ADCSRA |= (1 << ADSC);
	
	while (ADCSRA & (1 << ADSC));
	
	return ADC;
}

// Calculate the distance from ADC result
float calcCm(unsigned int DigitalOutput) {
	/*float AnalogOutput = ((float) DigitalOutput) * 2.56/1023.0;
	float Distance = 1/(AnalogOutput - 0.42); 
	//Output = 1/(distance + .42)
	
	return Distance;*/
	
	return 46000/(5.0 + 3.9* ((float)DigitalOutput));
	
	
	
}

/// Blocks for a specified number of milliseconds
void wait_ms(unsigned int time_val) {
	//Seting OC value for time requested
	OCR2=250; 				//Clock is 16 MHz. At a prescaler of 64, 250 timer ticks = 1ms.
	timer2_tick=0;
	timer2_start(0);

	//Waiting for time
	while(timer2_tick < time_val);

	timer2_stop();
}


// Start timer2
void timer2_start(char unit) {
	timer2_tick=0;
	if ( unit == 0 ) { 		//unit = 0 is for slow 
        TCCR2=0b00001011;	//WGM:CTC, COM:OC2 disconnected,pre_scaler = 64
        TIMSK|=0b10000000;	//Enabling O.C. Interrupt for Timer2
	}
	if (unit == 1) { 		//unit = 1 is for fast
        TCCR2=0b00001001;	//WGM:CTC, COM:OC2 disconnected,pre_scaler = 1
        TIMSK|=0b10000000;	//Enabling O.C. Interrupt for Timer2
	}
	sei();
}


// Stop timer2
void timer2_stop() {
	TIMSK&=~0b10000000;		//Disabling O.C. Interrupt for Timer2
	TCCR2&=0b01111111;		//Clearing O.C. settings
}


// Interrupt handler (runs every 1 ms)
ISR (TIMER2_COMP_vect) {
	timer2_tick++;
}

/// Initialize PORTC to accept push buttons as input
void init_push_buttons(void) {
	DDRC &= 0xC0;  //Setting PC0-PC5 to input
	PORTC |= 0x3F; //Setting pins' pull up resistors
}


/// Initialize PORTC for input from the shaft encoder
void shaft_encoder_init(void) {
	DDRC &= 0x3F;	//Setting PC6-PC7 to input
	PORTC |= 0xC0;	//Setting pins' pull-up resistors
}

/// Read the shaft encoder
/**
 * Reads the two switches of the shaft encoder and compares the values
 * to the previous read.  This function should be called very frequently
 * for the best results.
 *
 * @return a value indicating the shaft encoder has moved:
 * 0 = no rotation (switches did not change)
 * 1 = CW rotation
 * -1 = CCW rotation
 */
char read_shaft_encoder(void) {

	return 0;
}



/// Initialize PORTE to control the stepper motor
void stepper_init(void) {
	DDRE |= 0xF0;  	//Setting PE4-PE7 to output
	PORTE &= 0x8F;  //Initial postion (0b1000) PE4-PE7
	wait_ms(2);
	PORTE &= 0x0F;  //Clear PE4-PE7
}

/// Turn the Stepper Motor
/**
 * Turn the stepper motor a given number of steps. 
 *
 * @param num_steps A value between 1 and 200 steps (1.8 to 360 degrees)
 * @param direction Indication of direction: 1 for CW and -1 for CCW 
 */
void  move_stepper_motor_by_step(int num_steps, int direction) {
	
}

void ping_init(void)
{
	// Clear the Waveform Generation Mode WGM11 (bit 1) and WGM10 (bit 0). Everything else should also be 0. 
	TCCR1A = 0b00000000;
	
	// Clear the WGM12 (bit 3) and WGM13 (bit 4).
	// Noise Canceler (bit 7) should also be set.
	// Edge Select (bit 6): 0 = falling edge and 1 = rising edge 
	// clock io / 256 (From prescalar) (bits 0-2)
	TCCR1B = 0b11000100;
	
	// Force Output Compare on channel A, B, or C (bits 5-7) all should be set to 0. We shouldn't have to change this.
	// TCCR1C = 0;
	
	// Timer/Counter 1 Input Capture Enable (bit 5) 
	// Timer/Counter 1 Overflow Interrupt Enable (bit 2). Use a big prescalar, so we won't need to use this.
	// Use these to disable the interrupt when outputting, and then enable when we are listening for a response.
	TIMSK = 0b00000000;
	
	
	// ICR1 = 0;
	// PD4 = 1;
	
	// ICF1 = ICP1 Input Capture Flag
	
}

// Reads the current distance on the sonar
float ping_read(void)
{
	unsigned int time;
	
	send_pulse();
	
	// Timer/Counter 1 Input Capture Enable (bit 5) 
	TIMSK = 0b00100000;
	
	// Wait until flag is set (rising clock edge has been read)
	while (update_flag);
	
	// Set the register to look at falling edge
	TCCR1B = 0b10000100;
	
	//Store first time of rising edge
	time = current_time;
	
	// Wait until flag is reset (falling clock edge has been read)
	while(!update_flag);
	
	// Set the register to look at rising edge
	TCCR1B = 0b11000100;
	
	// Set time equal to difference in Trising and Tfalling
	time = current_time-time;
	
	// Timer/Counter 1 Input Capture Enable (bit 5)
	TIMSK = 0b00000000;
	
	//lprintf("Time: %d",time);
	
	// Calculate the width of the pulse; convert to centimeters
	return time2dist(time);
	
}

// Gets called when we have a rising or falling edge depending on TCCR1B bit 6
ISR(TIMER1_CAPT_vect)
{
		current_time = ICR1;
		update_flag = !update_flag;
}

// send a pulse on PD4
void send_pulse(void)
{
	DDRD |= 0x10; // set PD4 as output
	PORTD |= 0x10; // set PD4 to high
	wait_ms(1); // wait
	PORTD &= 0xEF; // set PD4 to low
	DDRD &= 0xEF; // set PD4 as input	
}

// Converts the time that we measure into a distance in centimeters, takes in count from read
float time2dist(unsigned int time)
{
	//OLD EQUATION
	/*unsigned int ClockFrequency = 62500;
	
	// distance = rate * time
	return 34000.0 * (((float) Cycles)/ClockFrequency)/3.0;*/
	
	//New Equation
	return .277 * ((float) time) - 31.944;
}

void servo_turn(int degrees)
{
	// The servo only moves from 0 to 180 degrees.
	//if (degrees > 180 || degrees < 0) return;
	
	// For Robot #3
	//unsigned int pulse_width = 375 * (180 - (degrees * 104/181 + 37))/90; // pulse width in cycles
	
	
	// For robot #4
	unsigned int pulse_width = (0.00944 * ((float) degrees) + 0.49) * 250; // pulse width in cycles
	
	// calculate pulse width in cycles
	OCR3B = pulse_width-1; // set pulse width
	// you need to call wait_ms() here to enforce a delay for the servo to
	/// move to the position
	wait_ms(20);
}

//unsigned pulse_period = …; // pulse period in cycles
void timer3_init(void)
{
	//Count up every 16000000/prescalar
	//Set our pulses to 1ms
	
	unsigned int clk_cycles_per_ms = 16000000/1000/64;
	
	unsigned int pulse_period = clk_cycles_per_ms*10;
	
	// On robot #3
	// 90 degrees ~ 0.865
	// unsigned int mid_point = clk_cycles_per_ms*1.505;
	// 2.37ms ~ 180deg
	// 0.64ms ~ 0deg
	
	// On robot #4
	unsigned int mid_point = clk_cycles_per_ms*1.35;
	// 2.18ms ~ 180deg
	// 0.48ms ~ 0deg
	// 1.35 ms = 90deg
	
	OCR3A = pulse_period-1; // number of cycles in the interval
	
	OCR3B = mid_point-1; // if you want to move servo to the middle
	
	//Set 1 and 0 to 1 for WGM
	//Set Comparator B to 10
	TCCR3A = 0b00100011; // set COM and WGM (bits 3 and 2)
	
	//Set 4 and 3 to 1 for WGM16
	//Set 2, 1, 0 for 64 clock prescaler
	TCCR3B = 0b00011011; // set WGM (bits 1 and 0) and CS
	
	//ETIFR is for reading when overflow or input capture
	
	// Note: TCCR3C is not for configuration
	// it’s necessary to set the OC3B (PE4) pin as the output
	DDRE |= 1 << 4; // set Port E pin 4 (OC3B) as output
}

/**
 * Return the position of button being pushed.
 * @return the position of the button being pushed.  A 1 is the rightmost button.  0 indicates no button being pressed
 */
char read_push_buttons(void) {

	unsigned char n = 5;
	//unsigned int VAL = 1;
	if ((PINC & 0x3f)==0x3f)
	{
		return 0;
	}
	for (n = 5; n >= 0; n--) {
		if (!((1 << n) & PINC)) {
			
			return n+1;
		}
	}
	
	return 0;
}

//Movement Functions
//Move forward contains all other functions, allows for error checking while moving
char move_forward(oi_t *sensor, int centimeters)
{
	int sum = 0;
	int dist = 0;
	int new_dist = 0;
	char outputString[20];
	oi_set_wheels(150, 150); // move forward

	while (sum < centimeters*10)
	{
		oi_update(sensor);
		sum += sensor->distance;

		if(sensor->bumper_left)
		{
			oi_set_wheels(0, 0); // stop

			move_backward(sensor,10);
			turn_clockwise(sensor,45);

			USART_SendString("Left Bumper Triggered"); //
			return 1;
		}
		else if(sensor->bumper_right)
		{
			oi_set_wheels(0, 0); // stop

			move_backward(sensor,10);
			turn_counterclockwise(sensor,45);

			USART_SendString("Right Bumper Triggered");
			return 2;
		}
		if((sensor->cliff_frontleft_signal > 550) || (sensor->cliff_frontright_signal > 450))
		{
			lprintf("Line Detected");
			oi_set_wheels(0,0);
			USART_SendString("Line Detected");
			return 3;
		}
		else if((sensor->wheeldrop_caster == 1) || (sensor->wheeldrop_left == 1) || (sensor->wheeldrop_right == 1) || (sensor->cliff_frontleft_signal < 10) || (sensor->cliff_frontright_signal < 10)|| (sensor->cliff_left_signal < 10) || (sensor->cliff_right_signal < 10))
		{
			lprintf("Cliff Edge Detected");
			move_backward(sensor,10);

			USART_SendString("Cliff Edge Detected");
			return 4;
		}
		return 0;
	}

	oi_set_wheels(0, 0); // stop
	
	sprintf(outputString, "Moved %f centimeters", sum);
	
	USART_SendString(outputString);

}


void move_backward(oi_t *sensor, int centimeters)
{
	int sum = 0;
	oi_set_wheels(-200, -200); // move backward
	while (sum < centimeters*10) {
		oi_update(sensor);
		sum -= sensor->distance;
	}

	oi_set_wheels(0, 0); // stop
}

void turn_clockwise(oi_t *sensor, int degrees)
{
	int sum = 0;
	char outputString[20];
	oi_set_wheels(-200, 200);
	while (sum < degrees-12) {
		oi_update(sensor);
		sum -= sensor->angle;
		
		sprintf(outputString, "Turned %f degrees clockwise", degrees);
		
		USART_SendString(outputString);

	}
	oi_set_wheels(0, 0); // stop
}

void turn_counterclockwise(oi_t *sensor, int degrees)
{
	int sum = 0;
	char outputString[20];
	oi_set_wheels(200, -200);
	while (sum < degrees-12) {
		oi_update(sensor);
		sum += sensor->angle; //maybe
		
		sprintf(outputString, "Turned %f degrees counterclockwise", degrees);
		
		USART_SendString(outputString);

	}
	oi_set_wheels(0, 0); // stop
}
