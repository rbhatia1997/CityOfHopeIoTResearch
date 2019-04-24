/* 
 *  Magnetometer calibration code
 *  
 *  This code should be uploaded to the Teensy before running Mag_Calibration.m in matlab.
 *  Since the Teensy will be communicationg serially with matlab, the serial monitor should 
 *  not be opened. Make sure to set the CS pin number and that BUFFER_SIZE matches
 *  numSamples in the matlab script.
 *  
 *  
 */

#include <Arduino.h>
#include <Wire.h>
#include <SPI.h>
#include <SparkFunLSM9DS1.h>

#define READ_BUFFER 100
#define BUFFER_SIZE 1000 // needs to match numSamples in matlab
#define NUM_BYTES_PER_SAMPLE 12 // size of each sample in bytes

// chip select pin
int CS_pin = 16;

// variables for data transmission
int read_index;
byte request[READ_BUFFER]; // stores revieved data from matlab
int request_size;
byte message[NUM_BYTES_PER_SAMPLE*BUFFER_SIZE];


float mmx,mmy,mmz;
byte *MX,*MY,*MZ;

// intitialize LSM303C object
LSM9DS1 imu;

// define I2C clock and data pins
#define I2C_SCL 19
#define I2C_SDA 18

// I2C Adresses
#define LSM9DS1_M  0x1C // Would be 0x1E if SDO_M is HIGH
#define LSM9DS1_AG  0x6A // Would be 0x6B if SDO_AG is HIGH


void setup() {
    pinMode(CS_pin,OUTPUT);
    digitalWrite(CS_pin,LOW);
    Serial.begin(115200);
    delay(1000);
    // set I2C pins
    Wire.setSCL(I2C_SCL);
    Wire.setSDA(I2C_SDA);
    imu.settings.device.commInterface = IMU_MODE_I2C;
    imu.settings.device.mAddress = LSM9DS1_M;
    imu.settings.device.agAddress = LSM9DS1_AG;
    imu.settings.mag.scale = 4;
    imu.settings.mag.sampleRate = 7;
    imu.settings.mag.XYPerformance = 3; // Ultra-high perform.
    imu.settings.mag.ZPerformance = 3; // Ultra-high perform.

    if (!imu.begin())
    {
        Serial.println("Failed to communicate with LSM9DS1.");
        Serial.println("Check Voltage at SDO_M and SDO_AG");
        while (1);
    }
}


void loop() {
    
    read_index = 0;
    request_size = 0;
    while(!Serial.available()){}// Wait for Matlab to request data
    while(Serial.available()){ // Read Matlab buffer size [bytes]
        // Bytes are recieved from lsd to msd. Each byte encodes a single base-10 digit
        request[read_index] = Serial.read(); // Expect an ASCII number null terminated
        read_index++;
    }
    for(int i=0; i<read_index; i++){
        // Convert request buffer to an integer value stored in 'request_size'
        request_size += 10^i*request[i];
    }

    for(int i=0; i<BUFFER_SIZE; i++){
        // get current data from IMU in IEEE 754 format floats  
        imu.readMag();    
        mmx = imu.calcMag(imu.mx);
        mmy = imu.calcMag(imu.my);
        mmz = imu.calcMag(imu.mz);
        
        // convert floats to bytes for serial transmission
        MX = (byte*) & mmx;
        MY = (byte*) & mmy;
        MZ = (byte*) & mmz;

        // place current data in message buffer
        message[NUM_BYTES_PER_SAMPLE*i]   = MX[0];
        message[NUM_BYTES_PER_SAMPLE*i+1] = MX[1];
        message[NUM_BYTES_PER_SAMPLE*i+2] = MX[2];
        message[NUM_BYTES_PER_SAMPLE*i+3] = MX[3];

        message[NUM_BYTES_PER_SAMPLE*i+4] = MY[0];
        message[NUM_BYTES_PER_SAMPLE*i+5] = MY[1];
        message[NUM_BYTES_PER_SAMPLE*i+6] = MY[2];
        message[NUM_BYTES_PER_SAMPLE*i+7] = MY[3];

        message[NUM_BYTES_PER_SAMPLE*i+8]  = MZ[0];
        message[NUM_BYTES_PER_SAMPLE*i+9]  = MZ[1];
        message[NUM_BYTES_PER_SAMPLE*i+10] = MZ[2];
        message[NUM_BYTES_PER_SAMPLE*i+11] = MZ[3];

        // this delay prevents repeat sampling
        delay(10); 
    }
    Serial.write(message,sizeof(message));
}

