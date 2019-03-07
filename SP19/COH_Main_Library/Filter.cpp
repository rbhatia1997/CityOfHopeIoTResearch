
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

void Filter::update(Sensor& linked_sensor){
    Sensor sensor = linked_sensor;
    for(int imu = 0; imu < NUM_FILTERS; imu++){
        // give filter data from each imu
        mahony_list[imu].update(sensor.gyro_data[imu][0],sensor.gyro_data[imu][1],sensor.gyro_data[imu][2],
                                sensor.accel_data[imu][0],sensor.accel_data[imu][1],sensor.accel_data[imu][2],
                                sensor.mag_data[imu][0],sensor.mag_data[imu][1],sensor.mag_data[imu][2]);
        // mahony_list[imu].update(sensor-> sensor->gyro_data[imu][0],sensor->gyro_data[imu][1],sensor->gyro_data[imu][2],
        //                         sensor->accel_data[imu][0],sensor->accel_data[imu][1],sensor->accel_data[imu][2],
        //                         sensor->mag_data[imu][0],sensor->mag_data[imu][1],sensor->mag_data[imu][2]);
        // update the roll, pitch, and yaw from the inertial to the imu frame for each imu
        rpy_inertial_imu[imu][0] = mahony_list[imu].getRoll();
        rpy_inertial_imu[imu][1] = mahony_list[imu].getPitch();
        rpy_inertial_imu[imu][2] = mahony_list[imu].getYaw();
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
    // resturns a string of space-delimited roll, pitch, yaw angles for one imu in the inertial frame
    String print_string = "";
    print_string += String(rpy_inertial_imu[filter][0]);
    print_string += "  ";
    print_string += String(rpy_inertial_imu[filter][1]);
    print_string += "  ";
    print_string += String(rpy_inertial_imu[filter][2]);
    return print_string;
}


String Filter::print_rpy_body_imu(int filter){
    // resturns a string of space-delimited roll, pitch, yaw angles for one imu in the body frame
    String print_string = "";
    print_string += String(rpy_body_imu[filter][0]);
    print_string += "  ";
    print_string += String(rpy_body_imu[filter][1]);
    print_string += "  ";
    print_string += String(rpy_body_imu[filter][2]);
    return print_string;
}


String Filter::print_rpy_inertial_body(void){
    // resturns a string of space-delimited roll, pitch, yaw angles for the body
    String print_string = "";
    print_string += String(rpy_inertial_body[0]);
    print_string += "  ";
    print_string += String(rpy_inertial_body[1]);
    print_string += "  ";
    print_string += String(rpy_inertial_body[2]);
    return print_string;
}


void Filter::q_to_rpy(float *q, float *rpy){

}

void Filter::convert_to_body(void){

}


