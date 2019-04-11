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
  for(int k = 0; k < 4; k++){
    HWSERIAL.write(start[k]);
    // delay(5);
  }
  if (printToScreen) {COMPSERIAL.write("Sent start\n");}
  // delay(100);

  //test data to send over
  // long int prevTime = millis();
  // byte testData = 0;

  float farr[17];
  farr[16] = 0.201;

  for (int i = 0; i < 4; ++i) {
    // farr[i] = 3*i;
    farr[4*i] = filter_state->q_inertial_imu[i].q0;
    farr[4*i+1] = filter_state->q_inertial_imu[i].q1;
    farr[4*i+2] = filter_state->q_inertial_imu[i].q2;
    farr[4*i+3] = filter_state->q_inertial_imu[i].q3;
  }

  COMPSERIAL.println(farr[16]);
  COMPSERIAL.println(farr[0]);
  COMPSERIAL.println(farr[1]);
  COMPSERIAL.println(farr[2]);
  COMPSERIAL.println(farr[3]);

  byte array[68];

  for (int i = 0; i < 17; ++i) {
    floatAsByte.f_val = farr[i];
    array[4*i] = floatAsByte.b_arr[3];
    array[4*i+1] = floatAsByte.b_arr[2];
    array[4*i+2] = floatAsByte.b_arr[1];
    array[4*i+3] = floatAsByte.b_arr[0];
  }

  for(int i = 0; i < 68; i++)
  {
    // testData++;
    HWSERIAL.write(array[i]);
    // COMPSERIAL.println(testData);
    delay(5);
  }
  // long int loopTime = millis() - prevTime;
  // if (printToScreen) {COMPSERIAL.print("Sent test Data:"); COMPSERIAL.println(loopTime);}


  // for(int i = 0; i<NUM_FILTERS;i++)
  // {
  //   floatAsByte.f_val = millis();
  //
  //   floatAsByte.f_val = filter_state->q_inertial_imu[i].q0;
  //   for(int j = 0; j<4; j++){HWSERIAL.write(floatAsByte.b_arr[i]);
  //   delay(5);}
  //   if (printToScreen) {COMPSERIAL.write("sent q0\n");}
  //
  //   floatAsByte.f_val = filter_state->q_inertial_imu[i].q1;
  //   for(int j = 0; j<4; j++){HWSERIAL.write(floatAsByte.b_arr[i]);
  //   delay(5);}
  //   if (printToScreen) {COMPSERIAL.write("sent q1\n");}
  //
  //   floatAsByte.f_val = filter_state->q_inertial_imu[i].q2;
  //   for(int j = 0; j<4; j++){HWSERIAL.write(floatAsByte.b_arr[i]);
  //   delay(5);}
  //   if (printToScreen) {COMPSERIAL.write("sent q2\n");}
  //
  //   floatAsByte.f_val = filter_state->q_inertial_imu[i].q3;
  //   for(int j = 0; j<4; j++){HWSERIAL.write(floatAsByte.b_arr[i]);
  //   delay(5);}
  //   if (printToScreen) {COMPSERIAL.write("sent q3\n");}
  //
  //   for(int j = 0; j<4; j++) {HWSERIAL.write(floatAsByte.b_arr[i]);
  //   delay(5);}
  //   if (printToScreen) {COMPSERIAL.write("sent time\n");}
  //
  // }
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
