#include "Bluetooth.h"


Bluetooth::Bluetooth(void){

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

void float2Byte(float value)
{
  floatAsByte.fval = value;
}

void sendData()
{
  COMPSERIAL.write("Sending Data...");
  for(int i = 0; i<3; i++)
  {
    HWSERIAL.write(floatAsByte.bval[i]);
    COMPSERIAL.write("sent + String(i)");
  }
}
