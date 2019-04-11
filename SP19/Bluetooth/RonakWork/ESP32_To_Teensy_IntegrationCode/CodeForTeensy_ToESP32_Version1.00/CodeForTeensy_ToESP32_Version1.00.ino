/*
   There are three serial ports on the ESP known as U0UXD, U1UXD and U2UXD.

   U0UXD is used to communicate with the ESP32 for programming and during reset/boot.
   U1UXD is unused and can be used for your projects. Some boards use this port for SPI Flash access though
   U2UXD is unused and can be used for your projects.

*/

#define RXD2 16
#define TXD2 17

bool searching = true; // searching for the 4 bytes of 255
int startCounter = 0;
int arrayCounter = 0;
byte byteArray[68];
char charArray[137];

uint32_t ti;
uint32_t tf;
uint8_t td;

void setup() {
  // Note the format for setting a serial port is as follows: Serial2.begin(baud-rate, protocol, RX pin, TX pin);
  Serial.begin(115200);
  //Serial1.begin(9600, SERIAL_8N1, RXD2, TXD2);
  Serial2.begin(250000, SERIAL_8N1, RXD2, TXD2);
  Serial.println("Serial Txd is on pin: " + String(TXD2));
  Serial.println("Serial Rxd is on pin: " + String(RXD2));
}

void loop() { //Choose Serial1 or Serial2 as required
  while (Serial2.available()) {
    byte checkByte = byte(Serial2.read());

    if (searching) {
      if (checkByte == 255) {
        startCounter++;
        if (startCounter == 4) {
          startCounter = 0;
          searching = false;
        }
      }
    } else {
      byteArray[arrayCounter] = checkByte;
      arrayCounter++;
      if (arrayCounter == 68) {
        searching = true;
        arrayCounter = 0;

        String s = "";
        int val;

        for (int i = 0; i < 68; ++i) {
          val = byteArray[i];
          if (val < 16) {
            s += "0";
          }
          s += String(val, HEX);
        }

        s.toCharArray(charArray, 137);
      }
    }
  }
}
