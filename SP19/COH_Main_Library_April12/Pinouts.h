#ifndef __PINOUTS_H__
#define __PINOUTS_H__

// This header file keeps track of all the harware pin connections

#define MAX_NUM_SENSORS 4

// I2C pins
#define I2C_SCL_PIN  19
#define I2C_SDA_PIN  18
#define CS0_PIN 17
#define CS1_PIN 16
#define CS2_PIN 15
#define CS3_PIN 14

//status LED for debugging
#define STATUS_LED_PIN 13

//calibration button for the accelerometer and gyro
#define CALIB_BUTTON_PIN 32

#endif
