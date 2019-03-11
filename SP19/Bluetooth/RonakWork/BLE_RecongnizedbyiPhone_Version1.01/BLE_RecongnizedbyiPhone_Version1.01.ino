/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleServer.cpp
    Ported to Arduino ESP32 by Evandro Copercini
    updates by chegewara
*/

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <iostream>
#include <string>

BLECharacteristic *pCharacteristic;
bool deviceConnected = false;
int humidity = 0;
int temperature = 0;


// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "2f391f0f-1c30-46fb-a972-a22c2f7570ee"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

void setup() {
  Serial.begin(115200);
  Serial.println("Starting BLE work!");

  BLEDevice::init("ESP32_Bluetooth_Testing"); // designating this as a test.
  BLEServer *pServer = BLEDevice::createServer(); // creates server

  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_NOTIFY
                    );

  pCharacteristic->addDescriptor(new BLE2902());

  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE |
                                         BLECharacteristic::PROPERTY_NOTIFY
                                       );

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
  char humidityString[2];
  char temperatureString[2];

  humidity = humidity + 2;
  temperature = temperature + 10;

  dtostrf(humidity, 1, 2, humidityString);
  dtostrf(temperature, 1, 2, temperatureString);

  char dhtDataString[16];
  sprintf(dhtDataString, "%d,%d", temperature, humidity);

  pCharacteristic->setValue(dhtDataString);

  pCharacteristic->notify(); // Envia o valor para o aplicativo!
  Serial.print("*** Dado enviado: ");
  Serial.print(dhtDataString);
  Serial.println(" ***");
  delay(1000);
}
