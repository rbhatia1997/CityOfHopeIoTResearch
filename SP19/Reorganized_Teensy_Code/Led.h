#ifndef __LED_h__
#define __LED_h__


class Led
{
public:

    Led(led_pin);

    void blink(int duration);

    void turn_on(void);

    void turn_off(void);

private:

    int pin;

};
#endif