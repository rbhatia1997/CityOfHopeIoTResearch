// Code adapated by Darien Joso, Ronak Bhatia, and Ewan Dlmss
// Code found originally online

// Before starting, one may consider running the Bluetooth HC-05 Module in AT mode.
// AT mode is accomplished by holding the button on the HC-05 and then powering the Arduino
// Then, upload an empty sketch. Before uploading though, see the note below!!
// Make sure that the TX pin of the HC-05 is connecting to the Arduino's RX pin and vice versa.

// Additionally, make sure that before uploading a sketch, you disconnect the RX/TX pins of the Arduino
// Plug them back in immediately after the code compiles on the board.

// This code should work with the BlueToothTerminalHC05 App on Android phones.

char data = '0';                //Variable for storing received data
void setup()
{
  Serial.begin(38400);         //Sets the data rate in bits per second (baud) for serial data transmission
  pinMode(2, OUTPUT);        //Sets digital pin 13 as output pin
}
void loop()
{
  if (Serial.available() > 0) // Send data only when you receive data:
  {
    data = Serial.read();      //Read the incoming data and store it into variable data
    Serial.print(data);        //Print Value inside data in Serial monitor
    Serial.print("\n");        //New line
    if (data == '1') {          //Checks whether value of data is equal to 1
      digitalWrite(2, HIGH);  //If value is 1 then LED turns ON
      Serial.print("Light's on!");
    }
    else if (data == '0') {      //Checks whether value of data is equal to 0
      digitalWrite(2, LOW);   //If value is 0 then LED turns OFF
      Serial.print("Light's off!");
    }
  }

}
