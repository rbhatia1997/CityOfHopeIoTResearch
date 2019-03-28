/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleServer.cpp
    Based on the Arduino ESP32 Port by Evandro Copercini & Chegewara
    General changes & adaptation for iOS by Ronak Bhatia & Darien Joso from City of Hope's HMC Clinic
    Last Date Updated: Sunday, March 27, 2019
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

/*
   The BLE Peripheral is typically the board you are programming. It connects the BLE central to
   expose its characteristics. In our case, the iPhone is the BLE central, which is the device that
   asks the BLE peripheral its data. That's why we won't be using a BLECentral constructor.
   Characteristics contain at least two attributes: (1) characteristic declaration, which has metadata
   about the data, and (2) the characteristic value, which contains the data itself.
   Characteristics have names, UUIDs, values, and read/write/notify properties. There are many types
   of characteristics constructors depending on the data type wanting to be used.
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

BLEServer* pServer = NULL; // null instance of BLE Server
BLEService *pService = NULL;

// We are using Four characteristics to represent the Four Quaternions from the Four IMUs.

BLECharacteristic* pCharacteristic0 = NULL; // define global variable - characteristic
BLECharacteristic* pCharacteristic1 = NULL; // define global variable - characteristic
BLECharacteristic* pCharacteristic2 = NULL; // define global variable - characteristic
BLECharacteristic* pCharacteristic3 = NULL; // define global variable - characteristic

bool deviceConnected = false;

 /*
 See the following for generating UUIDs:
 https://www.uuidgenerator.net/

 Important to note that normally one would set up a UUID_TX and UUID_RX
 However, because we only want to transmit data not receive any from the iPhone,
 we just need one Characteristic UUID for TX, which we call Characteristic UUID.
 */

#define SERVICE_UUID         "2f391f0f-1c30-46fb-a972-a22c2f7570ee"
#define CHARACTERISTIC_UUID0 "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID1 "beb5484e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID2 "beb5485e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID3 "beb5486e-36e1-4688-b7f5-ea07361b26a8"

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

char quat0Arr[6] = ""; // format is -1.111 (space for plus or minus, ones, decimal point, then 3 after decimal)
char quat1Arr[6] = ""; // value is contained within -1 and 1
char quat2Arr[6] = "";
char quat3Arr[6] = "";

char quat0Data[24] = "";
char quat1Data[24] = "";
char quat2Data[24] = "";
char quat3Data[24] = "";

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
  pCharacteristic1 = pService->createCharacteristic(CHARACTERISTIC_UUID1,
                       BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);
  pCharacteristic2 = pService->createCharacteristic(CHARACTERISTIC_UUID2,
                       BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);
  pCharacteristic3 = pService->createCharacteristic(CHARACTERISTIC_UUID3,
                       BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);

  // add descriptors to characteristics
  pCharacteristic0->addDescriptor(new BLE2902());
  pCharacteristic1->addDescriptor(new BLE2902());
  pCharacteristic2->addDescriptor(new BLE2902());
  pCharacteristic3->addDescriptor(new BLE2902());

  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  
  Serial.println("Characteristic defined!");
}

void loop() {
  if (deviceConnected == true) {
     /*
     It's necessary to update the values sent to the iPhone here.
     In other words, Quaternion values sent to the ESP32 pin will be updated here.

     My understanding, as of now, is that we will have Quaternion values constantly update.
     Quaternion values are just floats arranged in an array. We will have four to represent four IMU data.
     UPDATE: This will be four integers instead of a byte Array with floats for speed & ease of use.
     */

    for (int i = 0; i < 4; ++i) {
      dtostrf(q0[i], 6, 3, quat0Arr); // convert float into string (char array)
      strcat(quat0Data, quat0Arr); // add string (char array) to the larger data string (char array)
      
      dtostrf(q1[i], 6, 3, quat1Arr);
      strcat(quat1Data, quat1Arr);
      
      dtostrf(q2[i], 6, 3, quat2Arr);
      strcat(quat2Data, quat2Arr);
      
      dtostrf(q3[i], 6, 3, quat3Arr);
      strcat(quat3Data, quat3Arr);

      // fake data
      q0[i] += 0.001;
      q1[i] += 0.005;
      q2[i] += 0.010;
      q3[i] += 0.050;

      // data must be contained between 1 and -1
      if (q0[i] >= 1.) { q0[i] = -1.; }
      if (q1[i] >= 1.) { q1[i] = -1.; }
      if (q2[i] >= 1.) { q2[i] = -1.; }
      if (q3[i] >= 1.) { q3[i] = -1.; }
    }

    // update the characteristic values
    pCharacteristic0->setValue(quat0Data);
    pCharacteristic0->notify();

    pCharacteristic1->setValue(quat1Data);
    pCharacteristic1->notify();

    pCharacteristic2->setValue(quat2Data);
    pCharacteristic2->notify();

    pCharacteristic3->setValue(quat3Data);
    pCharacteristic3->notify();

    Serial.println("ESP32 is connected to the app... Sending Data!");
    delay(0); // delay not required
  }
}
