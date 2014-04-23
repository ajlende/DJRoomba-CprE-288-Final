/// Blocks for a specified number of milliseconds
void wait_ms(unsigned int time_val);

/// Shaft encoder initialization
void shaft_encoder_init(void);

/// Shaft encoder read function
char read_shaft_encoder(void);

/// Initialize Stepper Motor
void stepper_init(void);

/// Stepper motor move function
void move_stepper_motor_by_step(int num_steps, int direction);

/// Initialize PORTC, which is used by the push buttons
void init_push_buttons(void);

/// Return the position of button being pushed
/**
 * Return the position of button being pushed.
 * @return the position of the button being pushed.  A 1 is the rightmost button.  0 indicates no button being pressed
 */
char read_push_buttons(void);

//Sends a pulse out over sonar
void send_pulse(void);

// Converts the time that we measure into a distance in centimeters, takes in count from read
float time2dist(unsigned int Cycles);

//Initialization of the sonar
void ping_init(void);

// Reads the current distance on the sonar
float ping_read(void);

void timer3_init(void);

void servo_turn(float degrees);

// Initialize the IR distance sensor
void ADC_init(void);

unsigned int ADC_read(char channel);

// Calculate the distance from the ADC result
float calcCm(unsigned int DigitalOutput);
