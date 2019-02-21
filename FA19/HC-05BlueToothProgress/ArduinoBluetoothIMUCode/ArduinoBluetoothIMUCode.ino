// Code adapated by Darien Joso, Ronak Bhatia, and Ewan Dlmss
// Code found originally online

// Before starting, one may consider running the Bluetooth HC-05 Module in AT mode.
// AT mode is accomplished by holding the button on the HC-05 and then powering the Arduino
// Then, upload an empty sketch. Before uploading though, see the note below!!
// Make sure that the TX pin of the HC-05 is connecting to the Arduino's RX pin and vice versa.

// Additionally, make sure that before uploading a sketch, you disconnect the RX/TX pins of the Arduino
// Plug them back in immediately after the code compiles on the board.

// This code should work with the BlueToothTerminalHC05 App on Android phones.

#include "MPU9250.h"
#include <math.h>

MPU9250 IMU1(SPI, 10);

int status1;
int status2;

double Omega1[3] = {0, 0, 0};
double Theta1[3] = {0, 0, 0};
double Accel1[3] = {0, 0, 0};

double Omega2[3] = {0, 0, 0};
double Theta2[3] = {0, 0, 0};

long newTime = 0;
long lastTime = 0;

const int factor = 1 ;

char data = '0';

void setup() {

  Serial.begin(38400);         //Sets the data rate in bits per second (baud) for serial data transmission
  pinMode(2, OUTPUT);        //Sets digital pin 13 as output pin
  while (!Serial) {}

  status1 = IMU1.begin();
  if (status1 < 0) {
    Serial.println("IMU initialization unsuccessful");
    Serial.println("Check IMU1 wiring or try cycling power");
    Serial.print("Status 1: ");
    Serial.println(status1);
    while (1) {}
  }

  void loop() {

    newTime = millis();
    IMU1.readSensor();

    Omega1[0] = IMU1.getGyroX_rads();
    Omega1[1] = IMU1.getGyroY_rads();
    Omega1[2] = IMU1.getGyroZ_rads();

    Accel1[0] = IMU1.getAccelX_mss();
    Accel1[1] = IMU1.getAccelY_mss();
    Accel1[2] = IMU1.getAccelZ_mss();

    double delta = (newTime - lastTime) / 1000.0;

    for (int i = 0; i < 3; i++) {
      Theta1[i] += Omega1[i] * delta;
    }

    if (Serial.available() > 0) // Send data only when you receive data:
    {
      data = Serial.read();      //Read the incoming data and store it into variable data
      Serial.print(data);        //Print Value inside data in Serial monitor
      Serial.print("\n");        //New line
      if (data == '1') {          //Checks whether value of data is equal to 1
        digitalWrite(2, HIGH);  //If value is 1 then LED turns ON
        Serial.print(Theta1[0] * factor, 6);
        Serial.print("\t");
        Serial.print(Theta1[1] * factor, 6);
        Serial.print("\t");
        Serial.print(Theta1[2] * factor, 6);
        Serial.print("\t");
        Serial.print("\n");
      }
      else if (data == '0') {      //Checks whether value of data is equal to 0
        digitalWrite(2, LOW);   //If value is 0 then LED turns OFF
        Serial.print("Light's off!");
      }
    }

    delay(100);
    lastTime = newTime;
  }
