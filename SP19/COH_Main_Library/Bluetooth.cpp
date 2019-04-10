#include "Bluetooth.h"

Bluetooth::Bluetooth(int num_filters){
  NUM_FILTERS = num_filters;

}

void Bluetooth::init(void){
  HWSERIAL.begin(baudRate);
  //COMPSERIAL.begin(baudRate);
}

//allows float to byte change
//doesn't need to be public
union{
  float f_val;
  byte b_arr[4];
}floatAsByte;

void Bluetooth::float2Byte(float value)
{
  floatAsByte.f_val = value;
}

void Bluetooth::sendData(filter_state_t * filter_state)
{
  for(int k = 0; k < 3; k++){
    HWSERIAL.write(start[k]);
  }
  COMPSERIAL.write("Sent start");
  
  for(int i = 0; i<NUM_FILTERS;i++)
  {
    floatAsByte.f_val = filter_state->q_inertial_imu[i].q0;
    for(int j = 0; j<3; j++){HWSERIAL.write(floatAsByte.b_arr[i]);}
    COMPSERIAL.write("sent q0");

    floatAsByte.f_val = filter_state->q_inertial_imu[i].q1;
    for(int j = 0; j<3; j++){HWSERIAL.write(floatAsByte.b_arr[i]);}
    COMPSERIAL.write("sent q1");

    floatAsByte.f_val = filter_state->q_inertial_imu[i].q2;
    for(int j = 0; j<3; j++){HWSERIAL.write(floatAsByte.b_arr[i]);}
    COMPSERIAL.write("sent q2");

    floatAsByte.f_val = filter_state->q_inertial_imu[i].q3;
    for(int j = 0; j<3; j++){HWSERIAL.write(floatAsByte.b_arr[i]);}
    COMPSERIAL.write("sent q3");
  }
}

  void Bluetooth::testSendFloat(float value)
  {
    // COMPSERIAL.write("sending float... ");
    // // float data_arr[4] = {1.01, 1.02, 1.03, 1.04};
    // // floatAsByte.f_arr = {1.01, 1.02, 1.03, 1.04};

    // HWSERIAL.write(start,4);
    // HWSERIAL.write(floatAsByte.b_arr,16);
    // COMPSERIAL.write("sent\n");

  }
