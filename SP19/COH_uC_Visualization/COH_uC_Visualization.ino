/*****************************************************************
COH AMT Clinic Team microcontroller code for visualizing in matlab
*/

#include <Arduino.h>
#include <Wire.h>
#include "Filter.h"
#include "Sensor.h"
#include "Led.h"
#include "Pinouts.h"


#define NUM_SENSORS 1
float SAMPLE_FREQ = 100; // sample frequency [Hz]

#define READ_BUFFER 100
#define SAMPLES_REQUESTED 3000 // number of samples to report to matlab
#define NUM_BYTES_PER_SAMPLE 16 // size of each sample in bytes

// variables for data transmission

float q0,q1,q2,q3;
byte *Q0,*Q1,*Q2,*Q3;
byte message[NUM_BYTES_PER_SAMPLE*SAMPLES_REQUESTED];

unsigned long prevTime = 0;

// Instantiate objects
Sensor sensor;
Filter filter = Filter(NUM_SENSORS,SAMPLE_FREQ);
Led status_led = Led(STATUS_LED_PIN);

void setup() 
{
    // Open Serial Communication
    Serial.begin(115200);
    // Initialize objects
    status_led.turn_on();
    sensor.init(NUM_SENSORS);
    status_led.turn_off();
    filter.init();

    delay(2000); // Wait for Serial communication to stabalize     
}

    
void loop(){
    
    while(!Serial.available()){}// Wait for Matlab to send dummy byte
    delay(100);
    
    // collect quaternion data and put it into the message buffer
    int sample = 0;
    while(sample<SAMPLES_REQUESTED){
        if(micros() - prevTime > 1000000.0/SAMPLE_FREQ){
            prevTime = micros();
            // read data
            sensor.read_sensors();
            filter.update(sensor.accel_data,sensor.gyro_data,sensor.mag_data);
            // get prientation data from AHRS algorithm in quaternion form (4 IEEE 754 format floats)    
            q0 = filter.get_q0(0);
            q1 = filter.get_q1(0);
            q2 = filter.get_q2(0);
            q3 = filter.get_q3(0);
            // convert floats to bytes for serial transmission
            Q0 = (byte*) & q0;
            Q1 = (byte*) & q1;
            Q2 = (byte*) & q2;
            Q3 = (byte*) & q3;
            // place current data in message buffer
            message[NUM_BYTES_PER_SAMPLE*sample]    = Q0[0];
            message[NUM_BYTES_PER_SAMPLE*sample+1]  = Q0[1];
            message[NUM_BYTES_PER_SAMPLE*sample+2]  = Q0[2];
            message[NUM_BYTES_PER_SAMPLE*sample+3]  = Q0[3];
      
            message[NUM_BYTES_PER_SAMPLE*sample+4]  = Q1[0];
            message[NUM_BYTES_PER_SAMPLE*sample+5]  = Q1[1];
            message[NUM_BYTES_PER_SAMPLE*sample+6]  = Q1[2];
            message[NUM_BYTES_PER_SAMPLE*sample+7]  = Q1[3];
      
            message[NUM_BYTES_PER_SAMPLE*sample+8]  = Q2[0];
            message[NUM_BYTES_PER_SAMPLE*sample+9]  = Q2[1];
            message[NUM_BYTES_PER_SAMPLE*sample+10] = Q2[2];
            message[NUM_BYTES_PER_SAMPLE*sample+11] = Q2[3];
      
            message[NUM_BYTES_PER_SAMPLE*sample+12] = Q3[0];
            message[NUM_BYTES_PER_SAMPLE*sample+13] = Q3[1];
            message[NUM_BYTES_PER_SAMPLE*sample+14] = Q3[2];
            message[NUM_BYTES_PER_SAMPLE*sample+15] = Q3[3];

            sample++;
        }
    }
    // write data to matlab
    Serial.write(message,sizeof(message));
}

      

