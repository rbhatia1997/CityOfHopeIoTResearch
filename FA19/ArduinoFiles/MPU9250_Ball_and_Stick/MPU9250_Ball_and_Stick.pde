import processing.serial.*;

Serial myPort;
String readSerial;
String strInput[];
float rot[] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};

void setup(){
  //println(Serial.list());
  myPort = new Serial(this, "/dev/cu.usbserial-AK061JXA", 38400);
  
  size(750, 500);
  background(255);
}

void draw(){
  if (myPort.available() > 0){
    readSerial = myPort.readStringUntil('\n');
  }
  
  if (readSerial != null){
    strInput = readSerial.split("\t");
    
    for (int i = 0; i < 6; i++){
      rot[i] = float(strInput[i]);
      println(rot[i]);
    }
  }
  
  background(255);
  
  translate(width/2, height/2);
  rotate(rot[2] * PI/180);
 
  noFill();
  stroke(180);
  strokeWeight(1);
  
  int rectWidth = 40;
  int rectHeight = 140;
  rect(-rectWidth/2, -rectWidth/2, rectWidth, rectHeight, rectWidth/2);
  
  stroke(150);
  arc(0, rectHeight - rectWidth, 80, 80, (90 + rot[2] + rot[5]) * PI/180, PI*3/2 );
  textSize(12);
  fill(0, 102, 153);
  float t = 180 - rot[5] - rot[2];
  text(Float.toString(t), -100, rectHeight - rectWidth);
  
  translate(0, rectHeight - rectWidth);
  rotate(rot[5] * PI/180);
  
  noFill();
  stroke(200);
  strokeWeight(0.5);
  
  rect(-rectWidth/2, -rectWidth/2, rectWidth, rectHeight, rectWidth/2);
  
  
  
}
