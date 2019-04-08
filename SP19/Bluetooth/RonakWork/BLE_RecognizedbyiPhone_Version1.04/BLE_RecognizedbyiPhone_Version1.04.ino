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

// Values pre-defined for representing Quaternion 1.

float quat[] = {0.000, 0.000, 0.000, 0.000};

int myInt_Q1_1 = 1;
int myInt_Q1_2 = 2;
int myInt_Q1_3 = 3;
int myInt_Q1_4 = 4;

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

  // Initializing the BLE Service

  BLEDevice::init("City of Hope BLE Testing");
  BLEServer *pServer = BLEDevice::createServer();

  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  Serial.println("Creating BLE Server & Callback Function Success");

  // Definiting the BLE Characteristics w/ Notify Properties

  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ |
                      BLECharacteristic::PROPERTY_NOTIFY
                    );

  pCharacteristic2 = pService->createCharacteristic(
                       CHARACTERISTIC_UUID2,
                       BLECharacteristic::PROPERTY_READ |
                       BLECharacteristic::PROPERTY_NOTIFY
                     );

  pCharacteristic3 = pService->createCharacteristic(
                       CHARACTERISTIC_UUID3,
                       BLECharacteristic::PROPERTY_READ |
                       BLECharacteristic::PROPERTY_NOTIFY
                     );


  pCharacteristic4 = pService->createCharacteristic(
                       CHARACTERISTIC_UUID4,
                       BLECharacteristic::PROPERTY_READ |
                       BLECharacteristic::PROPERTY_NOTIFY
                     );

  // Adding BLE descriptors

  pCharacteristic->addDescriptor(new BLE2902());
  pCharacteristic2->addDescriptor(new BLE2902());
  pCharacteristic3->addDescriptor(new BLE2902());
  pCharacteristic4->addDescriptor(new BLE2902());

  // Starting the BLE service and Giving BLE Start-up Message

  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  Serial.println("Characteristics defined! Waiting for BLE Connection...");
}

void loop() {
  if (deviceConnected == true) {

    Serial.println("ESP32 is connected to the app... Sending Data!");

    // It's necessary to update the values sent to the iPhone here.
    // In other words, Quaternion values sent to the ESP32 pin will be updated here.

    // My understanding, as of now, is that we will have Quaternion values constantly update.
    // Quaternion values are just floats arranged in an array. We will have four to represent four IMU data.
    // UPDATE: This will be four integers instead of a byte Array with floats for speed & ease of use.

    char q1DataString[20];
    char q2DataString[20];
    char q3DataString[20];
    char q4DataString[20];

    sprintf(q1DataString, "%d,%d,%d,%d", myInt_Q1_1, myInt_Q1_2, myInt_Q1_3, myInt_Q1_4);

    sprintf(q2DataString, "%d,%d,%d,%d", myInt_Q2_1, myInt_Q2_2, myInt_Q2_3, myInt_Q2_4);

    sprintf(q3DataString, "%d,%d,%d,%d", myInt_Q3_1, myInt_Q3_2, myInt_Q3_3, myInt_Q3_4);

    sprintf(q4DataString, "%d,%d,%d,%d", myInt_Q4_1, myInt_Q4_2, myInt_Q4_3, myInt_Q4_4);

    // Sending the Data to the iPhone 

    pCharacteristic->setValue(q1DataString);
    pCharacteristic->notify();

    pCharacteristic2->setValue(q2DataString);
    pCharacteristic2->notify();

    pCharacteristic3->setValue(q3DataString);
    pCharacteristic3->notify();

    pCharacteristic4->setValue(q4DataString);
    pCharacteristic4->notify();

    // Updating the Fake Data. 

    myInt_Q1_1++;
    myInt_Q1_2++;
    myInt_Q1_3++;
    myInt_Q1_4++;

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

    // We don't need delay at all - real-time data transfer is complete. 
    delay(10);
  }
}
