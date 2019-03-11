#ifndef __LED_h__
#define __LED_h__

#include <Arduino.h>


class Led
{
public:

    Led(int led_pin);

    void blink(int duration);

    void turn_on(void);

    void turn_off(void);

private:

    int pin;

};
#endif