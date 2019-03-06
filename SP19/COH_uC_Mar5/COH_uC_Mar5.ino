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


#define NUM_SENSORS 4

const float SAMPLE_FREQ = 1000; // sample frequency in hertz
unsigned long prevTime = 0;

// Instantiate objects
Sensor sensor;
Filter filter = Filter(NUM_SENSORS,SAMPLE_FREQ,sensor);
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
    // sensor.calibrate_ag(false);
    // for(int imu = 0; imu < NUM_SENSORS; imu++){
    //     Serial.println(print_a_cal_offsets(imu));
    //     Serial.println(print_g_cal_offsets(imu));
    // }
           
}

    
void loop(){
    if(micros() - prevTime > 1000000.0/SAMPLE_FREQ){
        prevTime = micros();
        sensor.read_sensors();
        filter.update();
        for(int imu = 0; imu < NUM_SENSORS; imu++){
            Serial.println(filter.print_rpy_intertial_imu(imu));
        }

    }

}

      

