#ifndef __FILTER_h__
#define __FILTER_h__

#include "MadgwickAHRS.h"
#include "MahonyAHRS.h"

class Filter
{
public:
    // contructor: takes number of connected filters as input
    Filter(int num_filters, int sample_frequency);

    void init(void);

private:

    float SAMPLE_FREQUENCY;
    // mahony filter parameters
    float KP = 1000;
    float KI = 2;
    // madgwick filter parameters
    float beta = 0.001;

    // number of instantiated filters
    int NUM_FILTERS;
    
    // Creat Mahony filter objects
    Mahony mahony0, mahony1, mahony2, mahony3, mahony4, mahony5, mahony6, mahony7;        // MIGHT NEED TO PUT LSM9DS1 IN FRONT OF EACH
    Mahony mahony_list[8] = {mahony0, mahony1, mahony2, mahony3, mahony4, mahony5, mahony6, mahony7};

    // Creat Madgwick filter objects
    Madgwick madgwick0, madgwick1, madgwick2, madgwick3, madgwick4, madgwick5, madgwick6, madgwick7;        // MIGHT NEED TO PUT LSM9DS1 IN FRONT OF EACH
    Madgwick mahony_list[8] = {madgwick0,madgwick1,madgwick2,madgwick3,madgwick4,madgwick5,madgwick6,madgwick7};

};
#endif