//=============================================================================================
// MahonyAHRS.h
//=============================================================================================
//
// Madgwick's implementation of Mayhony's AHRS algorithm.
// See: http://www.x-io.co.uk/open-source-imu-and-ahrs-algorithms/
//
// Date			Author			Notes
// 29/09/2011	SOH Madgwick    Initial release
// 02/10/2011	SOH Madgwick	Optimised for reduced CPU load
//
//=============================================================================================
#ifndef MahonyAHRS_MOD_h
#define MahonyAHRS_MOD_h
#include <math.h>
#include <stdlib.h>

//--------------------------------------------------------------------------------------------
// Variable declaration

typedef struct {
	float q0;
	float q1;
	float q2;
	float q3;
} quat;


class Mahony {
private:
	float twoKp;		// 2 * proportional gain (Kp)
	float twoKi;		// 2 * integral gain (Ki)
	quat q; 			// quaternion of sensor frame relative to auxiliary frame
	float integralFBx, integralFBy, integralFBz;  // integral error terms scaled by Ki
	float invSampleFreq;
	float roll, pitch, yaw;
	char anglesComputed;
	static float invSqrt(float x);
	void computeAngles();

//-------------------------------------------------------------------------------------------
// Function declarations

public:
	Mahony();
	void begin(float sampleFrequency, float Kp, float Ki);
	void update(float gx, float gy, float gz, float ax, float ay, float az, float mx, float my, float mz);
	float getRoll() {
		if (!anglesComputed) computeAngles();
		return roll * 57.29578f;
	}
	float getPitch() {
		if (!anglesComputed) computeAngles();
		return pitch * 57.29578f;
	}
	float getYaw() {
		if (!anglesComputed) computeAngles();
		return yaw * 57.29578f + 180.0f;
	}
	float getRollRadians() {
		if (!anglesComputed) computeAngles();
		return roll;
	}
	float getPitchRadians() {
		if (!anglesComputed) computeAngles();
		return pitch;
	}
	float getYawRadians() {
		if (!anglesComputed) computeAngles();
		return yaw;
	}
	float get_q0() {
		return q.q0;
	}
	float get_q1() {
		return q.q1;
	}
	float get_q2() {
		return q.q2;
	}
	float get_q3() {
		return q.q3;
	}

	quat get_q(){
		return q;
	}


};
#endif
