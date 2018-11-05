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

// an MPU9250 object with the MPU-9250 sensor on SPI bus 0 and chip select pin 10
MPU9250 IMU1(SPI,10);
MPU9250 IMU2(SPI,2);

int status1;
int status2;

void setup() {
  // serial to display data
  Serial.begin(115200);
  while(!Serial) {}

  // start communication with IMU 
  status1 = IMU1.begin();
  if (status1 < 0) {
    Serial.println("IMU initialization unsuccessful");
    Serial.println("Check IMU1 wiring or try cycling power");
    Serial.print("Status 1: ");
    Serial.println(status1);
    while(1) {}
  }

  status2 = IMU2.begin();
  if (status2 < 0) {
    Serial.println("IMU initialization unsuccessful");
    Serial.println("Check IMU1 wiring or try cycling power");
    Serial.print("Status 2: ");
    Serial.println(status2);
    while(1) {}
  }
}

void loop() {
  IMU1.readSensor();
  IMU2.readSensor();

  double gyrox1 = IMU1.getGyroX_rads();
  double gyroy1 = IMU1.getGyroY_rads();
  double gyroz1 = IMU1.getGyroZ_rads();
  
  double gyrox2 = IMU2.getGyroX_rads();
  double gyroy2 = IMU2.getGyroY_rads();
  double gyroz2 = IMU2.getGyroZ_rads();

  Serial.println(gyrox1);

//  Serial.print(IMU1.getGyroX_rads(),6);
//  Serial.print("\t");
//  Serial.print(IMU1.getGyroY_rads(),6);
//  Serial.print("\t");
//  Serial.print(IMU1.getGyroZ_rads(),6);
//  Serial.print("\t");
//  Serial.print(IMU2.getGyroX_rads(),6);
//  Serial.print("\t");
//  Serial.print(IMU2.getGyroY_rads(),6);
//  Serial.print("\t");
//  Serial.println(IMU2.getGyroZ_rads(),6);

//  delay(50);
}
