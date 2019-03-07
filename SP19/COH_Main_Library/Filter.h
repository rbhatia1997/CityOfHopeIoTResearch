#ifndef __FILTER_h__
#define __FILTER_h__

#include "MadgwickAHRS_Mod.h"
#include "MahonyAHRS_Mod.h"
#include "Sensor.h"

class Filter
{
public:
    // contructor: takes number of connected filters and sample frequency as input
    Filter(int num_filters, float sample_frequency);

    void init(void);

    void update(Sensor& linked_sensor);

    // print roll, pitch, and yaw in various frames
    String print_rpy_intertial_imu(int filter);
    String print_rpy_body_imu(int filter);
    String print_rpy_inertial_body(void);

    // Arrays that hold orientation data for each imu
    // Example: q_inertial_imu holds the quaternions that describe the transformation 
    // from the inertial frame to the imu frame
    float rpy_inertial_imu[8][3];
    float rpy_body_imu[8][3];
    float rpy_inertial_body[3];
    float q_inertial_imu[8][4];
    float q_body_imu[8][4];
    float q_inertial_body[4];


private:

    void q_to_rpy(float *q, float *rpy);

    void convert_to_body(void);

    //////////////////////////////////////////////////////
    // Add other functions
    //////////////////////////////////////////////////////


    float SAMPLE_FREQUENCY;
    int NUM_FILTERS;

    // Filter parameters
    float KP = 1000; // mahony
    float KI = 2;
    float beta = 0.001; // madgwick
    
    // Creat Mahony filter objects
    Mahony mahony0, mahony1, mahony2, mahony3, mahony4, mahony5, mahony6, mahony7;        // MIGHT NEED TO PUT Mahony IN FRONT OF EACH
    Mahony mahony_list[8] = {mahony0, mahony1, mahony2, mahony3, mahony4, mahony5, mahony6, mahony7};

    // Creat Madgwick filter objects
    Madgwick madgwick0, madgwick1, madgwick2, madgwick3, madgwick4, madgwick5, madgwick6, madgwick7;        // MIGHT NEED TO PUT Madgwick IN FRONT OF EACH
    Madgwick madgwick_list[8] = {madgwick0,madgwick1,madgwick2,madgwick3,madgwick4,madgwick5,madgwick6,madgwick7};

    //Sensor sensor;

};
#endif