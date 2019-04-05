#ifndef __CALIBRATIONS_H__
#define __CALIBRATIONS_H__

// This header file holds all the acclerometer, magnetometer, and
// gyroscope offset vectors for each IMU. It also hold the magnetometer
// soft iron compensation matrices.

// The following arrays assume that the calibration data for no more
// than 8 IMUs will be stored at a time
const int array_length = 4;


// These acceleration offsets [g] will be subtracted from the
// raw data to compensate for sensor bias
const float accel_offsets[array_length][3] =
//      X           Y           Z
    {   {0.0,       0.0,        0.0},       // IMU 0
        {0.0,       0.0,        0.0},       // IMU 1
        {0.0,       0.0,        0.0},       // IMU 2
        {0.0,       0.0,        0.0}};      // IMU 3



// These gyroscope offsets [deg/s] will be subtracted from the
// raw data to compensate for sensor bias
const float gyro_offsets[array_length][3] =
//      X           Y           Z
{   {0.0,       0.0,        0.0},       // IMU 0
    {0.0,       0.0,        0.0},       // IMU 1
    {0.0,       0.0,        0.0},       // IMU 2
    {0.0,       0.0,        0.0}};      // IMU 3

// These magnetometer offsets [Gauss] will be subtracted from
// the raw data to compensate for sensor bias
const float mag_offsets[array_length][3] =
//      X           Y           Z
{   {0.146,       0.063,        -0.018},       // IMU 0
    {0.094,       0.306,        -0.066},       // IMU 1
    {0.150,       0.008,        0.023},       // IMU 2
    {-0.003,       0.155,        -0.018}};      // IMU 3

// These 3x3 magnetometer soft iron compensation matrices will
// be multiplied by the raw data after the hard iron offsets
// have been removed using the vectors above
const float mag_scaling[array_length][3][3] =
    {
        {   // IMU 0
            {2.355,     0.165,        -0.076},
            {0.0,       2.388,      0.069},
            {0.0,       0.0,        2.468}
        },
        {   // IMU 1
            {2.3,     0.174,        -0.027},
            {0.0,       2.333,      -0.002},
            {0.0,       0.0,        2.403}
        },
        {   // IMU 2
            {2.329,     0.167,        -0.043},
            {0.0,       2.361,      0.033},
            {0.0,       0.0,        2.377}
        },
        {   // IMU 3
            {2.379,     0.171,        0.047},
            {0.0,       2.373,      -0.002},
            {0.0,       0.0,        2.448}
          }
    };



#endif
