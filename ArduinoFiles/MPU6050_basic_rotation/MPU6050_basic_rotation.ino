#include <MPU6050_tockn.h>
#include <Wire.h>

MPU6050 mpu6050(Wire);

int avg_size = 7;

double z_yaw = 0;
double y_pitch = 0;
double x_roll = 0;

double x_avg = 0;
double y_avg = 0;
double z_avg = 0;

double x_avg_past = 0;
double y_avg_past = 0;
double z_avg_past = 0;

double x_offset = 0;
double y_offset = 0;
double z_offset = 0;

auto start_time = 0;

void setup() {
  
  Serial.begin(9600);
  Wire.begin();
  mpu6050.begin();
  mpu6050.calcGyroOffsets(true);
  start_time = millis();
}


void loop() {
  
  mpu6050.update();
  // Get data from IMU
  x_roll = mpu6050.getAngleX();
  y_pitch = mpu6050.getAngleY();
  z_yaw = mpu6050.getAngleZ();

  // Calculated offsets in the beginning, so t < 7s
  if (millis() - start_time < 7000) {
    
    // Calculate offsets
    x_offset = x_roll;
    y_offset = y_pitch;
    z_offset = z_yaw;

  }

  // Calculate the calibrated angles by subtracting the intial offsets
  x_roll = x_roll - x_offset;
  y_pitch = y_pitch - y_offset;
  z_yaw = z_yaw - z_offset;

  // Filter signal using moving average
  double x_avg = ( (avg_size - 1)*x_avg_past + x_roll) / avg_size;
  double y_avg = ( (avg_size - 1)*y_avg_past + y_pitch) / avg_size;
  double z_avg = ( (avg_size - 1)*z_avg_past + z_yaw) / avg_size;
  x_avg_past = x_avg;
  y_avg_past = y_avg;
  z_avg_past = z_avg;

  // Print the filtered, calibrated angles
  Serial.print(x_avg);
  Serial.print("\t");
  Serial.print(y_avg);
  Serial.print("\t");
  Serial.print(z_avg);
  Serial.print("\n");
  
}
