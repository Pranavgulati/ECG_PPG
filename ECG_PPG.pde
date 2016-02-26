
import processing.serial.*;

Serial myPort;        // The serial port
int xPos1 = 1;         // horizontal position of the graph 
int xPos2= 1; 
//Variables to draw a continuous line.
int lastxPos1=1;
int lastheight1=0;
int lastxPos2=1;
int lastheight2=0;

void setup () {
  // set the window size:
  size(600, 400);        

  // List all the available serial ports
  println(Serial.list());
  // Check the listed serial ports in your machine
  // and use the correct index number in Serial.list()[].
  myPort = new Serial(this, Serial.list()[0], 115200);  //

  // A serialEvent() is generated when a newline character is received :
  myPort.bufferUntil('\n');
  background(255);      // set inital background:
}
void draw () {
  // everything happens in the serialEvent()
}
boolean valid(String test){
int index=test.indexOf((char)9);
//print("index=");println(index);
if(index==-1){return false;}
else {
  index=test.indexOf((char)9,index+1);
  if(index==-1){return true;}
  else{return false;}
  }

}
float frequency=0;
int time =second();
long counter=0;
void serialEvent (Serial myPort) {
  if(second()-time==1){
    frequency=counter;
    println(frequency);
    counter=0;
  time=second();}
  // get the ASCII string:
  try{String inString = myPort.readStringUntil('\n');
  if (inString != null) {counter++;
    String first=inString.substring(0,inString.indexOf(','));                // trim off whitespaces.
    byte temp = (byte)first.charAt(0) ;   
    int inByte1 = (int)temp+127;
 print(first);print(" =");  print(inByte1);print(',');    // convert to a number.
    String second=inString.substring(inString.indexOf(',')+1,inString.indexOf('\n')); 
     temp=(byte)second.charAt(0) ;   
    int inByte2 = (int)temp+127;         // convert to a number.
  print(second);print(" =");  println(inByte2) ;
 // println(inString);
    inByte1 = (int)map(inByte1, 0, 255, 0, height); //map to the screen height.
    inByte2 = (int)map(inByte2, 0, 255, 0, height); //map to the screen height.
    //Drawing a line from Last inByte to the new one.
    stroke(127,34,255);     //stroke color
    strokeWeight(1);        //stroke wider
    line(lastxPos1, lastheight1, xPos1,height- inByte1);
    stroke(34,34,127);     //stroke color
    line(lastxPos2, lastheight2, xPos2, height- inByte2);  
    lastxPos1= xPos1;
    lastheight1= height-inByte1;
    lastxPos2= xPos2;
    lastheight2= height-inByte2;

    // at the edge of the window, go back to the beginning:
    if (xPos1 >= width||xPos2>=width) {
      xPos1 = 0;
      lastxPos1= 0;
      xPos2 = 0;
      lastxPos2= 0;
     background(255);  //Clear the screen.
    } 
    else {
      // increment the horizontal position:
      xPos1++;
      xPos2++;
    }
  }
}
catch(Exception e){
println("Error parsing:");
        e.printStackTrace();
}
}
