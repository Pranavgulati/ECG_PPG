
import processing.serial.*;

Serial myPort;        // The serial port
int xPos1 = 1;         // horizontal position of the graph 
int xPos2= 1; 
//Variables to draw a continuous line.
int lastxPos1=1;
int lastheight1=0;
int lastxPos2=1;
int lastheight2=0;
PrintWriter output;

void setup () {
  // set the window size:
  size(650, 400);        
  output = createWriter("datalog.txt");
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
void keyPressed(){
if(key==' '){
output.flush();
output.close();
exit();
    }
}
float frequency=0;
int time =second();
long counter=0;
void serialEvent (Serial myPort) {
  if (second()-time>=1) {
    frequency=counter;
    println(frequency);
    counter=0;
    output.flush();// Writes the remaining data to the file every second
    time=second();
  }
  // get the ASCII string:
  try {
    String inString = myPort.readStringUntil('\n');
    output.print(inString);    
   if (inString != null) {
      counter++;
      byte inByte1h = ((byte)inString.charAt(0));
      byte inByte1l = ((byte)inString.charAt(1)) ;
      byte inByte2h = ((byte)inString.charAt(3)) ;
      byte inByte2l = ((byte)inString.charAt(4)) ;
      int value1, value2;  
      value1=inByte1h&0xFF;
      value1=value1<<8;
      value1=value1|(inByte1l&0xFF);
      value2=inByte2h&0xFF;
      value2=value2<<8;
      value2=value2|(inByte2l&0xFF);
//        print(value1);
//        print(',');    // convert to a number.
//        println(value2) ;
//      print(inByte1h);
//      print(',');    // convert to a number.
//      print(inByte1l) ;
//      print(',');    
//      print(inByte2h);
//      print(',');    // convert to a number.
//      println(inByte2l) ;
      //print(inString);

       value1 = (int)map(value1, 0, 1024, 0, height); //map to the screen height.
       value2 = (int)map(value2, 0, 1024, 0, height); //map to the screen height.
      //Drawing a line from Last inByte to the new one.
      stroke(127, 34, 255);     //stroke color
      strokeWeight(1);        //stroke wider
      line(lastxPos1, lastheight1, xPos1, height- value1);
      stroke(34, 34, 127);     //stroke color
      line(lastxPos2, lastheight2, xPos2, height- value2);  
      lastxPos1= xPos1;
      lastheight1= height-value1;
      lastxPos2= xPos2;
      lastheight2= height-value2;

      // at the edge of the window, go back to the beginning:
      if (xPos1 >= width||xPos2>=width) {
        xPos1 = 0;
        lastxPos1= 0;
        xPos2 = 0;
        lastxPos2= 0;
        background(255);  //Clear the screen.
      } else {
        // increment the horizontal position:
        xPos1+=1; 
        xPos2+=1;
      }
    }
  }
  catch(Exception e) {
    println("Error parsing:");
    e.printStackTrace();
  }
}

