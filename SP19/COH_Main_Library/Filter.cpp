
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

void Filter::update(sensor_state_t * sensor_state){
    for(int imu = 0; imu < NUM_FILTERS; imu++){
        // pass sensor data to mahony filter
        mahony_list[imu].update(sensor_state->gyro_data[imu][0],sensor_state->gyro_data[imu][1],sensor_state->gyro_data[imu][2],
                                sensor_state->accel_data[imu][0],sensor_state->accel_data[imu][1],sensor_state->accel_data[imu][2],
                                sensor_state->mag_data[imu][0],sensor_state->mag_data[imu][1],sensor_state->mag_data[imu][2]);
        // update the roll, pitch, and yaw from the inertial to the imu frame for each imu
        rpy_inertial_imu[imu][0] = mahony_list[imu].getRoll();
        rpy_inertial_imu[imu][1] = mahony_list[imu].getPitch();
        rpy_inertial_imu[imu][2] = mahony_list[imu].getYaw();
        // update the quaternion for the inertial to the imu frame for each imu
        filter_state.q_inertial_imu[imu] = mahony_list[imu].get_q();
        // q_inertial_imu[imu][0] = mahony_list[imu].get_q0();
        // q_inertial_imu[imu][1] = mahony_list[imu].get_q1();
        // q_inertial_imu[imu][2] = mahony_list[imu].get_q2();
        // q_inertial_imu[imu][3] = mahony_list[imu].get_q3();
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


String Filter::print_q_inertial_imu(int filter){
    // returns a string of space-delimited quaternion values
    String print_string = "";
    print_string += String(filter_state.q_inertial_imu[filter].q0);
    print_string += "  ";
    print_string += String(filter_state.q_inertial_imu[filter].q1);
    print_string += "  ";
    print_string += String(filter_state.q_inertial_imu[filter].q2);
    print_string += "  ";
    print_string += String(filter_state.q_inertial_imu[filter].q3);
    return print_string;
}



