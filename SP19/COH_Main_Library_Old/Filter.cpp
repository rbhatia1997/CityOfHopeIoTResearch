
#include "Filter.h"


Filter::Filter(int num_filters, float sample_frequency){
    NUM_FILTERS = num_filters;
    SAMPLE_FREQUENCY = sample_frequency;
}

void Filter::init(void){
    for(int filter = 0; filter < NUM_FILTERS; filter++){
        mahony_list[filter].begin(SAMPLE_FREQUENCY, KP, KI);
    } 
}

void Filter::update(float accel_data[8][3],float gyro_data[8][3],float mag_data[8][3]){
    for(int imu = 0; imu < NUM_FILTERS; imu++){
        // Serial.print(accel_data[imu][0]);Serial.print(" ");
        // Serial.print(accel_data[imu][1]);Serial.print(" ");
        // Serial.println(accel_data[imu][2]);

        // Serial.print(gyro_data[imu][0]);Serial.print(" ");
        // Serial.print(gyro_data[imu][1]);Serial.print(" ");
        // Serial.println(gyro_data[imu][2]);

        // Serial.print(mag_data[imu][0]);Serial.print(" ");
        // Serial.print(mag_data[imu][1]);Serial.print(" ");
        // Serial.println(mag_data[imu][2]);

        // give filter data from each imu
        // mahony_list[imu].update(Sensor_Ref.gyro_data[imu][0],Sensor_Ref.gyro_data[imu][1],Sensor_Ref.gyro_data[imu][2],
        //                         Sensor_Ref.accel_data[imu][0],Sensor_Ref.accel_data[imu][1],Sensor_Ref.accel_data[imu][2],
        //                         Sensor_Ref.mag_data[imu][0],Sensor_Ref.mag_data[imu][1],Sensor_Ref.mag_data[imu][2]);
        mahony_list[imu].update(gyro_data[imu][0],gyro_data[imu][1],gyro_data[imu][2],
                                accel_data[imu][0],accel_data[imu][1],accel_data[imu][2],
                                mag_data[imu][0],mag_data[imu][1],mag_data[imu][2]);
        // update the roll, pitch, and yaw from the inertial to the imu frame for each imu
        rpy_inertial_imu[imu][0] = mahony_list[imu].getRoll();
        rpy_inertial_imu[imu][1] = mahony_list[imu].getPitch();
        rpy_inertial_imu[imu][2] = mahony_list[imu].getYaw();
        //Serial.println(rpy_inertial_imu[imu][1]);
        // update the quaternion for the inertial to the imu frame for each imu
        q_inertial_imu[imu][0] = mahony_list[imu].get_q0();
        q_inertial_imu[imu][1] = mahony_list[imu].get_q1();
        q_inertial_imu[imu][2] = mahony_list[imu].get_q2();
        q_inertial_imu[imu][3] = mahony_list[imu].get_q3();

        /////////////////////////////////////////////////////////////
        // do calculations with quaternions to populate other arrays
        /////////////////////////////////////////////////////////////
    }
}

String Filter::print_rpy_intertial_imu(int filter){
    // returns a string of space-delimited roll, pitch, yaw angles for one imu in the inertial frame
    String print_string = "";
    print_string += String(rpy_inertial_imu[filter][0]);
    print_string += "  ";
    print_string += String(rpy_inertial_imu[filter][1]);
    print_string += "  ";
    print_string += String(rpy_inertial_imu[filter][2]);
    return print_string;
}


String Filter::print_rpy_body_imu(int filter){
    // returns a string of space-delimited roll, pitch, yaw angles for one imu in the body frame
    String print_string = "";
    print_string += String(rpy_body_imu[filter][0]);
    print_string += "  ";
    print_string += String(rpy_body_imu[filter][1]);
    print_string += "  ";
    print_string += String(rpy_body_imu[filter][2]);
    return print_string;
}


String Filter::print_rpy_inertial_body(void){
    // returns a string of space-delimited roll, pitch, yaw angles for the body
    String print_string = "";
    print_string += String(rpy_inertial_body[0]);
    print_string += "  ";
    print_string += String(rpy_inertial_body[1]);
    print_string += "  ";
    print_string += String(rpy_inertial_body[2]);
    return print_string;
}

String Filter::print_q_inertial_imu(int filter){
    // returns a string of space-delimited quaternion values
    String print_string = "";
    print_string += String(mahony_list[filter].get_q0());
    print_string += "  ";
    print_string += String(mahony_list[filter].get_q1());
    print_string += "  ";
    print_string += String(mahony_list[filter].get_q2());
    print_string += "  ";
    print_string += String(mahony_list[filter].get_q3());
    return print_string;
}

float Filter::get_q0(int filter){
    return mahony_list[filter].get_q0();
}

float Filter::get_q1(int filter){
    return mahony_list[filter].get_q1();
}

float Filter::get_q2(int filter){
    return mahony_list[filter].get_q2();
}

float Filter::get_q3(int filter){
    return mahony_list[filter].get_q3();
}


void Filter::q_to_rpy(float *q, float *rpy){

}

void Filter::convert_to_body(void){

}


