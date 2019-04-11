/*
    Based on Neil Kolban example for IDF: 
    https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleServer.cpp
    Based on the Arduino ESP32 Port by Evandro Copercini & Chegewara
    General changes & adaptation for iOS by Ronak Bhatia & Darien Joso from City of Hope's HMC Clinic
    Last Date Updated: Sunday, March 27, 2019

    See the following for generating UUIDs:
    https://www.uuidgenerator.net/

    The purpose of this code is to create a Bluetooth (BLE) Server, which does the following steps:
    (1) Create a BLE Server
    (2) Create a BLE Service
    (3) Create a BLE Characteristic based on this service
    (4) Create a BLE Descriptor based on the characteristic
    (5) Start the service and then start advertising
    In other words, a GATT server creates a service, which can contain multiple characteristics that
    include metadata, which in our case will be the data from the IMU (Quaternion or otherwise).
    A Quaternion is a four-element vector used to encode any rotation in a 3D coordinate system.
*/

// The following are libraries necessary for enabling BLE connection
// They are in-built into the ESP-32 Library and wouldn't need one to manually install.

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <iostream>
#include <string>
#include <string.h>
#include <stdio.h>

BLEServer* pServer = NULL; // null instance of BLE Server
BLEService *pService = NULL;

BLECharacteristic* pCharacteristic0 = NULL; // define global variable - characteristic

bool deviceConnected = false;

#define SERVICE_UUID         "2f391f0f-1c30-46fb-a972-a22c2f7570ee"
#define CHARACTERISTIC_UUID0 "beb5483e-36e1-4688-b7f5-ea07361b26a8"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    }

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

// Global variables initialization

// quaternions
float q0[] = {0, 0, 0, 0};
float q1[] = {0, 0, 0, 0};
float q2[] = {0, 0, 0, 0};
float q3[] = {0, 0, 0, 0};

// quaternion hex strings
char quat0Data[137] = "";

// time variables
uint32_t ti;
uint32_t tf;
float td;

void setup() {
  Serial.begin(115200); // this BAUD rate is set intentionally
  Serial.println("Initializing ESP32 as BLE Device...");

  // bluetooth setup
  BLEDevice::init("City of Hope BLE Testing");
  BLEServer *pServer = BLEDevice::createServer();

  // do not forget to call back for updates
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);
  
  Serial.println("Creating BLE Server & Callback Function Success");

  // setup characteristics
  pCharacteristic0 = pService->createCharacteristic(CHARACTERISTIC_UUID0,
                       BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);
                       
  // add descriptors to characteristics
  pCharacteristic0->addDescriptor(new BLE2902());

  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising(); // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06); // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  
  Serial.println("Characteristic defined!");
}

void loop() {
  if (deviceConnected == true) {
    tf = millis();
    td = float( (tf - ti)/1000.0 );
    ti = tf;
    
    for (int i = 0; i < 4; ++i) {
      q0[i] += 0.001*i;
      q1[i] += 0.001*(i+4);
      q2[i] += 0.001*(i+8);
      q3[i] += 0.001*(i+12);

      if (q0[i] >= 1.) { q0[i] = -1.; }
      if (q1[i] >= 1.) { q1[i] = -1.; }
      if (q2[i] >= 1.) { q2[i] = -1.; }
      if (q3[i] >= 1.) { q3[i] = -1.; }
    }

    String str0 = "";

    str0 += floatToHexString(td);
    
    for (int i = 0; i < 4; ++i) {
      str0 += floatToHexString(q0[i]);
      str0 += floatToHexString(q1[i]);
      str0 += floatToHexString(q2[i]);
      str0 += floatToHexString(q3[i]);
    }

    str0.toCharArray(quat0Data, 137);

    // update the characteristic values
    pCharacteristic0->setValue(quat0Data);
    pCharacteristic0->notify();

//    Serial.println("ESP32 is connected to the app... Sending Data!");
    delay(10); // delay not required
  }
}

union {
  float fval;
  byte barr[];
} fb;

String floatToHexString(float f) {
  fb.fval = f;
  String s = "";
  int val = 0;
  
  for (int i = 0; i < 4; ++i) {
      val = fb.barr[3-i];
      if (val < 16) {
        s += "0";
      }
      s += String(val, HEX);
    }
    return s;
}
