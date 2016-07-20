
import processing.serial.*;

Serial myPort;        // The serial port
int xPos1 = 1;         // horizontal position of the graph 
int xPos2= 1; 
//Variables to draw a continuous line.
int lastxPos1=1;
int lastheight1=0;
int lastxPos2=1;
int lastheight2=0;
PrintWriter output,ECG,PPG;
float frequency=0;
int time =second();
long counter=0;
void setup () {
  // set the window size:
  size(1300, 400);        
  output = createWriter("datalog.dat");
  ECG = createWriter("ECG.dat");
  PPG = createWriter("PPG.dat");
 // List all the available serial ports
  println(Serial.list());
  // Check the listed serial ports in your machine
  // and use the correct index number in Serial.list()[].
  myPort = new Serial(this, Serial.list()[0], 57600);  //

  // A serialEvent() is generated when a newline character is received :
  myPort.bufferUntil('\n');
  background(255);      // set inital background:
}
void draw () {
  // everything happens in the serialEvent()
}
int isRun=1;
void keyPressed(){
if(key=='p'){
  if(isRun==0){isRun=1;}
  else{isRun=0;   myPort.clear();}
}
  else if(key==' '){
output.flush();
output.close();
ECG.flush();
ECG.close();
PPG.flush();
PPG.close();
exit();
    }
  
}
int signedConvert(int high, int low){
  //converts the 2 bytes of a signed 10bit number with the sign in the first bit
int temp=0;//used for conversion do not change 
temp=temp|high;
temp=temp<<8;
temp=temp|low;
if(temp>511){temp=temp-1024;}
return temp;

}

int unsignedConvert(int high, int low){
  //converts the 2 bytes of a signed 10bit number with the sign in the first bit
int temp=0;//used for conversion do not change 
temp=temp|high;
temp=temp<<8;
temp=temp|low;
return temp;
}
void serialEvent (Serial myPort) {
  if (second()-time>=1) { 
    frequency=counter;
    println(frequency);
    counter=0;
    output.flush();// Writes the remaining data to the file every second
    time=second();
  }
  // get the ASCII string:
 if(isRun==1) {
   try{
    String inString = myPort.readStringUntil('\n');
    output.println(inString);    
   if (inString != null) {
      counter++;
      int inByte1h = ((int)inString.charAt(0));
      int inByte1l = ((int)inString.charAt(1)) ;
      int inByte2h = ((int)inString.charAt(3)) ;
      int inByte2l = ((int)inString.charAt(4)) ;
      int value1, value2;  
      value1=signedConvert(inByte1h,inByte1l);
      value2=unsignedConvert(inByte2h,inByte2l);
      String ECGstring = nfp(value1,3 );
      String PPGstring = nfp(value2,4 );
//      println(ECGstring);
//      println(PPGstring);
       value1 = (int)map(value1, -512, 512, 0, height); //map to the screen height.
       value2 = (int)map(value2, 0, 1024, 0, height); //map to the screen height.
       ECG.println(ECGstring);
       PPG.println(PPGstring);
      //Drawing a line from Last inByte to the new one.
      strokeWeight(1);        //stroke wider
      stroke(127, 0, 255);     //stroke color
      line(lastxPos1, lastheight1, xPos1, (height- value1 + lastheight1)/2);
      
      strokeWeight(2);   
      stroke(255, 127, 255);     //stroke color
      line(lastxPos2, lastheight2, xPos2, (height- value2+ lastheight2)/2);  
//       point( xPos1, height- value1);
//       point( xPos2, height- value2);  
      lastxPos1= xPos1;
      lastheight1= (height-value1+ lastheight1)/2;
      lastxPos2= xPos2;
      lastheight2=( height-value2+ lastheight2)/2;

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
else{   myPort.clear();}
 }

