/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleServer.cpp
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

// Defining the TX/RX pins for UART Serial Communication between Microcontrollers.
#define RXD2 16
#define TXD2 17

/*
 * To provide more information on the specific wiring, we will be using the TX2 and RX2 pins on the Teensy microcontroller. This will be different for the
 * Teensy 3.6 versus the 3.2 and may need to be changed. The TX2 pin of the Teensy connects to the RX pin of the ESP32 and the RX2 pin of the Teensy connects 
 * to the TX pin of the ESP32. The GPIO pin 7 of the ESP32 will connect to the RTS pin on the Teensy (pin 22 on the Teensy 3.2). The GPIO6 pin on the ESP32 will 
 * connect to the CTS pin on the Teensy (pin next to 22, so 21 - it's arbitrary). 
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

// We are using Four characteristics to represent the Four Quaternions from the Four IMUs.

BLECharacteristic* pCharacteristic0 = NULL; // define global variable - characteristic
BLECharacteristic* pCharacteristic1 = NULL; // define global variable - characteristic
BLECharacteristic* pCharacteristic2 = NULL; // define global variable - characteristic
BLECharacteristic* pCharacteristic3 = NULL; // define global variable - characteristic

bool deviceConnected = false;

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

// quaternion hex strings
char quat0Data[33] = "";
char quat1Data[33] = "";
char quat2Data[33] = "";
char quat3Data[33] = "";

void setup() {
  Serial.begin(115200); // this BAUD rate is set intentionally
  // Note the format for setting a serial port is as follows: Serial2.begin(baud-rate, protocol, RX pin, TX pin);
  // Serial2 is the transmission protocol used between the Teensy and the ESP32.
  Serial2.begin(250000, SERIAL_8N1, RXD2, TXD2);
  // Prints the Pins for the ESP32 for the TX/RX in case you forget.
  Serial.println("Serial Txd is on pin: " + String(TXD2));
  Serial.println("Serial Rxd is on pin: " + String(RXD2));
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

    Serial.print(byte(Serial2.read()));
    Serial.println("Hi Ronak... the Teensy-ESP32 Stuff is working");

    for (int i = 0; i < 4; ++i) {
      // fake data
      q0[i] += 0.001;
      q1[i] += 0.005;
      q2[i] += 0.010;
      q3[i] += 0.050;

      // data must be contained between 1 and -1
      if (q0[i] >= 1.) {
        q0[i] = -1.;
      }
      if (q1[i] >= 1.) {
        q1[i] = -1.;
      }
      if (q2[i] >= 1.) {
        q2[i] = -1.;
      }
      if (q3[i] >= 1.) {
        q3[i] = -1.;
      }
    }

    String str0 = "";
    String str1 = "";
    String str2 = "";
    String str3 = "";

    for (int i = 0; i < 4; ++i) {
      str0 += floatToHexString(q0[i]);
      str1 += floatToHexString(q1[i]);
      str2 += floatToHexString(q2[i]);
      str3 += floatToHexString(q3[i]);
    }

    Serial.print(q0[0]);
    Serial.print(" ");
    Serial.print(q0[1]);
    Serial.print(" ");
    Serial.print(q0[2]);
    Serial.print(" ");
    Serial.print(q0[3]);
    Serial.print("\n");
    Serial.print(str0);

    str0.toCharArray(quat0Data, 33);
    str1.toCharArray(quat1Data, 33);
    str2.toCharArray(quat2Data, 33);
    str3.toCharArray(quat3Data, 33);

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
    delay(200); // delay not required
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
    val = fb.barr[3 - i];
    if (val < 16) {
      s += "0";
    }
    s += String(val, HEX);
  }
  return s;
}


