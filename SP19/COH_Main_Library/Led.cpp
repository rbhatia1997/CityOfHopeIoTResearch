#include "Led.h"


Led::Led(int led_pin){
    pin = led_pin;
    pinMode(pin,OUTPUT);
}

void Led::blink(int duration){
    digitalWrite(pin,HIGH);
    delay(duration);
    digitalWrite(pin,LOW);
}

void Led::turn_on(void){
    digitalWrite(pin,HIGH);
}

void Led::turn_off(void){
    digitalWrite(pin,LOW);
}




