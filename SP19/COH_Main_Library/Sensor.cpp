
#include "Sensor.h"

/////////////////////////////////////////////////////
///////////////// Public Functions //////////////////
/////////////////////////////////////////////////////

Sensor::Sensor(int num_imus){
  NUM_IMUS = num_imus;
}

void Sensor::init(){

    Wire.setSCL(I2C_SCL_PIN);
    Wire.setSDA(I2C_SDA_PIN);

    for( int imu = 0; imu < NUM_IMUS; imu++){
        Serial.print("Initializing IMU#: "); Serial.print(imu); Serial.print("... ");
        // Configure CS pin as output and pull it low
        pinMode(CS_pins[imu],OUTPUT);
        digitalWrite(CS_pins[imu],LOW);
        // Configure imu settings such as sample rate
        config_imu_settings(imu);

        if (!imu_list[imu].begin()){
            //Serial.println("Failed");
            while (1); // don't continue
        }
        Serial.println("Success");
        digitalWrite(CS_pins[imu],HIGH);
    }
    pinMode(CALIB_BUTTON_PIN,INPUT);
}


void Sensor::read_sensors(void){
    get_data();
    apply_calibrations();
}


void Sensor::calibrate_ag(bool stop_after){

    // Initialize arrays to store raw calibration data
    float sum_gyro[NUM_IMUS][3];
    float avg_gyro[NUM_IMUS][3];
    float sum_accel[NUM_IMUS][3];
    float avg_accel[NUM_IMUS][3];

    Serial.println("Starting Calibration of Accelerometer and Gyroscope");

    ///////////////////////////////////////////////////////////////////////
    // Calibrate gyroscope and z axis of accelerometer
    ///////////////////////////////////////////////////////////////////////

    Serial.println("Lay IMU on a flat surface with the z axis oriented upwards, then press the button to begin");

    // wait for button to be pressed
    while(true) { if(digitalRead(CALIB_BUTTON_PIN)) break; }
    Serial.print("Collecting data...");
    delay(500);

    // loop through each imu
    for(int imu = 0; imu < NUM_IMUS; imu++){
        digitalWrite(CS_pins[imu],LOW);
        // collect 32 samples
        for( int i = 0; i< 32; i++){
          imu_list[imu].readAccel();
          imu_list[imu].readGyro();
          sum_gyro[imu][0] += -imu_list[imu].calcGyro(imu_list[imu].gx); // negated for RHR
          sum_gyro[imu][1] += imu_list[imu].calcGyro(imu_list[imu].gy);
          sum_gyro[imu][2] += imu_list[imu].calcGyro(imu_list[imu].gz);
          sum_accel[imu][2] += imu_list[imu].calcAccel(imu_list[imu].az);
        }
        digitalWrite(CS_pins[imu],HIGH);

        avg_gyro[imu][0] = sum_gyro[imu][0]/32;
        avg_gyro[imu][1] = sum_gyro[imu][1]/32;
        avg_gyro[imu][2] = sum_gyro[imu][2]/32;
        avg_accel[imu][2] = sum_accel[imu][2]/32;
    }
    Serial.println("  done"); Serial.println("");

    ///////////////////////////////////////////////////////////////////////
    // Calibrate y axis of accelerometer
    ///////////////////////////////////////////////////////////////////////

    Serial.println("Rotate to negative 90deg around X, then press the button to begin");

    // wait for button to be pressed
    while(true) { if(digitalRead(CALIB_BUTTON_PIN)) break; }
    Serial.print("Collecting data...");
    delay(500);

    // loop through each imu
    for(int imu = 0; imu < NUM_IMUS; imu++){
        digitalWrite(CS_pins[imu],LOW);
        // collect 32 samples
        for( int j = 0; j<32; j++){
            imu_list[imu].readAccel();
            sum_accel[imu][1] += imu_list[imu].calcAccel(imu_list[imu].ay);
        }
        digitalWrite(CS_pins[imu],HIGH);
        avg_accel[imu][1] = sum_accel[imu][1]/32;
    }
    Serial.println("  done"); Serial.println("");

    ///////////////////////////////////////////////////////////////////////
    // Calibrate x axis of accelerometer
    ///////////////////////////////////////////////////////////////////////

    Serial.println("Rotate to positive 90deg around Y, then press the button to begin");

    // wait for button to be pressed
    while(true) { if(digitalRead(CALIB_BUTTON_PIN)) break; }
    Serial.print("Collecting data...");
    delay(500);

    for(int imu = 0; imu < NUM_IMUS; imu++){
        digitalWrite(CS_pins[imu],LOW);
        // collect 32 samples
        for(int k = 0 ; k < 32 ; k++){
            imu_list[imu].readAccel();
            sum_accel[imu][0] += -imu_list[imu].calcAccel(imu_list[imu].ax); // negated for RHR
        }
        digitalWrite(CS_pins[imu],HIGH);
        avg_accel[imu][0] = sum_accel[imu][0]/32;
    }
    Serial.println("  done"); Serial.println("");

    ///////////////////////////////////////////////////////////////////////
    // Calculate offsets
    ///////////////////////////////////////////////////////////////////////

    for(int imu = 0; imu < NUM_IMUS; imu++){
        custom_a_offsets[imu][0] = (1 - avg_accel[imu][0]);
        custom_a_offsets[imu][1] = (1 - avg_accel[imu][1]);
        custom_a_offsets[imu][2] = (1 - avg_accel[imu][2]);

        custom_g_offsets[imu][0] = (0 - avg_gyro[imu][0]);
        custom_g_offsets[imu][0] = (0 - avg_gyro[imu][0]);
        custom_g_offsets[imu][0] = (0 - avg_gyro[imu][0]);
    }

    Serial.println("Done with calibration for accelerometer and gyroscope");

    // while(stop_after){}
}


void Sensor::calibrate_m(bool stop_after){
    // need to implement
}


String Sensor::print_accel(int imu){
    // resturns a string of space-delimited accelerations for one imu
    String print_string = "";
    print_string += String(sensor_state.accel_data[imu][0]);
    print_string += "  ";
    print_string += String(sensor_state.accel_data[imu][1]);
    print_string += "  ";
    print_string += String(sensor_state.accel_data[imu][2]);
    return print_string;
}

String Sensor::print_gyro(int imu){
    // resturns a string of space-delimited rotation rates for one imu
    String print_string = "";
    print_string += String(sensor_state.gyro_data[imu][0]);
    print_string += "  ";
    print_string += String(sensor_state.gyro_data[imu][1]);
    print_string += "  ";
    print_string += String(sensor_state.gyro_data[imu][2]);
    return print_string;
}

String Sensor::print_mag(int imu){
    // resturns a string of space-delimited magnetic flux density measuremnets for one imu
    String print_string = "";
    print_string += String(sensor_state.mag_data[imu][0]);
    print_string += "  ";
    print_string += String(sensor_state.mag_data[imu][1]);
    print_string += "  ";
    print_string += String(sensor_state.mag_data[imu][2]);
    return print_string;
}


String Sensor::print_accel_raw(int imu){
    // resturns a string of space-delimited raw accelerations for one imu
    String print_string = "";
    print_string += String(accel_data_raw[imu][0]);
    print_string += "  ";
    print_string += String(accel_data_raw[imu][1]);
    print_string += "  ";
    print_string += String(accel_data_raw[imu][2]);
    return print_string;
}

String Sensor::print_gyro_raw(int imu){
    // resturns a string of space-delimited raw rotation rates for one imu
    String print_string = "";
    print_string += String(gyro_data_raw[imu][0]);
    print_string += "  ";
    print_string += String(gyro_data_raw[imu][1]);
    print_string += "  ";
    print_string += String(gyro_data_raw[imu][2]);
    return print_string;
}

String Sensor::print_mag_raw(int imu){
    // resturns a string of space-delimited raw magnetic flux density measuremnets for one imu
    String print_string = "";
    print_string += String(mag_data_raw[imu][0]);
    print_string += "  ";
    print_string += String(mag_data_raw[imu][1]);
    print_string += "  ";
    print_string += String(mag_data_raw[imu][2]);
    return print_string;
}

String Sensor::print_a_cal_offsets(int imu){
    String print_string = "IMU#";
    print_string += String(imu);
    print_string += " Custom Accel Offsets:  X: ";
    print_string += String(custom_a_offsets[imu][0]);
    print_string += ",  Y: ";
    print_string += String(custom_a_offsets[imu][1]);
    print_string += ",  Z: ";
    print_string += String(custom_a_offsets[imu][2]);
    return print_string;
}

String Sensor::print_g_cal_offsets(int imu){
    String print_string = "IMU#";
    print_string += String(imu);
    print_string += " Custom Gyro Offsets:  X: ";
    print_string += String(custom_g_offsets[imu][0]);
    print_string += ",  Y: ";
    print_string += String(custom_g_offsets[imu][1]);
    print_string += ",  Z: ";
    print_string += String(custom_g_offsets[imu][2]);
    return print_string;
}

String Sensor::print_m_cal_offsets(int imu){
    String print_string = "IMU#";
    print_string += String(imu);
    print_string += " Custom Mag Offsets:  X: ";
    print_string += String(custom_m_offsets[imu][0]);
    print_string += ",  Y: ";
    print_string += String(custom_m_offsets[imu][1]);
    print_string += ",  Z: ";
    print_string += String(custom_m_offsets[imu][2]);
    return print_string;
}

String Sensor::print_m_cal_scaling(int imu){
    String print_string = "IMU#";
    print_string += String(imu);
    print_string += " Custom Mag Scaling:  X: ";
    print_string += String(custom_m_scaling[imu][0]);
    print_string += ",  Y: ";
    print_string += String(custom_m_scaling[imu][1]);
    print_string += ",  Z: ";
    print_string += String(custom_m_scaling[imu][2]);
    return print_string;
}


/////////////////////////////////////////////////////
///////////////// Private Functions /////////////////
/////////////////////////////////////////////////////

void Sensor::config_imu_settings(int imu){
    imu_list[imu].settings.device.commInterface = IMU_MODE_I2C;
    imu_list[imu].settings.device.mAddress = LSM9DS1_M;
    imu_list[imu].settings.device.agAddress = LSM9DS1_AG;

    /////////////////////////////////////////////////////////
    ////////////////// Gyro Initialization //////////////////
    /////////////////////////////////////////////////////////
    imu_list[imu].settings.gyro.enabled = true;
    // scale can be set to either 245, 500, or 2000
    imu_list[imu].settings.gyro.scale = 500;
    // 1 = 14.9, 2 = 59.5, 3 = 119, 4 = 238, 5 = 476, 6 = 952 [Hz]
    imu_list[imu].settings.gyro.sampleRate = 3;
    // [bandwidth] can set the cutoff frequency of the gyro.
    // Allowed values: 0-3. Actual value of cutoff frequency
    // depends on the sample rate. (Datasheet section 7.12)
    imu_list[imu].settings.gyro.bandwidth = 0;
    imu_list[imu].settings.gyro.lowPowerEnable = false;
    imu_list[imu].settings.gyro.HPFEnable = true; // HPF disabled
    // [HPFCutoff] sets the HPF cutoff frequency (if enabled)
    // Allowable values are 0-9. Value depends on ODR.
    // (Datasheet section 7.14)
    imu_list[imu].settings.gyro.HPFCutoff = 1; // HPF cutoff = 4Hz
    imu_list[imu].settings.gyro.flipX = false; // Don't flip X
    imu_list[imu].settings.gyro.flipY = false; // Don't flip Y
    imu_list[imu].settings.gyro.flipZ = false; // Don't flip Z

    // Accelerometer Initialization
    imu_list[imu].settings.accel.enabled = true;
    imu_list[imu].settings.accel.enableX = true; // Enable X
    imu_list[imu].settings.accel.enableY = true; // Enable Y
    imu_list[imu].settings.accel.enableZ = true; // Enable Z
    // accel scale can be 2, 4, 8, or 16 [g]
    imu_list[imu].settings.accel.scale = 8;
    // 1 = 10, 2 = 50, 3 = 119, 4 = 238, 5 = 476, 6 = 952 [Hz]
    imu_list[imu].settings.accel.sampleRate = 1; // Set accel to 10Hz.
    // [bandwidth] sets the anti-aliasing filter bandwidth.
    // Accel cutoff freqeuncy can be any value between -1 - 3.
    // -1 = bandwidth determined by sample rate
    // 0 = 408 Hz   2 = 105 Hz
    // 1 = 211 Hz   3 = 50 Hz
    imu_list[imu].settings.accel.bandwidth = 0; // BW = 408Hz
    // [highResEnable] enables or disables high resolution
    // mode for the acclerometer.
    imu_list[imu].settings.accel.highResEnable = false; // Disable HR
    // [highResBandwidth] sets the LP cutoff frequency of
    // the accelerometer if it's in high-res mode.
    // can be any value between 0-3
    // LP cutoff is set to a factor of sample rate
    // 0 = ODR/50    2 = ODR/9
    // 1 = ODR/100   3 = ODR/400
    imu_list[imu].settings.accel.highResBandwidth = 0;

    // Magnetometer Initialization
    // [enabled] turns the magnetometer on or off.
    imu_list[imu].settings.mag.enabled = true; // Enable magnetometer
    // [scale] sets the full-scale range of the magnetometer
    // mag scale can be 4, 8, 12, or 16
    imu_list[imu].settings.mag.scale = 4;
    // 0 = 0.625, 1 = 1.25, 2 = 2.5, 3 = 5, 4 = 10, 5 = 20, 6 = 40, 7 = 80 [Hz]
    imu_list[imu].settings.mag.sampleRate = 7;
    // [tempCompensationEnable] enables or disables
    // temperature compensation of the magnetometer.
    imu_list[imu].settings.mag.tempCompensationEnable = false;
    // 0 = Low power mode      2 = high performance
    // 1 = medium performance  3 = ultra-high performance
    imu_list[imu].settings.mag.XYPerformance = 3; // Ultra-high perform.
    imu_list[imu].settings.mag.ZPerformance = 3; // Ultra-high perform.
    imu_list[imu].settings.mag.lowPowerEnable = false;
    // 0 = continuous conversion
    // 1 = single-conversion
    // 2 = power down
    imu_list[imu].settings.mag.operatingMode = 0; // Continuous mode
    imu_list[imu].settings.temp.enabled = true;
}

void Sensor::get_data(void){
    for( int imu = 0; imu < NUM_IMUS; imu++){

        // pull CS line low for one imu
        digitalWrite(CS_pins[imu],LOW);

        // check to see if data is available and if so sample the imu
        if (imu_list[imu].accelAvailable()){
          imu_list[imu].readAccel();
        }
        if (imu_list[imu].gyroAvailable()){
          imu_list[imu].readGyro();
        }
        if (imu_list[imu].magAvailable()){
          imu_list[imu].readMag();
        }

        // update raw data arrays with new values
        accel_data_raw[imu][0] = -imu_list[imu].calcAccel(imu_list[imu].ax); // negated for RHR
        accel_data_raw[imu][1] = imu_list[imu].calcAccel(imu_list[imu].ay);
        accel_data_raw[imu][2] = imu_list[imu].calcAccel(imu_list[imu].az);

        gyro_data_raw[imu][0] = -imu_list[imu].calcGyro(imu_list[imu].gx); // negated for RHR
        gyro_data_raw[imu][1] = imu_list[imu].calcGyro(imu_list[imu].gy);
        gyro_data_raw[imu][2] = imu_list[imu].calcGyro(imu_list[imu].gz);

        mag_data_raw[imu][0] = imu_list[imu].calcMag(imu_list[imu].mx);
        mag_data_raw[imu][1] = imu_list[imu].calcMag(imu_list[imu].my);
        mag_data_raw[imu][2] = imu_list[imu].calcMag(imu_list[imu].mz);

        digitalWrite(CS_pins[imu],HIGH);
    }
}

void Sensor::apply_calibrations(void){
    // populates calibrated data struct using the raw data arrays and the
    // offsets in Calibrations.h
    for( int imu = 0; imu < NUM_IMUS; imu++){
        // remove accel offsets
        sensor_state.accel_data[imu][0] = accel_data_raw[imu][0] - accel_offsets[imu][0];
        sensor_state.accel_data[imu][1] = accel_data_raw[imu][1] - accel_offsets[imu][1];
        sensor_state.accel_data[imu][2] = accel_data_raw[imu][2] - accel_offsets[imu][2];
        // remove gyro offsets
        sensor_state.gyro_data[imu][0] = gyro_data_raw[imu][0] - gyro_offsets[imu][0];
        sensor_state.gyro_data[imu][1] = gyro_data_raw[imu][1] - gyro_offsets[imu][1];
        sensor_state.gyro_data[imu][2] = gyro_data_raw[imu][2] - gyro_offsets[imu][2];
        // remove mag offsets
        float mx = mag_data_raw[imu][0] - mag_offsets[imu][0];
        float my = mag_data_raw[imu][1] - mag_offsets[imu][1];
        float mz = mag_data_raw[imu][2] - mag_offsets[imu][2];

        // apply soft iron compensation
        sensor_state.mag_data[imu][0] = mx * mag_scaling[imu][0][0] + my * mag_scaling[imu][0][1] + mz * mag_scaling[imu][0][2];
        sensor_state.mag_data[imu][1] = mx * mag_scaling[imu][1][0] + my * mag_scaling[imu][1][1] + mz * mag_scaling[imu][1][2];
        sensor_state.mag_data[imu][2] = mx * mag_scaling[imu][2][0] + my * mag_scaling[imu][2][1] + mz * mag_scaling[imu][2][2];
    }
}
