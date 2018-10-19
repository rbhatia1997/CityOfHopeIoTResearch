# CityOfHopeIoTResearch
This is a public repository for learning about coding &amp; front-end/back-end development for the City of Hope Clinic. Currently, we have the ability to visualize sensor data from the MPU6050 6-dof IMU. The following are instructions on how to use the code:

1) First, install [Processing Version 2.2.1]("https://processing.org/download/"). I recommend version 2.2.1 as we haven't tested for other versions. Additionally, we haven't figured out how to get around the I2C library/clock issues when using this on the MKR1000.

2) You're going to want to open the .pde file (called TeaPot) in Processing - in order to visualize the data. Don't do anything yet. 

3) Make sure that the MPU6050 library and the toxiclibs zip-file is installed in the libraries folder of Processing in order for it to work. Additionally, you will want the MPU6050 library to be installed in your Arduino sketchbook. The folder to put your libraries in should be under Users/UserName/Documents/Processing/libraries. Additionally, the folder to put your libraries in for Arduino is  Users/UserName/Documents/Arduino/libraries.

4) Open the Arduino (.ino) file and run it for the microprocessor. Make sure the serial monitor is closed otherwise it will give issues. If you want to see the specific numerical values (instead of strange characters) for the Yaw, Pitch, Roll, or accelerations, then you should uncomment those in the .ino file (e.g. uncomment //#define OUTPUT_YAWPITCHROLL if you want to see that data). 

5) Run the code called MPU6050_Test and make sure the serial monitor is closed. Then, you're going to want to run your .pde file inside Processing 2. Make sure that in Processing, in the .pde file, that your serial port is properly identified (e.g. /cu.usbmodem/401435). 

6) The data should be showing up as a visualization in real-time. 

