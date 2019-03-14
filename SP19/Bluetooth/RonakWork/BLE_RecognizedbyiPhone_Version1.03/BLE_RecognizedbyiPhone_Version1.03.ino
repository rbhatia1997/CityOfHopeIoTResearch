/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleServer.cpp
    Based on the Arduino ESP32 Port by Evandro Copercini & Chegewara
    General changes & adaptation for iOS by Ronak Bhatia & Darien Joso from City of Hope's HMC Clinic
    Last Date Updated: Sunday, March 13, 2019
*/

// The following are libraries necessary for enabling BLE connection
// They are in-built into the ESP-32 Library and wouldn't need one to manually install.

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <iostream>
#include <string>
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

BLECharacteristic *pCharacteristic; // define global variable - characteristic
bool deviceConnected = false;

// Values pre-defined for representing Quaternion.
float q0 = 0;
float q1 = 1;
float q2 = 2;
float q3 = 3;

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

// Important to note that normally one would set up a UUID_TX and UUID_RX
// However, because we only want to transmit data not receive any from the iPhone,
// we just need one Characteristic UUID for TX, which we call Characteristic UUID.

#define SERVICE_UUID        "2f391f0f-1c30-46fb-a972-a22c2f7570ee"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

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

  BLEDevice::init("ESP32_Bluetooth_Testing"); // designating this as a test.
  BLEServer *pServer = BLEDevice::createServer(); // creates server

  pServer->setCallbacks(new MyServerCallbacks());

  Serial.println("Creating a BLE Server...");


  // Create BLE service using the service UUID.
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Add characteristics...
  // PROPERTY_WRITE, PROPERTY_NOTIFY, PROPERTY_WRITE are the properties of the characteristics.

  // We need these lines to identify which property to ascribe to which characteristic.

  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_NOTIFY
                    );

  pCharacteristic->addDescriptor(new BLE2902());

  // Start the BLE Service
  pService->start();

  // Code that starts advertising the information
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);

  // Functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x06);
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! ESP32 Waiting to Send Data...");
}

void loop() {
  if (deviceConnected == true) {

    Serial.println("ESP32 is connected to the app... Sending Data!");

    // It's necessary to update the values sent to the iPhone here.
    // In other words, Quaternion values sent to the ESP32 pin will be updated here.

    // My understanding, as of now, is that we will have Quaternion values constantly update.
    // Quaternion values are just floats arranged in an array. We will have four to represent four IMU data.

    union {
      float Q0;
      char bytes[4];
    } quatVal;

    quatVal.Q0 = 0.69;
    for (int i = 0; i < 4; i++) {
      Serial.printf("byte %d is %02x", i, quatVal.bytes[i]);
    }

//    byte messageString[20];
////    byte Q0[4];
////    byte Q1[4];
////    byte Q2[4];
////    byte Q3[4];
//
//    byte *Q0, *Q1, *Q2, *Q3;
//
//    Q0 = (byte*)& q0;
//    Q1 = (byte*)& q1;
//    Q2 = (byte*)& q2;
//    Q3 = (byte*)& q3;
//
//    messageString[0] = Q0[0];
//    messageString[1] = Q0[1];
//    messageString[2] = Q0[2];
//    messageString[3] = Q0[3];
//    messageString[4] = Q1[0];
//    messageString[5] = Q1[1];
//    messageString[6] = Q1[2];
//    messageString[7] = Q1[3];
//    messageString[8] = Q2[0];
//    messageString[9] = Q2[1];
//    messageString[10] = Q2[2];
//    messageString[11] = Q2[3];
//    messageString[12] = Q3[0];
//    messageString[13] = Q3[1];
//    messageString[14] = Q3[2];
//    messageString[15] = Q3[3];
//    
//    Serial.println("Char array: ");
//    //Serial.println(messageString);
//    Serial.print("floats: ");
//    Serial.print(q0);
//    Serial.print(", ");
//    Serial.print(q1);
//    Serial.print(", ");
//    Serial.print(q2);
//    Serial.print(", ");
//    Serial.println(q3);
    

    //sprintf(messageString, "%s,%s,%s,%s", q0, q1, q2, q3);

    //
    //    char q0String[5];
    //    char q1String[5];
    //    char q2String[5];
    //    char q3String[5];
    //
    //    dtostrf(q0, 1, 2, q0String);
    //    dtostrf(q1, 1, 2, q1String);
    //    dtostrf(q2, 1, 2, q2String);
    //    dtostrf(q3, 1, 2, q3String);
    //
    //    char messageString[20];
    //    sprintf(messageString, "%s,%s,%s,%s", q0, q1, q2, q3);

   // pCharacteristic->setValue(messageString);

    // Sends the values to the iPhone application
    pCharacteristic->notify();

    // Faking Quaternion Data
    q0 = q0 + 1.00;
    q1 = q1 + 1.00;
    q2 = q2 + 1.00;
    q3 = q3 + 1.00;

    // Serial Printing the Values for Testing Purposes
    Serial.print("*** Current Value: ");
    //Serial.print(messageString);
    Serial.println(" ***");

    // This is currently the fastest rate we can get the app to read data, 0.5 Hz.
    delay(2000);
  }
}
