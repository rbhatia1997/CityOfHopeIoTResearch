#include "MPU9250.h"

MPU9250 mpu;

#define IMU1 10
#define IMU2 2

void setup()
{
    Serial.begin(115200);

    Wire.begin();

    delay(2000);
    mpu.setup();

    pinMode(IMU1, OUTPUT);
    pinMode(IMU2, OUTPUT);

    digitalWrite(IMU1, LOW);
    digitalWrite(IMU2, LOW);
}

void loop()
{
    static uint32_t prev_ms = millis();
    if ((millis() - prev_ms) > 16)
    {
        readIMU(IMU1);
//        readIMU(IMU2);
        Serial.print("\n");

//        delay(100);
        
        prev_ms = millis();
    }
}

void readIMU(int pin) {
  
  digitalWrite(pin, HIGH);

  delay(20);
        
  mpu.update();

  Serial.print(mpu.getRoll());
  Serial.print("\t");
  Serial.print(mpu.getPitch());
  Serial.print("\t");
  Serial.print(mpu.getYaw());
  Serial.print("\t");

  digitalWrite(pin, LOW);
  
}
