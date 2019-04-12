import processing.serial.*;

Serial myPort;
String readSerial;
String strInput[];
boolean serial = false;
boolean mouse = false;

float x,y,z,s;

float xpos = 0;
float ypos = 0;

void setup(){
  
  if (serial) {
    print(Serial.list()); // get a list of the serial ports
    //String portName = Serial.list()[7]; // connect to the correct port
  
    myPort = new Serial(this, "/dev/cu.usbmodem4014350", 9600);
  }
  
  size(900, 400, P3D);
  ortho();
  
  lights();
  //noFill();
  //directionalLight(128, 128, 128, 0, 0, 1);
  
  x = width/2;
  y = height/2;
  z = 0;
  s = 100; //scale the components
}

void draw(){
  
  float[] imu0 = new float[3];
  float[] imu1 = new float[3];
  float[] imu2 = new float[3];
  
  ////////////
  // Serial //
  ////////////
  
  if (serial) {
  
    // If the port is available, read in values
    if (myPort.available() > 0){
      readSerial = myPort.readStringUntil('\n');
    }
    
    // If the reading is a string of floats,
    // separate them by the tab spacing between them 
    if (readSerial != null){
      strInput = readSerial.split("\t");
      
      // Store the imu values in separate arrays
      for (int i = 0; i < 3; i++){
        imu0[i] = float(strInput[i]);
        imu1[i] = float(strInput[i+3]);
        imu2[i] = float(strInput[i+6]);
        //print(imu0[i]);
        //print(' ');
      }
    }
  
  } else {
    
    for (int i = 0; i < 3; i++){
        imu0[i] = 0;
        imu1[i] = 0;
        imu2[i] = 0;
      }
      
  }
  
  ///////////////////
  // Visualization //
  ///////////////////
  
  background(200); // refresh screen
  translate(x,y,z); //centered in the frame
  rotateX(-PI/12);
  rotateY(-PI/12);
  
  if (mouse) {
    float mouseRotX = (mouseX - x) / 300.0 * PI;
    float mouseRotY = (mouseY - y) / 300.0 * PI;
    
    xpos = mouseRotX;
    ypos = mouseRotY;
    
  }
  
  rotateX(-ypos);
  rotateY(xpos + PI);
  
  translate(0, -s*0.8, 0);
  coordinate(0, 0, 0, s);
  translate(0, s*0.8, 0);
  
  translate(0, height/6, 0);
  
  strokeWeight(1);
  stroke(0);
  drawIMU(imu0, s*1.0, s*0.25, s*1.5);
  
  translate(-s*2.5, 0, 0);
  strokeWeight(1);
  stroke(0);
  drawIMU(imu0, s*1.0, s*0.25, s*1.5);
  translate(s*2.5, 0, 0);
  
  translate(s*2.5, 0, 0);
  strokeWeight(1);
  stroke(0);
  drawIMU(imu0, s*1.0, s*0.25, s*1.5);
  translate(-s*2.5, 0, 0);
  
}

void drawIMU(float imu[], float w, float h, float d) {
  rotateX(imu[0]);
  rotateY(imu[1]);
  rotateZ(imu[2]);
  
  box(w, h, d);
  
  translate(0, -h/2, 0);
  coordinate(0, 0, 0, s*0.2);
  translate(0, h/2, 0);
  
  rotateX(-imu[0]);
  rotateY(-imu[1]);
  rotateZ(-imu[2]);
}

void coordinate(float x0, float y0, float z0, float s0, boolean lbl) {
  
  translate(x0, y0, z0);
  
  strokeWeight(1);
  textSize(16);
  
  stroke(255, 0, 0); //red
  line(0, 0, 0, s0, 0, 0); // X axis
  
  stroke(0, 255, 0); //green
  line(0, 0, 0, 0, -s0, 0); // Y axis
  
  stroke(0, 0, 255); //blue
  line(0, 0, 0, 0, 0, s0); // Z axis
  
  if (lbl) {
    text("x", s0, 0, 0);
    text("y", 0, -s0, 0);
    text("z", 0, 0, s0);
  }
  
  translate(-x0, -y0, -z0);
  
}
