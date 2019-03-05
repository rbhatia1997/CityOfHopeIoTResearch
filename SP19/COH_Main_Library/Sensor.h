#ifndef __SENSOR_h__
#define __SENSOR_h__

#include "Pinouts.h"
#include <SparkFunLSM9DS1.h>
#include <Wire.h>
//#include "Filter.h"

// define I2C addresses for a/g and m
// CS is connected to SDO_M and SDO_AG. We want an imu to be active if CS is pulled low 
#define LSM9DS1_M   0x1C // Address chanhes to 0x1E when SDO_M is HIGH
#define LSM9DS1_AG	0x6A // Address chanhes to 0x6B when SDO_AG is HIGH

class Sensor
{
public:
    // contructor: takes number of connected imus as input
    Sensor(num_imus);

    // configures all connected imus
    void init(void);

    // reads data from sensors
    void read_sensors(void);

    // custom calibration routine
    void cal_ag(bool stop_after);

    // custom magnetometer calibration
    void cal_m(bool stop_after);

    // print space-delimited calibrated data from one imu
    String print_accel(int imu);
    String print_gyro(int imu);
    String print_mag(int imu);

    // print space-delimited raw data from one imu
    String print_accel_raw(int imu);
    String print_gyro_raw(int imu);
    String print_mag_raw(int imu);


    // arrays that hold calibrated data for each imu
    float accel_data[NUM_IMUS][3];
    float gyro_data[NUM_IMUS][3];
    float mag_data[NUM_IMUS][3];

    // arrays that hold raw data for each imu
    float accel_data_raw[NUM_IMUS][3];
    float gyro_data_raw[NUM_IMUS][3];
    float mag_data_raw[NUM_IMUS][3];


private:

    void get_data(void);

    void apply_calibrations(void);

    void config_imu_settings(int imu);

    // number of connected imus
    int NUM_IMUS;
    // list of chip select pins
    int CS_pins[8] = {CS0_PIN, CS1_PIN, CS2_PIN, CS3_PIN, CS4_PIN, CS5_PIN, CS6_PIN, CS7_PIN};

    // list of imu objects
    LSM9DS1 imu0, imu1, imu2, imu3, imu4, imu5, imu6, imu7;             // MIGHT NEED TO PUT LSM9DS1 IN FRONT OF EACH
    LSM9DS1 imu_list[8] = {imu0,imu1,imu2,imu3,imu4,imu5,imu6,imu7};



};
#endif