#ifndef __BLUETOOTH_h__
#define __BLUETOOTH_h__

//#include "library.h"
#include "Filter.h"

#define HWSERIAL Serial2 //sets which serial bus to use on Teensy
#define COMPSERIAL Serial //sets serial for computer
#define baudRate 250000 //sets the baud rate (bits per second

class Bluetooth
{
public:

    Bluetooth(int num_filters,bool printBool);

    void init(void);

    void float2Byte(float value);

    void sendData(filter_state_t * filter_state);
    void testSendFloat(float value);

private:
  int NUM_FILTERS;
  bool printToScreen;

  byte start[4] = {255,255,255,255};

};
#endif
