function null = serialclose(serial)

%Release OI sensor data
fwrite(serial, 'Q');

%Close
fclose(serial);

%Delete
delete(serial);
clear all;