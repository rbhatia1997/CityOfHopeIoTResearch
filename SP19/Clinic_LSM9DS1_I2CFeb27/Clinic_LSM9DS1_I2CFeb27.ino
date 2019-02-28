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

/************************************
 * SC Feb 15 -- Copy of most recent code -> trying to get multiple IMUs talking, implementing calibration data from WI matlab
 * SC Feb 17 -- added in functionality to control the sample frequency of the data 
 * WI Feb 18 -- recalibrated magnetometer, increases gryo scale to prevent clipping, added mahony filter
 * SC,MG Feb 20 -- added calibration method for accel and gyro 
 * SC,WI,MG Feb 21 -- testing out calibration method on all four IMUs
 * WI,SC,MG Feb 24 -- working on the calibration method 
 * SC Feb 27 -- changing the input so that the accel and gyro follows RHR (negating the y axis); mag follows RHR
 */

#include <Wire.h>
#include <SPI.h>
#include <SparkFunLSM9DS1.h>
#include "MadgwickAHRS.h"
#include "MahonyAHRS.h"
#include <EEPROM.h>

// define I2C clock and data pins
#define I2C_SCL 19
#define I2C_SDA 18

//status LED for debuggin 
#define STATUS_LED 13
//calibration button for the accelerometer and gyro
#define CALIB_BUTTON 32 

#define NUM_IMUS 4
const int calibMode = 0;
#define MAX_NUM_IMUS 8

#define SAMPLE_FREQ 1000 //sample frequency in hertz
//IF YOU CHANGE THIS FREQUENCY CHANGE IT IN THE MADGWICK LIBRARY
unsigned long prevTime = 0; //for time 

// Chip Select pin for each IMU
const int CS_pins[MAX_NUM_IMUS] = {27,26,25,24,0,0,0,0};

// Latest IMU Data
// stores float values (from int reading)
float MagData[MAX_NUM_IMUS][3]; //gauss
float AccelData[MAX_NUM_IMUS][3]; //g's
float GyroData[MAX_NUM_IMUS][3]; //deg/sec


// Calibration Offsets

int negYaxis = -1; //changes the axes to be RHR

// These acceleration offsets [g] will be subtracted from the 
// raw data to compensate for sensor bias
float accel_Offsets[MAX_NUM_IMUS][3] = 
    {   {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0}    };

// These gyroscope offsets [deg/s] will be subtracted from the 
// raw data to compensate for sensor bias
float gyro_Offsets[MAX_NUM_IMUS][3] = 
    {   {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0}    };

// These magnetometer offsets [Gauss] will be subtracted from 
// the raw data to compensate for sensor bias
const float mag_Offsets[MAX_NUM_IMUS][3] = 
    {   {0.125,   0.095,    0.079},
        {0.227,   0.233,    -0.188},
        {-0.023,  0.247,    0.125},
        {0.261,   0.138,    0.035},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0}    };

// These magnetometer scaling factors will be multiplied to 
// the raw data to compensate for sensor bias
const float mag_Scaling[MAX_NUM_IMUS][3] = 
    {   {2.424,   2.422,    2.600},
        {2.516,   2.485,    2.725},
        {2.488,   2.557,    2.599},
        {2.508,   2.462,    2.601},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0},
        {0.0,     0.0,      0.0}    };


//////////////////////////
// LSM9DS1 Library Init //
//////////////////////////

// Create IMU objects
LSM9DS1 imu0; LSM9DS1 imu1; LSM9DS1 imu2; LSM9DS1 imu3; LSM9DS1 imu4; LSM9DS1 imu5; LSM9DS1 imu6; LSM9DS1 imu7;
LSM9DS1 IMU_List[MAX_NUM_IMUS] = {imu0,imu1,imu2,imu3,imu4,imu5,imu6,imu7};

// Creat Madgwick filter objects
Madgwick mad0; Madgwick mad1; Madgwick mad2; Madgwick mad3; Madgwick mad4; Madgwick mad5; Madgwick mad6; Madgwick mad7;
Madgwick Mad_List[MAX_NUM_IMUS] = {mad0,mad1,mad2,mad3,mad4,mad5,mad6,mad7};

// Creat Mahony filter objects
Mahony mah0; Mahony mah1; Mahony mah2; Mahony mah3; Mahony mah4; Mahony mah5; Mahony mah6; Mahony mah7;
Mahony Mah_List[MAX_NUM_IMUS] = {mah0,mah1,mah2,mah3,mah4,mah5,mah6,mah7};

///////////////////////
// Example I2C Setup //
///////////////////////
// SDO_M and SDO_AG have external pullups on the breakout board.
// When SDO_M and SDO_AG are high the active adresses are 0x1E
// and 0x6B respectively. However, we only want to talk to
// the one IMU wich has SDO_M and SDO_AG pulled low externally

//if want to pull CS LOW
#define LSM9DS1_M	  0x1C // Would be 0x1E if SDO_M is HIGH
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
// #define DECLINATION -8.58 // Declination (degrees) in Boulder, CO.


//to be used for debugging
void blinkStatusLED(int mS)
{
  digitalWrite(STATUS_LED,HIGH);
  delay(mS);
  digitalWrite(STATUS_LED,LOW);
}

/****
 * setup()
 * -blinks
 * -assigns I2C pins
 * -sets the settings
 * -checks communication link for all IMUs
 */

void setup() 
{

    Serial.begin(115200);
    Serial.println("Starting setup...");

    
    pinMode(STATUS_LED,OUTPUT); //to be used for debugging
    pinMode(CALIB_BUTTON,INPUT);//used for calibration
    blinkStatusLED(500); //power check

    
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
      //set the frequency for calcution
      Mah_List[imu].begin(SAMPLE_FREQ);

      if (!IMU_List[imu].begin())
      {
              Serial.print("Failed to communicate with IMU #: ");
              Serial.println(imu);
              while (1);
      }

      digitalWrite(CS_pins[imu],HIGH);
      blinkStatusLED(1000);
    }

    //calibrate sensors
    Serial.println("Calibrating sensors... Press button to begin");
    delay(3000);
    calibration(calibMode);
           
}

    

void loop()
{
    
    if(micros() - prevTime > 1000000/SAMPLE_FREQ)
    {
      prevTime = micros();
      
    for( int imu = 0; imu < NUM_IMUS; imu++){
        
        //pull CS line low for specific IMU
        digitalWrite(CS_pins[imu],LOW);
        
        //update values for IMU
        
        if (IMU_List[imu].accelAvailable())
        {
          IMU_List[imu].readAccel();
        }
        
        if (IMU_List[imu].gyroAvailable())
        {
          IMU_List[imu].readGyro();
        }
        
        if (IMU_List[imu].magAvailable())
        {
          IMU_List[imu].readMag();
        }

        //calculate float meaningful values
        //calibrate with offset values
        MagData[imu][0] = (IMU_List[imu].calcMag(IMU_List[imu].mx) - mag_Offsets[imu][0]) * mag_Scaling[imu][0];
        MagData[imu][1] = ((IMU_List[imu].calcMag(IMU_List[imu].my) - mag_Offsets[imu][1]) * mag_Scaling[imu][1]);
        MagData[imu][2] = (IMU_List[imu].calcMag(IMU_List[imu].mz) - mag_Offsets[imu][2]) * mag_Scaling[imu][2];

        AccelData[imu][0] = IMU_List[imu].calcAccel(IMU_List[imu].ax) - accel_Offsets[imu][0];
        AccelData[imu][1] = negYaxis * (IMU_List[imu].calcAccel(IMU_List[imu].ay) - accel_Offsets[imu][1]);
        AccelData[imu][2] = IMU_List[imu].calcAccel(IMU_List[imu].az) - accel_Offsets[imu][2];

        GyroData[imu][0] = IMU_List[imu].calcGyro(IMU_List[imu].gx) - gyro_Offsets[imu][0];
        GyroData[imu][1] = negYaxis * (IMU_List[imu].calcGyro(IMU_List[imu].gy) - gyro_Offsets[imu][1]);
        GyroData[imu][2] = IMU_List[imu].calcGyro(IMU_List[imu].gz) - gyro_Offsets[imu][2];

//        //debugging -- print data before the filter 
//        Serial.print(MagData[imu][0]);
//        Serial.print(" ");
//        Serial.print(AccelData[imu][0]);
//        Serial.print(" ");
//        Serial.println(GyroData[imu][0]);
////
//        Serial.print(IMU_List[imu].mx);
//        Serial.print(" ");
//        Serial.print(IMU_List[imu].gx);
//        Serial.print(" ");
//        Serial.println(IMU_List[imu].ax);
//
//        Serial.print("IMU: ");
//        Serial.print(imu);
//        Serial.print("\t");
//
//        Serial.print(MagData[imu][0]);
//        Serial.print(" ");
//        Serial.print(MagData[imu][1]);
//        Serial.print(" ");
//        Serial.println(MagData[imu][2]);
//
//        Serial.println(MagData[imu][0]*MagData[imu][0]+MagData[imu][1]*MagData[imu][1]+MagData[imu][2]*MagData[imu][2]);
//
//        Serial.print(AccelData[imu][0]);
//        Serial.print(" ");
//        Serial.print(AccelData[imu][1]);
//        Serial.print(" ");
//        Serial.println(AccelData[imu][2]);
//
//        Serial.print(GyroData[imu][0]);
//        Serial.print(" ");
//        Serial.print(GyroData[imu][1]);
//        Serial.print(" ");
//        Serial.println(GyroData[imu][2]);


//        Serial.print((IMU_List[0].calcMag(IMU_List[0].mx)));
//        Serial.print("\t");
//        Serial.print((IMU_List[0].calcMag(IMU_List[0].my)));
//        Serial.print("\t");
//        Serial.println((IMU_List[0].calcMag(IMU_List[0].mz)));

//        Serial.print((IMU_List[imu].calcAccel(IMU_List[imu].ax)));
//        Serial.print("\t");
//        Serial.print((IMU_List[imu].calcAccel(IMU_List[imu].ay)));
//        Serial.print("\t");
//        Serial.println((IMU_List[imu].calcAccel(IMU_List[imu].az)));
//        


        //Pass inputs to filter
          //use updateIMU if don't have Mag data
        Mad_List[imu].update(GyroData[imu][0],GyroData[imu][1],GyroData[imu][2],AccelData[imu][0],AccelData[imu][1],AccelData[imu][2],MagData[imu][0],MagData[imu][1],MagData[imu][2]);
//        Mad_List[imu].updateIMU(GyroData[1][0],GyroData[1][1],GyroData[1][2],AccelData[1][0],AccelData[1][1],AccelData[1][2]);

        Mah_List[imu].update(GyroData[imu][0],GyroData[imu][1],GyroData[imu][2],AccelData[imu][0],AccelData[imu][1],AccelData[imu][2],MagData[imu][0],MagData[imu][1],MagData[imu][2]);
//        Mah_List[imu].updateIMU(GyroData[1][0],GyroData[1][1],GyroData[1][2],AccelData[1][0],AccelData[1][1],AccelData[1][2]);


/////////////////////////////////////////////////////////////////////
//         Print  Madgwick Filter
/////////////////////////////////////////////////////////////////////
////          Serial.print("Roll (deg): ");
//            Serial.print(Mad_List[imu].getRoll());
////          Serial.print(" Pitch (deg): ");
//            Serial.print("\t");
//            Serial.print(Mad_List[imu].getPitch());
////          Serial.print(" Yaw (deg): ");
//            Serial.print("\t");
//            Serial.print(Mad_List[imu].getYaw());
//            Serial.println("\t");
            
/////////////////////////////////////////////////////////////////////
//          Print  Mahony Filter
/////////////////////////////////////////////////////////////////////
//          Serial.print("Roll (deg): ");
            Serial.print(Mah_List[imu].getRoll());
//          Serial.print(" Pitch (deg): ");
            Serial.print("\t");
            Serial.print(Mah_List[imu].getPitch());
//          Serial.print(" Yaw (deg): ");
            Serial.print("\t");
            Serial.print(Mah_List[imu].getYaw());
            Serial.println("\t");

              //print statements for processing formatting  
//            for(int i = 0; i < 6; i++) {
//              Serial.print("0");
//              Serial.print("\t");
//            }
//            Serial.println();

            digitalWrite(CS_pins[imu],HIGH);

    } 
  }
}   
/*
 * MG Feb 20, 2019
 * SC FEb 24, 2019
 * 
 * Inputs: int mode --  which calibration mode to use
 * Outputs: NONE
 * Functionality: 
 *  simple calibration for accelerometer and gyro along each axis
 *  can also read/write offsets to the EEPROM so that it can be stored betweeen runs
 *  0 = use sparkfun calibration 
 *  1 = calculate new offsets (optional store)
 *  2 = use offsets from EEPROM
 * 
  */
void calibration(int mode){

    //initiallizing all of the variables
    float sumgyrox[NUM_IMUS];
    float sumgyroy[NUM_IMUS];
    float sumgyroz[NUM_IMUS];

    float sumAccelx[NUM_IMUS];
    float sumAccely[NUM_IMUS];
    float sumAccelz[NUM_IMUS];

    float avg_gyrox[NUM_IMUS];
    float avg_gyroy[NUM_IMUS];
    float avg_gyroz[NUM_IMUS];
    float avg_accelz[NUM_IMUS];
    float avg_accelx[NUM_IMUS];
    float avg_accely[NUM_IMUS];
   

    //Sparkfun calibration 
    if (mode == 0){
       for( int imu = 0; imu < NUM_IMUS; imu++){
          IMU_List[imu].calibrate(true);
          
        }
    }

  if (mode == 1) {
    while(true) { if(digitalRead(CALIB_BUTTON)) break; }
    
      Serial.println("Lay sensor flat");
      delay(500);
  
      for(int imu = 0; imu < NUM_IMUS; imu++){
        digitalWrite(CS_pins[imu],LOW);
        for( int i = 0; i< 32; i++){
          IMU_List[imu].readAccel();
          IMU_List[imu].readGyro();
           //finding the sum of all the gyro offsets while the sensor is laying flat
          sumgyrox[imu] += IMU_List[imu].calcGyro(IMU_List[imu].gx);
          sumgyroy[imu] += IMU_List[imu].calcGyro(IMU_List[imu].gy);
          sumgyroz[imu] += IMU_List[imu].calcGyro(IMU_List[imu].gz);
          sumAccelz[imu] += IMU_List[imu].calcAccel(IMU_List[imu].az);
        }
        digitalWrite(CS_pins[imu],HIGH);
    
        avg_gyrox[imu] = sumgyrox[imu]/32;
        avg_gyroy[imu] = sumgyroy[imu]/32;
        avg_gyroz[imu] = sumgyroz[imu]/32;
        avg_accelz[imu] = sumAccelz[imu]/32;
      }
      
      Serial.println("Ready for y axis. Rotate to negative 90deg around X");
          
      while(true) { if(digitalRead(CALIB_BUTTON)) break; }
         
          Serial.println("Checking y axis");
          delay(500);

          for(int imu = 0; imu < NUM_IMUS; imu++){
            digitalWrite(CS_pins[imu],LOW);
            
            for( int j = 0; j<32; j++){
              IMU_List[imu].readAccel();
              sumAccely[imu] += IMU_List[imu].calcAccel(IMU_List[imu].ay);
            }
            digitalWrite(CS_pins[imu],HIGH);
            avg_accely[imu] = sumAccely[imu]/32;
          
          }
  
  
         Serial.println("Ready for x axis. Rotate to positive 90deg around Y");
        
         while(true) { if(digitalRead(CALIB_BUTTON)) break; }
            
            Serial.println("Checking y axis");
            delay(500);

            for(int imu = 0; imu < NUM_IMUS; imu++){
              digitalWrite(CS_pins[imu],LOW);
              
            for(int k = 0 ; k < 32 ; k++){
              IMU_List[imu].readAccel();
              sumAccelx[imu] += IMU_List[imu].calcAccel(IMU_List[imu].ax);
            }
            avg_accelx[imu] = sumAccelx[imu]/32;
            digitalWrite(CS_pins[imu],HIGH);
            }
        
        for(int imu = 0; imu < NUM_IMUS; imu++){
          accel_Offsets[imu][0] = (1 - avg_accelx[imu]); 
          accel_Offsets[imu][1] = (1 - avg_accely[imu]); 
          accel_Offsets[imu][2] = (1 - avg_accelz[imu]);
        
          gyro_Offsets[imu][0] = (0 - avg_gyrox[imu]);
          gyro_Offsets[imu][1] = (0 - avg_gyroy[imu]);
          gyro_Offsets[imu][2] = (0 - avg_gyroz[imu]);
        
        
          //print offsets
          Serial.print("AccelOffsets: ");
          for(int i  = 0; i < 3; i++)
          {
            Serial.print(accel_Offsets[imu][i]);
            Serial.print(" ");
          }
        
          Serial.println("");
          
          Serial.print("GyroOffsets: ");
          for(int i  = 0; i < 3; i++)
          {
            Serial.print(gyro_Offsets[imu][i]);
            Serial.print(" ");
          }
        
          Serial.println("");
        }


        //store offsets in the EEPROM
        Serial.println("Press button in the next 5 seconds if you want to save values");
        
        int current_time = millis();
        int EEPROM_index = 0; //address in the EEPROM
        
        while(millis()-current_time < 7000) { 
          if(digitalRead(CALIB_BUTTON)){
            // store calibration in EEPROM
            for(int imu = 0; imu < NUM_IMUS; imu++){
                EEPROM.put(EEPROM_index,accel_Offsets[imu][0]); //ax
                EEPROM.put(EEPROM_index + 4,accel_Offsets[imu][1]); //ay
                EEPROM.put(EEPROM_index + 8,accel_Offsets[imu][2]); //az
  
                EEPROM.put(EEPROM_index + 12,gyro_Offsets[imu][0]); //gx
                EEPROM.put(EEPROM_index + 16,gyro_Offsets[imu][1]); //gy
                EEPROM.put(EEPROM_index + 20,gyro_Offsets[imu][2]); //gz
                EEPROM_index += 24; //increase counter to next available address
  
  
  ////                //testing the store and get function 
  //               EEPROM.put(EEPROM_index,1.0 * imu); //ax
  //              EEPROM.put(EEPROM_index + 4,3.0 * imu); //ay
  //              EEPROM.put(EEPROM_index + 8,5.0 * imu); //az
  //
  //              EEPROM.put(EEPROM_index + 12,2.0 * imu); //gx
  //              EEPROM.put(EEPROM_index + 16,4.0 * imu); //gy
  //              EEPROM.put(EEPROM_index + 20,6.0 * imu); //gz
  //              EEPROM_index += 24;
  
             
            }
            Serial.println("Offsets stored");

            break; 
          }
          
        }

    }

    //load offsets from EEPROM
    if (mode == 2){
      Serial.println("Getting offsets from EEPROM");
      
      int EEPROM_index = 0; //address in the EEPROM
      for(int imu = 0; imu < NUM_IMUS; imu++)
      {
        EEPROM.get(EEPROM_index, accel_Offsets[imu][0]); //ax
        EEPROM.get(EEPROM_index + 4, accel_Offsets[imu][1]); //ay
        EEPROM.get(EEPROM_index + 8, accel_Offsets[imu][2]); //az

        EEPROM.get(EEPROM_index + 12, gyro_Offsets[imu][0]); //gx
        EEPROM.get(EEPROM_index + 16, gyro_Offsets[imu][1]); //gy
        EEPROM.get(EEPROM_index + 20, gyro_Offsets[imu][2]); //gz
        EEPROM_index += 24;  //increase counter to next available address

     //print offsets so that we can easily see it
      Serial.print("AccelOffsets: ");
        for(int i  = 0; i < 3; i++)
        {
          Serial.print(accel_Offsets[imu][i]);
          Serial.print(" ");
        }
      
        Serial.println("");
        
        Serial.print("GyroOffsets: ");
        for(int i  = 0; i < 3; i++)
        {
          Serial.print(gyro_Offsets[imu][i]);
          Serial.print(" ");
        }
      
        Serial.println("");
      }
    }
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
        IMU_List[imu].settings.gyro.scale = 500;
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
        IMU_List[imu].settings.mag.scale = 4;
        // 0 = 0.625, 1 = 1.25, 2 = 2.5, 3 = 5, 4 = 10, 5 = 20, 6 = 40, 7 = 80 [Hz]
        IMU_List[imu].settings.mag.sampleRate = 7;
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
 
