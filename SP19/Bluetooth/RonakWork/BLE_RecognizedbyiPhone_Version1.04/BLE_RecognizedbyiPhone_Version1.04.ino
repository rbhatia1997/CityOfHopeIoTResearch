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

BLECharacteristic* pCharacteristic = NULL; // define global variable - characteristic
BLECharacteristic* pCharacteristic2 = NULL; // define global variable - characteristic
BLECharacteristic* pCharacteristic3 = NULL; // define global variable - characteristic
BLECharacteristic* pCharacteristic4 = NULL; // define global variable - characteristic

bool deviceConnected = false;
bool oldDeviceConnected = false;

// Values pre-defined for representing Quaternion 1.
int myInt1 = 1;
int myInt2 = 2;
int myInt3 = 3;
int myInt4 = 4;

// Values pre-defined for representing Quaternion 2.

int myInt_Q2_1 = 5;
int myInt_Q2_2 = 6;
int myInt_Q2_3 = 7;
int myInt_Q2_4 = 8;

// Values pre-defined for representing Quaternion 3.

int myInt_Q3_1 = 9;
int myInt_Q3_2 = 10;
int myInt_Q3_3 = 11;
int myInt_Q3_4 = 12;

// Values pre-defined for representing Quaternion 4.

int myInt_Q4_1 = 13;
int myInt_Q4_2 = 14;
int myInt_Q4_3 = 15;
int myInt_Q4_4 = 16;

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

// Important to note that normally one would set up a UUID_TX and UUID_RX
// However, because we only want to transmit data not receive any from the iPhone,
// we just need one Characteristic UUID for TX, which we call Characteristic UUID.

#define SERVICE_UUID        "2f391f0f-1c30-46fb-a972-a22c2f7570ee"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID2 "beb5484e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID3 "beb5485e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID4 "beb5486e-36e1-4688-b7f5-ea07361b26a8"

// This is a callback function that handles the Bluetooth Connection status.
// If the device is recognized, have the ESP32 change its connection status.
// Because we aren't receiving data sent by a client, we don't include a
// Callback function for receiving data - which would be standard.

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

void setup() {
  Serial.begin(115200); // this BAUD rate is set intentionally
  Serial.println("Initialzing ESP32 as BLE Device...");
  //
  //BLEDevice::init("City of Hope Bluetooth Testing"); // designating this as a test.
  //
  //  // Create the BLE Server
  //  BLEServer *pServer = BLEDevice::createServer();
  //
  //  Serial.println("Creating a BLE Server...");
  //
  //  // Create BLE service using the service UUID.
  //  BLEService *pService = pServer->createService(SERVICE_UUID);
  //
  //  // Add characteristics...
  //  // PROPERTY_WRITE, PROPERTY_NOTIFY, PROPERTY_WRITE are the properties of the characteristics.
  //
  //  // We need these lines to identify which property to ascribe to which characteristic.
  //  // Creating multiple characteristics with the notify property, which enables communication to the iOS application.
  //
  //  pCharacteristic = pService->createCharacteristic(CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);
  ////  pCharacteristic2 = pService->createCharacteristic(CHARACTERISTIC_UUID2, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);
  ////  pCharacteristic3 = pService->createCharacteristic(CHARACTERISTIC_UUID3, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);
  ////  pCharacteristic4 = pService->createCharacteristic(CHARACTERISTIC_UUID4, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);
  //
  //  // This descriptor allows for information on the characteristics to accurately translate to the iOS application.
  //  pCharacteristic->addDescriptor(new BLE2902());
  ////  pCharacteristic2->addDescriptor(new BLE2902());
  ////  pCharacteristic3->addDescriptor(new BLE2902());
  ////  pCharacteristic4->addDescriptor(new BLE2902());
  //
  //  //Add callback
  //  pServer->setCallbacks(new MyServerCallbacks());
  //
  //  // Start the BLE Service
  //  pService->start();
  //  Serial.println("Service started");
  //
  //  // Code that starts advertising the information
  //  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  //  pAdvertising->addServiceUUID(SERVICE_UUID);
  //  pAdvertising->setScanResponse(true);
  //
  //  // Functions that help with iPhone connections issue
  //  pAdvertising->setMinPreferred(0x06);
  //  pAdvertising->setMinPreferred(0x12);
  //  BLEDevice::startAdvertising();
  //
  //  Serial.println("Characteristics defined! ESP32 Waiting to Send Data...");

  BLEDevice::init("City of Hope BLE Testing");
  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);
  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_NOTIFY
                                       );

  BLECharacteristic *pCharacteristic2 = pService->createCharacteristic(
                                          CHARACTERISTIC_UUID2,
                                          BLECharacteristic::PROPERTY_READ |
                                          BLECharacteristic::PROPERTY_NOTIFY
                                        );

  BLECharacteristic *pCharacteristic3 = pService->createCharacteristic(
                                          CHARACTERISTIC_UUID3,
                                          BLECharacteristic::PROPERTY_READ |
                                          BLECharacteristic::PROPERTY_NOTIFY
                                        );


  BLECharacteristic *pCharacteristic4 = pService->createCharacteristic(
                                          CHARACTERISTIC_UUID4,
                                          BLECharacteristic::PROPERTY_READ |
                                          BLECharacteristic::PROPERTY_NOTIFY
                                        );

  pCharacteristic->addDescriptor(new BLE2902());
  pCharacteristic2->addDescriptor(new BLE2902());
  pCharacteristic3->addDescriptor(new BLE2902());
  pCharacteristic4->addDescriptor(new BLE2902());

  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");
}

void loop() {
  if (deviceConnected == true) {

    Serial.println("ESP32 is connected to the app... Sending Data!");

    // It's necessary to update the values sent to the iPhone here.
    // In other words, Quaternion values sent to the ESP32 pin will be updated here.

    // My understanding, as of now, is that we will have Quaternion values constantly update.
    // Quaternion values are just floats arranged in an array. We will have four to represent four IMU data.
    // UPDATE: This will be four integers instead of a byte Array with floats for speed & ease of use.

    char q1String[2];
    char q2String[2];
    char q3String[2];
    char q4String[2];

    char q1_Q2_String[2];
    char q2_Q2_String[2];
    char q3_Q2_String[2];
    char q4_Q2_String[2];

    char q1_Q3_String[2];
    char q2_Q3_String[2];
    char q3_Q3_String[2];
    char q4_Q3_String[2];

    char q1_Q4_String[2];
    char q2_Q4_String[2];
    char q3_Q4_String[2];
    char q4_Q4_String[2];

    char qDataString[20];
    char q2DataString[20];
    char q3DataString[20];
    char q4DataString[20];

    dtostrf(myInt1, 1, 2, q1String);
    dtostrf(myInt2, 1, 2, q2String);
    dtostrf(myInt3, 1, 2, q3String);
    dtostrf(myInt4, 1, 2, q4String);
    sprintf(qDataString, "%d,%d,%d,%d", myInt1, myInt2, myInt3, myInt4);

    //    dtostrf(myInt_Q2_1, 1, 2, q1_Q2_String);
    //    dtostrf(myInt_Q2_2, 1, 2, q2_Q2_String);
    //    dtostrf(myInt_Q2_3, 1, 2, q3_Q2_String);
    //    dtostrf(myInt_Q2_4, 1, 2, q4_Q2_String);
    //
    //    sprintf(q2DataString, "%d,%d,%d,%d", myInt_Q2_1, myInt_Q2_2, myInt_Q2_3, myInt_Q2_4);
    //
    //    dtostrf(myInt_Q3_1, 1, 2, q1_Q3_String);
    //    dtostrf(myInt_Q3_2, 1, 2, q2_Q3_String);
    //    dtostrf(myInt_Q3_3, 1, 2, q3_Q3_String);
    //    dtostrf(myInt_Q3_4, 1, 2, q4_Q3_String);
    //
    //    sprintf(q3DataString, "%d,%d,%d,%d", myInt_Q3_1, myInt_Q3_2, myInt_Q3_3, myInt_Q3_4);
    //
    //    dtostrf(myInt_Q4_1, 1, 2, q1_Q4_String);
    //    dtostrf(myInt_Q4_2, 1, 2, q2_Q4_String);
    //    dtostrf(myInt_Q4_3, 1, 2, q3_Q4_String);
    //    dtostrf(myInt_Q4_4, 1, 2, q4_Q4_String);
    //
    //    sprintf(q4DataString, "%d,%d,%d,%d", myInt_Q4_1, myInt_Q4_2, myInt_Q4_3, myInt_Q4_4);

    pCharacteristic->setValue(qDataString);
    pCharacteristic->notify();

    pCharacteristic2->setValue(qDataString);
    pCharacteristic2->notify();

    pCharacteristic3->setValue(qDataString);
    pCharacteristic3->notify();

    pCharacteristic4->setValue(qDataString);
    pCharacteristic4->notify();

    //    delay(10);
    //
    //    pCharacteristic2->setValue(q2DataString);
    //    pCharacteristic2->notify();
    //
    //    delay(10);
    //
    //    pCharacteristic3->setValue(q3DataString);
    //    pCharacteristic3->notify();
    //
    //    delay(10);
    //
    //    pCharacteristic4->setValue(q4DataString);
    //    pCharacteristic4->notify();
    //
    //    delay(10);

    myInt1++;
    myInt2++;
    myInt3++;
    myInt4++;

    myInt_Q2_1++;
    myInt_Q2_2++;
    myInt_Q2_3++;
    myInt_Q2_4++;

    myInt_Q3_1++;
    myInt_Q3_2++;
    myInt_Q3_3++;
    myInt_Q3_4++;

    myInt_Q4_1++;
    myInt_Q4_2++;
    myInt_Q4_3++;
    myInt_Q4_4++;

    // This is currently the fastest rate we can get the app to read data, 0.5 Hz.
    delay(2000);
  }
}
