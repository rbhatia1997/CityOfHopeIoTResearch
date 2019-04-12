#include "Bluetooth.h"

Bluetooth::Bluetooth(int num_filters, bool printBool){
  NUM_FILTERS = num_filters;
  printToScreen = printBool;

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
  // for(int k = 0; k < 4; k++){
  //   HWSERIAL.write(start[k]);
  //   // delay(5);
  // }
  // if (printToScreen) {COMPSERIAL.write("Sent start\n");}
  // // delay(100);

  int prevTime = micros();

  float farr[19];
  floatAsByte.b_arr[0]=start[0];
  floatAsByte.b_arr[1]=start[1];
  floatAsByte.b_arr[2]=start[2];
  floatAsByte.b_arr[3]=start[3];

  farr[0] = floatAsByte.f_val; //start float
  farr[17] = millis()/1000.0; //timestamp
  farr[18] = 24.3; //stop float

  //populate array
  for (int i = 0; i < 4; ++i) {
    farr[4*i+1] = filter_state->q_inertial_imu[i].q0;
    farr[4*i+2] = filter_state->q_inertial_imu[i].q1;
    farr[4*i+3] = filter_state->q_inertial_imu[i].q2;
    farr[4*i+4] = filter_state->q_inertial_imu[i].q3;
  }

  // COMPSERIAL.println(farr[16]);
  // COMPSERIAL.println(farr[0]);
  // COMPSERIAL.println(farr[1]);
  // COMPSERIAL.println(farr[2]);
  // COMPSERIAL.println(farr[3]);

  //convert float array to byte array
  byte array[76];
  for (int i = 0; i < 19; ++i) {
    floatAsByte.f_val = farr[i];
    array[4*i] = floatAsByte.b_arr[3];
    array[4*i+1] = floatAsByte.b_arr[2];
    array[4*i+2] = floatAsByte.b_arr[1];
    array[4*i+3] = floatAsByte.b_arr[0];
  }

  //send over byte array
  for(int i = 0; i < 76; i++)
  {
    HWSERIAL.write(array[i]);
    // COMPSERIAL.println(testData);
    //delayMicroseconds(1);
  }
  long int loopTime = micros() - prevTime;
  if (printToScreen) {COMPSERIAL.print("Sent Data:"); COMPSERIAL.println(loopTime);}


}
