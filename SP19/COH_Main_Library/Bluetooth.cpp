#include "Bluetooth.h"

Bluetooth::Bluetooth(int num_filters){
  NUM_FILTERS = num_filters;

}

void Bluetooth::init(void){
  HWSERIAL.begin(baudRate);
  COMPSERIAL.begin(baudRate);
}

//allows float to byte change
//doesn't need to be public
union{
  float fval;
  byte bval[4];
}floatAsByte;

void Bluetooth::float2Byte(float value)
{
  floatAsByte.fval = value;
}

void Bluetooth::sendData(filter_state_t * filter_state)
{
  for(int i = 0; i<NUM_FILTERS;i++)
  {
    floatAsByte.fval = filter_state->q_inertial_imu[i].q0;
    for(int j = 0; j<3; j++){HWSERIAL.write(floatAsByte.bval[i]);}
    COMPSERIAL.write("sent q0");

    floatAsByte.fval = filter_state->q_inertial_imu[i].q1;
    for(int j = 0; j<3; j++){HWSERIAL.write(floatAsByte.bval[i]);}
    COMPSERIAL.write("sent q1");

    floatAsByte.fval = filter_state->q_inertial_imu[i].q2;
    for(int j = 0; j<3; j++){HWSERIAL.write(floatAsByte.bval[i]);}
    COMPSERIAL.write("sent q2");

    floatAsByte.fval = filter_state->q_inertial_imu[i].q3;
    for(int j = 0; j<3; j++){HWSERIAL.write(floatAsByte.bval[i]);}
    COMPSERIAL.write("sent q3");
  }
}

  void Bluetooth::testSendFloat(float value)
  {
    COMPSERIAL.write("sending float");
    floatAsByte.fval=value;
    for (int i = 0; i <3; i++)
    {
      HWSERIAL.write(floatAsByte.bval[i]);
    }
    COMPSERIAL.write("send");
  }
