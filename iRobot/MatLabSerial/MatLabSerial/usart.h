void serial_init(void);

void USART_Transmit(char data);

unsigned char USART_Receive(void);

void USART_SendString(char SentString[]);

char* USART_RecieveString(void);