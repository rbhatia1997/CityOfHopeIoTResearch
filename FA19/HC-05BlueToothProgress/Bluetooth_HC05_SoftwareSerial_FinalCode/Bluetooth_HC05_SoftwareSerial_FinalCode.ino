/*
  Software serial multple serial test

  Receives from the hardware serial, sends to software serial.
  Receives from software serial, sends to hardware serial.

  The circuit:
   RX is digital pin 5 (connect to TX of other device)
   TX is digital pin 4 (connect to RX of other device)

  Note:
  Not all pins on the Mega and Mega 2560 support change interrupts,
  so only the following can be used for RX:
  10, 11, 12, 13, 50, 51, 52, 53, 62, 63, 64, 65, 66, 67, 68, 69

  Not all pins on the Leonardo and Micro support change interrupts,
  so only the following can be used for RX:
  8, 9, 10, 11, 14 (MISO), 15 (SCK), 16 (MOSI).

  created back in the mists of time
  modified 25 May 2012
  by Tom Igoe
  based on Mikal Hart's example

  This example code is in the public domain.

*/
#include <SoftwareSerial.h>

SoftwareSerial mySerial(5, 4); // RX, TX
char data = '0';                //Variable for storing received data

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  pinMode(2, OUTPUT);        //Sets digital pin 2 as output pin
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  // set the data rate for the SoftwareSerial port
  mySerial.begin(38400); // THIS IS IMPORTANT FOR BAUD RATE!!!
}

  void loop()
  {
    if (mySerial.available() > 0) // Send data only when you receive data:
    {
      data = mySerial.read();      //Read the incoming data and store it into variable data
      mySerial.print(data);        //Print Value inside data in Serial monitor
      mySerial.print("\n");        //New line
      if (data == '1') {          //Checks whether value of data is equal to 1
        digitalWrite(2, HIGH);  //If value is 1 then LED turns ON
        mySerial.print("Light's on!");
      }
      else if (data == '0') {      //Checks whether value of data is equal to 0
        digitalWrite(2, LOW);   //If value is 0 then LED turns OFF
        mySerial.print("Light's off!");
      }
    }
  }
