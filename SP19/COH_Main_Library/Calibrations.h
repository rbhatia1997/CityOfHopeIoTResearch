#ifndef __CALIBRATIONS_H__
#define __CALIBRATIONS_H__

// This header file holds all the acclerometer, magnetometer, and
// gyroscope offset vectors for each IMU. It also hold the magnetometer
// soft iron compensation matrices.

// The following arrays assume that the calibration data for no more 
// than 8 IMUs will be stored at a time
const int array_length = 8;


// These acceleration offsets [g] will be subtracted from the 
// raw data to compensate for sensor bias
const float accel_offsets[array_length][3] = 
//      X           Y           Z
    {   {0.0,       0.0,        0.0},       // IMU 0
        {0.0,       0.0,        0.0},       // IMU 1
        {0.0,       0.0,        0.0},       // IMU 2
        {0.0,       0.0,        0.0},       // IMU 3
        {0.0,       0.0,        0.0},       // IMU 4
        {0.0,       0.0,        0.0},       // IMU 5
        {0.0,       0.0,        0.0},       // IMU 6
        {0.0,       0.0,        0.0}};      // IMU 7

// These gyroscope offsets [deg/s] will be subtracted from the 
// raw data to compensate for sensor bias
const float gyro_offsets[array_length][3] = 
//      X           Y           Z
    {   {0.0,       0.0,        0.0},       // IMU 0
        {0.0,       0.0,        0.0},       // IMU 1
        {0.0,       0.0,        0.0},       // IMU 2
        {0.0,       0.0,        0.0},       // IMU 3
        {0.0,       0.0,        0.0},       // IMU 4
        {0.0,       0.0,        0.0},       // IMU 5
        {0.0,       0.0,        0.0},       // IMU 6
        {0.0,       0.0,        0.0}};      // IMU 7

// These magnetometer offsets [Gauss] will be subtracted from 
// the raw data to compensate for sensor bias
const float mag_offsets[array_length][3] = 
//      X           Y           Z
    {   {0.125,     0.095,      0.079},     // IMU 0    
        {0.227,     0.233,      -0.188},    // IMU 1
        {-0.023,    0.247,      0.125},     // IMU 2
        {0.261,     0.138,      0.035},     // IMU 3
        {0.0,       0.0,        0.0},       // IMU 4
        {0.0,       0.0,        0.0},       // IMU 5
        {0.0,       0.0,        0.0},       // IMU 6
        {0.0,       0.0,        0.0}};      // IMU 7

// These 3x3 magnetometer soft iron compensation matrices will
// be multiplied by the raw data after the hard iron offsets 
// have been removed using the vectors above
const float mag_scaling[array_length][3][3] = 
    {
        {   // IMU 0
            {2.424,     0.0,        0.0},
            {0.0,       2.422,      0.0},
            {0.0,       0.0,        2.600}
        },
        {   // IMU 1
            {2.516,     0.0,        0.0},
            {0.0,       2.485,      0.0},
            {0.0,       0.0,        2.725}
        },
        {   // IMU 2
            {2.488,     0.0,        0.0},
            {0.0,       2.557,      0.0},
            {0.0,       0.0,        2.599}
        },
        {   // IMU 3
            {2.508,     0.0,        0.0},
            {0.0,       2.462,      0.0},
            {0.0,       0.0,        2.601}
        },
        {   // IMU 4
            {1.0,       0.0,        0.0},
            {0.0,       1.0,        0.0},
            {0.0,       0.0,        1.0}
        },
        {   // IMU 5
            {1.0,       0.0,        0.0},
            {0.0,       1.0,        0.0},
            {0.0,       0.0,        1.0}
        },
        {   // IMU 6
            {1.0,       0.0,        0.0},
            {0.0,       1.0,        0.0},
            {0.0,       0.0,        1.0}
        },
        {   // IMU 7
            {1.0,       0.0,        0.0},
            {0.0,       1.0,        0.0},
            {0.0,       0.0,        1.0}
        }
    };



#endif
