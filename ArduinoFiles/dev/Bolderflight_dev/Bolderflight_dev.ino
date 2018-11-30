/*
Basic_SPI.ino
Brian R Taylor
brian.taylor@bolderflight.com

Copyright (c) 2017 Bolder Flight Systems

Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
and associated documentation files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify, merge, publish, distribute, 
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or 
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "MPU9250.h"
#include <math.h>

MPU9250 IMU1(SPI,10);
MPU9250 IMU2(SPI,2);

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

void setup() {
  
  Serial.begin(38400);
  while(!Serial) {}
 
  status1 = IMU1.begin();
  if (status1 < 0) {
    Serial.println("IMU initialization unsuccessful");
    Serial.println("Check IMU1 wiring or try cycling power");
    Serial.print("Status 1: ");
    Serial.println(status1);
    while(1) {}
  }

//  status2 = IMU2.begin();
//  if (status2 < 0) {
//    Serial.println("IMU initialization unsuccessful");
//    Serial.println("Check IMU1 wiring or try cycling power");
//    Serial.print("Status 2: ");
//    Serial.println(status2);
//    while(1) {}
//  }
  
}

void loop() {

  newTime=millis();

  IMU1.readSensor();
//  IMU2.readSensor();

  Omega1[0] = IMU1.getGyroX_rads();
  Omega1[1] = IMU1.getGyroY_rads();
  Omega1[2] = IMU1.getGyroZ_rads();

  Accel1[0] = IMU1.getAccelX_mss();
  Accel1[1] = IMU1.getAccelY_mss();
  Accel1[2] = IMU1.getAccelZ_mss();

//  Omega2[0] = IMU2.getGyroX_rads();
//  Omega2[1] = IMU2.getGyroY_rads();
//  Omega2[2] = IMU2.getGyroZ_rads();

  double delta = (newTime - lastTime) / 1000.0;

  for (int i = 0; i < 3; i++){
    Theta1[i] += Omega1[i] * delta;
//    Theta2[i] += Omega2[i] * delta;

  }

  Serial.print(Omega1[0] * factor,6);
  Serial.print("\t");
  Serial.print(Omega1[1] * factor,6);
  Serial.print("\t");
  Serial.print(Omega1[2] * factor,6);
  Serial.print("\t");

  Serial.print(Accel1[0] * factor,6);
  Serial.print("\t");
  Serial.print(Accel1[1] * factor,6);
  Serial.print("\t");
  Serial.print(Accel1[2] * factor,6);
  Serial.print("\t");
  
//  Serial.print(Theta1[0] * factor,6);
//  Serial.print("\t");
//  Serial.print(Theta1[1] * factor,6);
//  Serial.print("\t");
//  Serial.print(Theta1[2] * factor,6);
//  Serial.print("\t");

//  Serial.print(Theta2[0] * factor,6);
//  Serial.print("\t");
//  Serial.print(Theta2[1] * factor,6);
//  Serial.print("\t");
//  Serial.print(Theta2[2] * factor,6);
//  Serial.print("\t");

  Serial.print("\n");

  delay(100);

  lastTime = newTime;
}
