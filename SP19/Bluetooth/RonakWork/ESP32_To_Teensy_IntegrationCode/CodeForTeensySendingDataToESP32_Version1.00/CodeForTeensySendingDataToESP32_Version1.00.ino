void setup() {
  Serial2.begin(9600);
  Serial.begin(9600); //the screen
}

void loop() {
  Serial.println("Hi Ronak... sending data..");
  //int bytesSent = Serial2.write("hello \n"); //send the string "hello" and return the length of the string.
  float i = 0;
  while (i < 10)
  {
    i += 1.1;
    Serial2.write(float(i));
    //Serial2.write("numbers\n");
  }
  delay(1000);
}
