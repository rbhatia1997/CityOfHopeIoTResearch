#include "MPU9250.h"

MPU9250 mpu;

double x_avg_past = 0;
double y_avg_past = 0;
double z_avg_past = 0;

int avg_size = 7;
int cal_avg_size = 1000;

double a1 = 0; // cos theta
double a2 = 0; // sin theta
double b1 = 0; // cos phi
double b2 = 0; // sin phi
double c1 = 0; // cos psi
double c2 = 0; // sin psi

double rot[3][3] = {
  { a1*c1, a1*c2, -a2},
  {b2*a2*c1-b1*c2, a2*b2*c2+b1*c1, b2*a1},
  {b1*a2*c1+b2*c2, b1*a2*c2-a2*c1, b1*a1}
  };

unsigned long t;

double x_cal = 0;
double y_cal = 0;
double z_cal = 0;

void setup()
{
    Serial.begin(115200);

    Wire.begin();

    delay(2000);
    mpu.setup();

    t = millis();
}

void loop()
{
    static uint32_t prev_ms = millis();
    if ((millis() - prev_ms) > 16)
    {
        mpu.update();
//        mpu.print();

        double z_yaw = mpu.getYaw();
        double y_pitch = mpu.getPitch();
        double x_roll = mpu.getRoll();
    
        //updating a1-c2 values
        a1 = cos(y_pitch);
        a2 = sin(y_pitch);
        b1 = cos(x_roll);
        b2 = sin(x_roll);
        c1 = cos(z_yaw);
        c2 = sin(z_yaw);
     
        double x_avg = ( (avg_size - 1)*x_avg_past + x_roll) / avg_size - x_cal;
        double y_avg = ( (avg_size - 1)*y_avg_past + y_pitch) / avg_size - y_cal;
        double z_avg = ( (avg_size - 1)*z_avg_past + z_yaw) / avg_size - z_cal;
    
        double x_cal_avg = ( (cal_avg_size - 1)*x_avg_past + x_roll) / cal_avg_size;
        double y_cal_avg = ( (cal_avg_size - 1)*y_avg_past + y_pitch) / cal_avg_size;
        double z_cal_avg = ( (cal_avg_size - 1)*z_avg_past + z_yaw) / cal_avg_size;
    
        x_avg_past = x_avg;
        y_avg_past = y_avg;
        z_avg_past = z_avg;
    
        Serial.print(x_roll);
        Serial.print("  ");
        Serial.print(y_pitch);
        Serial.print("  ");
        Serial.print(z_yaw);
    
        Serial.print("  ");
      
        Serial.print(x_avg);
        Serial.print("  ");
        Serial.print(y_avg);
        Serial.print("  ");
        Serial.println(z_avg);
    
        if (t == 15000) {
            x_cal = x_cal_avg;
            y_cal = y_cal_avg;
            z_cal = z_cal_avg;
        }
        

        prev_ms = millis();
    }

}


