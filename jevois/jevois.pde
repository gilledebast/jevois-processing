/* ----------------------------------------------------------------------------------------------------
 * JeVois Processing, 2020
 * Created: 03/20/20 by Bastien DIDIER
 * 
 * Basic example to connect JeVois camera with processing and get data from the camera
 * http://www.jevois.org/
 *
 * ARUCO Marker (6X6) =  http://jevois.org/data/ArUco.zip
 *
 * Update: 03/20/20 Current V.1
 * ----------------------------------------------------------------------------------------------------
 */

import processing.serial.*;

Serial JeVois;  //The serial port
String port = "/dev/tty.usbmodem1423"; //Change accordingly with the port where JeVois camera is connected
int baudRate = 115200; //Default baudrate

void setup() {
  //printArray(Serial.list()); //List all the available serial ports
  
  //Open the serial port
  JeVois = new Serial(this, port, baudRate);
  
  //Write here the setup command you want for the JeVois
  // /!\ Don't forget to add at the end of the command a line break '\n'.
  //     JeVois camera is waiting for it before processing the command
  
  //Exemple to setup the Camera with the ARUCO program
  JeVois.write("setpar serout USB\n");
  JeVois.write("setmapping2 YUYV 320 240 30.0 JeVois DemoArUco\n");
  JeVois.write("streamon\n");
  
  //All available command to send to the JeVois camera are here : http://jevois.org/doc/UserCli.html
}

void draw() {
  // Expand array size to the number of bytes you expect
  byte[] inBuffer = new byte[99];
  while (JeVois.available() > 0) {
    inBuffer = JeVois.readBytes();
    JeVois.readBytes(inBuffer);
    if (inBuffer != null) {
      String data = new String(inBuffer);
      println(data);
      
      // /!\ Next we treat the data as they are formatted in the ARUCO Demo (N2 id x y w h)
      String[] cmd = split(data, '\n'); //if there is more than 1 marker in the camera view
      for(int i =0; i < cmd.length-1; i++){         
        //println("command = "+cmd[i]);
        
        String[] marker = split(cmd[i], ' ');
        if(marker.length > 1){
          int markerId = int(marker[1].substring(1));
          
          //Example marker =  http://jevois.org/data/ArUco.zip
          println("Detected marker = "+markerId);

          if(markerId == 12){
            println("Marker 12 detected");
          }
        }
      }
    }
  }
}