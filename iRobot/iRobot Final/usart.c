#include <avr/io.h>
#include "usart.h"

#define F_CPU 16000000

#define BAUD 38400

void serial_init(void) {

	unsigned long baud = BAUD;

	// WAS 51
	baud = (F_CPU/8/baud)-1;
	
	/* Set baud rate */ 
	UBRR0H = (unsigned char) (baud >> 8); 
	UBRR0L = (unsigned char) baud; 
	
	/* Enable double speed mode */ 
	UCSR0A = 0b00000010; 
	
	/* Set frame format: 8 data bits, 2 stop bits */ 
	UCSR0C = 0b00001110; 
	
	/* Enable receiver and transmitter */ 
	UCSR0B = 0b00011000;
	
	/*Enable Interrupt*/
	//UCSR0B |= 0b11100000; // optional: 
	
}


void USART_Transmit( char data) {
	/* Wait for empty transmit buffer */
	while ( !( UCSR0A & 0b00100000) );
	
	/* Put data into buffer, sends the data */
	UDR0 = data;
}


unsigned char USART_Receive(void)
{
	/* Wait for data to be received */
	//while ( !(UCSR1A & (1<<RXC1)) )
	if((UCSR0A & 0b10000000))
	{
			return UDR0;
	}
	/* Get and return received data from buffer */
	else
	{
		return 0;
	}
}

char* USART_RecieveString()
{
	int count = 0;

	
	//String to return
	char receivedVars[5];
			
	//iterate through to get string		
	while(1)
	{
		receivedVars[count] = USART_Receive();
		if(receivedVars[count] != '/0') break;
		count ++;
	}
	
	//return string
	return receivedVars;
	
}


void USART_SendString(char SentString[])
{
	char flag = 1;
	int i = 0;
	while(flag)
	{
		if(SentString[i])
		{
			USART_Transmit(SentString[i]);
		}
		else
		{
			flag = 0;
			USART_Transmit(10);
			USART_Transmit(13);
		}
		i++;
	}
	
}

void USART_Flush( void )
{
	unsigned char dummy;
	while ( UCSR0A & (1<<RXC) )
	{
		dummy = UDR0;
	}
}