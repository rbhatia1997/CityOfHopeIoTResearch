  #ifndef __SENSOR_h__
#define __SENSOR_h__

#include "Pinouts.h"
#include "Calibrations.h"
#include <SparkFunLSM9DS1.h>
#include <Wire.h>

// define I2C addresses for a/g and m
// CS is connected to SDO_M and SDO_AG. We want an imu to be active if CS is pulled low
#define LSM9DS1_M   0x1C // Address chanhes to 0x1E when SDO_M is HIGH
#define LSM9DS1_AG	0x6A // Address chanhes to 0x6B when SDO_AG is HIGH

typedef struct {
    float accel_data[MAX_NUM_SENSORS][3];
    float gyro_data[MAX_NUM_SENSORS][3];
    float mag_data[MAX_NUM_SENSORS][3];
} sensor_state_t;


class Sensor
{
public:
    // contructor: takes number of connected imus as input
    Sensor(int num_imus);

    // initializes I2C bus and configures imu settings
    void init(void);

    // reads and calibrates data from all the imus
    void read_sensors(void);

    // custom accelerometer/gyroscope calibration routine
    void calibrate_ag(bool stop_after);

    // custom magnetometer calibration
    void calibrate_m(bool stop_after);

    // print space-delimited calibrated data from one imu
    String print_accel(int imu);
    String print_gyro(int imu);
    String print_mag(int imu);

    // print space-delimited raw data from one imu
    String print_accel_raw(int imu);
    String print_gyro_raw(int imu);
    String print_mag_raw(int imu);

    // print a, g, or m offsets calculated using calibrate_ag or calibrate_m
    String print_a_cal_offsets(int imu);
    String print_g_cal_offsets(int imu);
    String print_m_cal_offsets(int imu);
    String print_m_cal_scaling(int imu);

    // arrays that hold raw data for each imu
    float accel_data_raw[MAX_NUM_SENSORS][3];
    float gyro_data_raw[MAX_NUM_SENSORS][3];
    float mag_data_raw[MAX_NUM_SENSORS][3];

    // list of imu objects
    LSM9DS1 imu0, imu1, imu2, imu3;
    LSM9DS1 imu_list[MAX_NUM_SENSORS] = {imu0,imu1,imu2,imu3};

    sensor_state_t sensor_state;

private:

    void get_data(void);

    void apply_calibrations(void);

    void config_imu_settings(int imu);

    // number of connected imus
    int NUM_IMUS;
    // list of chip select pins
    int CS_pins[MAX_NUM_SENSORS] = {CS0_PIN, CS1_PIN, CS2_PIN, CS3_PIN};

    // custom calibration offsets calculated using calibrate_ag and calibrate_m
    float custom_a_offsets[MAX_NUM_SENSORS][3];
    float custom_g_offsets[MAX_NUM_SENSORS][3];
    float custom_m_offsets[MAX_NUM_SENSORS][3];
    float custom_m_scaling[MAX_NUM_SENSORS][3];

};
#endif
