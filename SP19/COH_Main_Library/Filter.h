#ifndef __FILTER_h__
#define __FILTER_h__

#include "MadgwickAHRS_Mod.h"
#include "MahonyAHRS_Mod.h"
#include "Sensor.h"
#include "Pinouts.h"


typedef struct {
    quat q_inertial_imu[MAX_NUM_SENSORS];
} filter_state_t;


class Filter
{
public:
    // contructor: takes number of connected filters and sample frequency as input
    Filter(int num_filters, float sample_frequency);

    // initializes each filter instance
    void init(void);

    // passes sensor data to mahony filter and saves rpy and quaternion outputs
    void update(sensor_state_t * sensor_state);

    // print roll, pitch, and yaw
    String print_rpy_intertial_imu(int filter);

    // print quaternions
    String print_q_inertial_imu(int filter);

    // arrays that hold roll pitch and yaw for each imu
    float rpy_inertial_imu[MAX_NUM_SENSORS][3];

    filter_state_t filter_state;


private:

    float SAMPLE_FREQUENCY;
    int NUM_FILTERS;

    // Filter parameters
    float KP = 10; // mahony
    float KI = 0.0;
    float beta = 0.001; // madgwick
    
    // Creat Mahony filter objects
    Mahony mahony0, mahony1, mahony2, mahony3;       
    Mahony mahony_list[MAX_NUM_SENSORS] = {mahony0, mahony1, mahony2, mahony3};

    // Creat Madgwick filter objects
    Madgwick madgwick0, madgwick1, madgwick2, madgwick3;
    Madgwick madgwick_list[MAX_NUM_SENSORS] = {madgwick0,madgwick1,madgwick2,madgwick3};

};
#endif