/*****************************************************************
Clinic_LSM9DS1_I2C.ino

PINOUT
	LSM9DS1 --------- Arduino
	 SCL ---------- SCL (A5 on older 'Duinos')
	 SDA ---------- SDA (A4 on older 'Duinos')
	 VDD ------------- 3.3V
	 GND ------------- GND
(CSG, CSXM, SDOG, and SDOXM should all be pulled high. 
Jumpers on the breakout board will do this for you.)

************************************/

#include <Wire.h>
#include <SPI.h>
#include <SparkFunLSM9DS1.h>
#include "MadgwickAHRS.h"

// define I2C clock and data pins
#define I2C_SCL 19
#define I2C_SDA 18

//status LED for debuggin 
#define STATUS_LED 13

#define NUM_IMUS 1
#define MAX_NUM_IMUS 8

// Chip Select pin for each IMU
const int CS_pins[MAX_NUM_IMUS] = {24,2,3,0,0,0,0,0};

// Latest IMU Data
// stores float values (from int reading)
float MagData[MAX_NUM_IMUS][3]; //gauss
float AccelData[MAX_NUM_IMUS][3]; //g's
float GyroData[MAX_NUM_IMUS][3]; //deg/sec


// Calibration Offsets

// These acceleration offsets [g] will be subtracted from the 
// raw data to compensate for sensor bias
const float accel_Offsets[MAX_NUM_IMUS][3] = 
    {   {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0}    };

// These gyroscope offsets [deg/s] will be subtracted from the 
// raw data to compensate for sensor bias
const float gyro_Offsets[MAX_NUM_IMUS][3] = 
    {   {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0}    };

// These magnetometer offsets [Gauss] will be subtracted from 
// the raw data to compensate for sensor bias
const float mag_Offsets[MAX_NUM_IMUS][3] = 
    {   {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0}    };

// These magnetometer scaling factors will be multiplied to 
// the raw data to compensate for sensor bias
const float mag_Scaling[MAX_NUM_IMUS][3] = 
    {   {1.0,   1.0,    1.0},
        {1.0,   1.0,    1.0},
        {1.0,   1.0,    1.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0},
        {0.0,   0.0,    0.0}    };


//////////////////////////
// LSM9DS1 Library Init //
//////////////////////////

// Create IMU objects
LSM9DS1 imu0;
LSM9DS1 imu1;
LSM9DS1 imu2;
LSM9DS1 imu3;
LSM9DS1 imu4;
LSM9DS1 imu5;
LSM9DS1 imu6;
LSM9DS1 imu7;
LSM9DS1 IMU_List[MAX_NUM_IMUS] = {imu0,imu1,imu2,imu3,imu4,imu5,imu6,imu7};




Madgwick mad0;
Madgwick mad1;
Madgwick mad2;
Madgwick mad3;
Madgwick mad4;
Madgwick mad5;
Madgwick mad6;
Madgwick mad7;
Madgwick Mad_List[MAX_NUM_IMUS] = {mad0,mad1,mad2,mad3,mad4,mad5,mad6,mad7};

///////////////////////
// Example I2C Setup //
///////////////////////
// SDO_M and SDO_AG have external pullups on the breakout board.
// When SDO_M and SDO_AG are high the active adresses are 0x1E
// and 0x6B respectively. However, we only want to talk to
// the one IMU wich has SDO_M and SDO_AG pulled low externally

//if want to pull CS LOW
#define LSM9DS1_M	0x1C // Would be 0x1E if SDO_M is HIGH
#define LSM9DS1_AG	0x6A // Would be 0x6B if SDO_AG is HIGH

//if want to pull CS HIGH:
//#define LSM9DS1_M  0x1E // Would be 0x1C if SDO_M is LOW
//#define LSM9DS1_AG  0x6B // Would be 0x6A if SDO_AG is LOW

////////////////////////////
// Sketch Output Settings //
////////////////////////////
//** #define PRINT_CALCULATED
//#define PRINT_RAW
//** #define PRINT_SPEED 250 // 250 ms between prints
//** static unsigned long lastPrint = 0; // Keep track of print time

// Earth's magnetic field varies by location. Add or subtract 
// a declination to get a more accurate heading. Calculate 
// your's here:
// http://www.ngdc.noaa.gov/geomag-web/#declination
#define DECLINATION -8.58 // Declination (degrees) in Boulder, CO.


//to be used for debugging
void blinkStatusLED(int mS)
{
  digitalWrite(STATUS_LED,HIGH);
  delay(mS);
  digitalWrite(STATUS_LED,LOW);
}

void setup() 
{

    Serial.begin(115200);
    Serial.println("Starting setup...");

    
    pinMode(STATUS_LED,OUTPUT); //to be used for debugging
    blinkStatusLED(1000); //power check

    
    // set I2C pins
    Wire.setSCL(I2C_SCL);
    Wire.setSDA(I2C_SDA);

    for( int imu = 0; imu < NUM_IMUS; imu++){
      Serial.print("Checking IMU# :");
      Serial.println(imu);

      
        // Configure CS pin as output
        pinMode(CS_pins[imu],OUTPUT);
        digitalWrite(CS_pins[imu],LOW);

        //set the ODR, enable features, and set ranges
        IMUsettings(imu);

        if (!IMU_List[imu].begin())
        {
                Serial.print("Failed to communicate with IMU #: ");
                Serial.println(imu);
                while (1);
        }
        digitalWrite(CS_pins[imu],HIGH);
        blinkStatusLED(1000);
    }
}

void loop()
{
    for( int imu = 0; imu < NUM_IMUS; imu++){

        //pull CS line low for specific IMU
        digitalWrite(CS_pins[imu],LOW);
        
        //update values for IMU
        
          // imu.accelAvailable() returns 1 if new accelerometer
        // data is ready to be read. 0 otherwise.
        if (IMU_List[imu].accelAvailable())
        {
          IMU_List[imu].readAccel();
//          Serial.print("reading Accel ");
  //        Serial.println(IMU_List[imu].ax);
        }
        
        // imu.gyroAvailable() returns 1 if new gyroscope
        // data is ready to be read. 0 otherwise.
        if (IMU_List[imu].gyroAvailable())
        {
          IMU_List[imu].readGyro();
//          Serial.println("reading Gyro");
        }
        
        // imu.magAvailable() returns 1 if new magnetometer
        // data is ready to be read. 0 otherwise.
        if (IMU_List[imu].magAvailable())
        {
          IMU_List[imu].readMag();
//          Serial.println("reading Mag");
        }

        //calculate float meaningful values
        //calibrate with offset values
        MagData[imu][0] = (IMU_List[imu].calcMag(IMU_List[imu].mx) - mag_Offsets[imu][0]) * mag_Scaling[imu][0];
        MagData[imu][1] = (IMU_List[imu].calcMag(IMU_List[imu].my) - mag_Offsets[imu][1]) * mag_Scaling[imu][1];
        MagData[imu][2] = (IMU_List[imu].calcMag(IMU_List[imu].mz) - mag_Offsets[imu][2]) * mag_Scaling[imu][2];

        AccelData[imu][0] = IMU_List[imu].calcAccel(IMU_List[imu].ax) - accel_Offsets[imu][0];
        AccelData[imu][1] = IMU_List[imu].calcAccel(IMU_List[imu].ay) - accel_Offsets[imu][1];
        AccelData[imu][2] = IMU_List[imu].calcAccel(IMU_List[imu].az) - accel_Offsets[imu][2];

        GyroData[imu][0] = IMU_List[imu].calcGyro(IMU_List[imu].gx) - gyro_Offsets[imu][0];
        GyroData[imu][1] = IMU_List[imu].calcGyro(IMU_List[imu].gy) - gyro_Offsets[imu][1];
        GyroData[imu][2] = IMU_List[imu].calcGyro(IMU_List[imu].gz) - gyro_Offsets[imu][2];

        //debugging -- print data before the filter 
//        Serial.print(MagData[imu][0]);
//        Serial.print(" ");
//        Serial.print(AccelData[imu][0]);
//        Serial.print(" ");
//        Serial.println(GyroData[imu][0]);

//         Serial.print(IMU_List[imu].mx);
//        Serial.print(" ");
//        Serial.print(IMU_List[imu].gx);
//        Serial.print(" ");
//        Serial.println(IMU_List[imu].ax);
//        

        //get reading from Madgwick filter 
        Mad_List[imu].update(GyroData[imu][0],GyroData[imu][1],GyroData[imu][1],AccelData[imu][0],AccelData[imu][1],AccelData[imu][1],MagData[imu][0],MagData[imu][1],MagData[imu][1]);

          Serial.print("Roll (deg): ");
            Serial.print(Mad_List[imu].getRoll());
          Serial.print(" Pitch (deg): ");
            Serial.print(" ");
            Serial.print(Mad_List[imu].getPitch());
          Serial.print(" Yaw (deg): ");
            Serial.print(" ");
            Serial.println(Mad_List[imu].getYaw());

            digitalWrite(CS_pins[imu],HIGH);


    } 
    delay(100);
}   


/*
 * SC Feb 14,2019
 * Moved settings into this function down here
 * to improve readability
 * 
 */

void IMUsettings(int imu)
{
  IMU_List[imu].settings.device.commInterface = IMU_MODE_I2C;
        IMU_List[imu].settings.device.mAddress = LSM9DS1_M;
        IMU_List[imu].settings.device.agAddress = LSM9DS1_AG;

//         Gyro Initialization
        IMU_List[imu].settings.gyro.enabled = true;
        // scale can be set to either 245, 500, or 2000
        IMU_List[imu].settings.gyro.scale = 245;
        // 1 = 14.9, 2 = 59.5, 3 = 119, 4 = 238, 5 = 476, 6 = 952 [Hz]
        IMU_List[imu].settings.gyro.sampleRate = 3;
        // [bandwidth] can set the cutoff frequency of the gyro.
        // Allowed values: 0-3. Actual value of cutoff frequency
        // depends on the sample rate. (Datasheet section 7.12)
        IMU_List[imu].settings.gyro.bandwidth = 0;
        IMU_List[imu].settings.gyro.lowPowerEnable = false;
        IMU_List[imu].settings.gyro.HPFEnable = true; // HPF disabled
        // [HPFCutoff] sets the HPF cutoff frequency (if enabled)
        // Allowable values are 0-9. Value depends on ODR.
        // (Datasheet section 7.14)
        IMU_List[imu].settings.gyro.HPFCutoff = 1; // HPF cutoff = 4Hz
        IMU_List[imu].settings.gyro.flipX = false; // Don't flip X
        IMU_List[imu].settings.gyro.flipY = false; // Don't flip Y
        IMU_List[imu].settings.gyro.flipZ = false; // Don't flip Z

        // Accelerometer Initialization
        IMU_List[imu].settings.accel.enabled = true;
        IMU_List[imu].settings.accel.enableX = true; // Enable X
        IMU_List[imu].settings.accel.enableY = true; // Enable Y
        IMU_List[imu].settings.accel.enableZ = true; // Enable Z
        // accel scale can be 2, 4, 8, or 16 [g]
        IMU_List[imu].settings.accel.scale = 8;
        // 1 = 10, 2 = 50, 3 = 119, 4 = 238, 5 = 476, 6 = 952 [Hz]
        IMU_List[imu].settings.accel.sampleRate = 1; // Set accel to 10Hz.
        // [bandwidth] sets the anti-aliasing filter bandwidth.
        // Accel cutoff freqeuncy can be any value between -1 - 3. 
        // -1 = bandwidth determined by sample rate
        // 0 = 408 Hz   2 = 105 Hz
        // 1 = 211 Hz   3 = 50 Hz
        IMU_List[imu].settings.accel.bandwidth = 0; // BW = 408Hz
        // [highResEnable] enables or disables high resolution 
        // mode for the acclerometer.
        IMU_List[imu].settings.accel.highResEnable = false; // Disable HR
        // [highResBandwidth] sets the LP cutoff frequency of
        // the accelerometer if it's in high-res mode.
        // can be any value between 0-3
        // LP cutoff is set to a factor of sample rate
        // 0 = ODR/50    2 = ODR/9
        // 1 = ODR/100   3 = ODR/400
        IMU_List[imu].settings.accel.highResBandwidth = 0; 

        // Magnetometer Initialization
        // [enabled] turns the magnetometer on or off.
        IMU_List[imu].settings.mag.enabled = true; // Enable magnetometer
        // [scale] sets the full-scale range of the magnetometer
        // mag scale can be 4, 8, 12, or 16
        IMU_List[imu].settings.mag.scale = 12;
        // 0 = 0.625, 1 = 1.25, 2 = 2.5, 3 = 5, 4 = 10, 5 = 20, 6 = 40, 7 = 80 [Hz]
        IMU_List[imu].settings.mag.sampleRate = 5;
        // [tempCompensationEnable] enables or disables 
        // temperature compensation of the magnetometer.
        IMU_List[imu].settings.mag.tempCompensationEnable = false;
        // 0 = Low power mode      2 = high performance
        // 1 = medium performance  3 = ultra-high performance
        IMU_List[imu].settings.mag.XYPerformance = 3; // Ultra-high perform.
        IMU_List[imu].settings.mag.ZPerformance = 3; // Ultra-high perform.
        IMU_List[imu].settings.mag.lowPowerEnable = false;
        // 0 = continuous conversion
        // 1 = single-conversion
        // 2 = power down
        IMU_List[imu].settings.mag.operatingMode = 0; // Continuous mode
        IMU_List[imu].settings.temp.enabled = true;
}
 
