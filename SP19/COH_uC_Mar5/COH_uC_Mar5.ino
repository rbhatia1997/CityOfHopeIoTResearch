/*****************************************************************
COH AMT Clinic Team microcontroller code


 * SC Feb 15 -- Copy of most recent code -> trying to get multiple IMUs talking, implementing calibration data from WI matlab
 * SC Feb 17 -- added in functionality to control the sample frequency of the data 
 * WI Feb 18 -- recalibrated magnetometer, increases gryo scale to prevent clipping, added mahony filter
 * SC,MG Feb 20 -- added calibration method for accel and gyro 
 * SC,WI,MG Feb 21 -- testing out calibration method on all four IMUs
 * WI,SC,MG Feb 24 -- working on the calibration method 
 * SC Feb 27 -- changing the input so that the accel and gyro follows RHR (negating the y axis); mag follows RHR
 * SC Feb 28 -- negating the x axis of the accel and gyro to follow RHR and align with mag axis 
 */

#include <Arduino.h>
#include <Wire.h>
//#include <SPI.h>
#include "Filter.h"
#include "Sensor.h"
#include "Bluetooth.h"
#include "Led.h"
#include "Pinouts.h"


#define NUM_SENSORS 1

float SAMPLE_FREQ = 100; // sample frequency in hertz
unsigned long prevTime = 0;

// Instantiate objects
Sensor sensor;
Filter filter = Filter(NUM_SENSORS,SAMPLE_FREQ);
//Bluetooth bluetooth;
Led status_led = Led(STATUS_LED_PIN);

void setup() 
{
    // Open Serial Communication
    Serial.begin(115200);
    Serial.println("Starting setup...");

    // Initialize objects
    status_led.turn_on();
    sensor.init(NUM_SENSORS);
    status_led.turn_off();
    filter.init();
    //bluetooth.init();

    // Calibrate sensors
//     sensor.calibrate_ag(false);
//     for(int imu = 0; imu < NUM_SENSORS; imu++){
//         Serial.println(sensor.print_a_cal_offsets(imu));
//         Serial.println(sensor.print_g_cal_offsets(imu));
//     }
           
}

    
void loop(){
    if(micros() - prevTime > 1000000.0/SAMPLE_FREQ){
        prevTime = micros();
        sensor.read_sensors();
        filter.update(sensor.accel_data,sensor.gyro_data,sensor.mag_data);
        for(int imu = 0; imu < NUM_SENSORS; imu++){
            //Serial.println(filter.print_rpy_intertial_imu(imu));
            //Serial.println(sensor.print_accel_raw(imu));
            //Serial.println(sensor.print_gyro_raw(imu));
            //Serial.println(sensor.print_mag_raw(imu));
            //Serial.println(sensor.print_accel(imu));
            //Serial.println(sensor.print_gyro(imu));
            //Serial.println(sensor.print_mag(imu));
            Serial.println(filter.print_q_inertial_imu(imu));
        }

    }

// For testing sample frequency

//    delay(1000);
//    int numSamples = 500;
//    long t1;
//    long t2;
//    t1 = micros();
//    for(int i = 0; i<numSamples; i++){
//      sensor.read_sensors();
//      filter.update(sensor.accel_data,sensor.gyro_data,sensor.mag_data);
//    }
//    t2 = micros();
//    float f = 1000000*numSamples/(t2-t1);
//    Serial.print("Sample Frequency: ");
//    Serial.println(f);
//    delay(1000);

}

      

