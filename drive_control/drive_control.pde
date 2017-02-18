import processing.serial.*;
Btn b; //small button
Model M;
HScrollbar hs1, hs2, hs3;  // Three scrollbars
Graph g; // object with graph of input values; (whole width)
Param[] prm; //object with params to show, record calculate
String commonCommand; 
Serial myPort;

PFont f;

int lf = 13;      // ASCII linefeed 
//int lf = 10;
String inString;  //communication in string...

void setup() {
  size(640, 360);
  f = createFont("Arial",16,true); 
  noStroke();
  noSmooth();
  background(255);
  commonCommand = "";
  inString = "";
  prm = new Param[3];
  M = new Model();
  b = new Btn(5, 5, 30, 20, "Start"); //inicialize button 
  hs1 = new HScrollbar(0, height/2-8, width, 16, 16, true, 255, 'L');
  hs2 = new HScrollbar(0, height/2+8, width, 16, 16, true, 255, 'M');
  hs3 = new HScrollbar(0, height/2+24, width, 16,16, true, 255, 'P');
  // int yMin_g = round();
  g = new Graph(height/2+30, height, color(0), color(255), false, 1024); //new graph   
  
  prm[0] = new Param("Pump", color(255, 0, 0));
  prm[1] = new Param("Linear", color(0, 255, 0));
  prm[2] = new Param("Motor", color(0, 0, 255)); 
  
 printArray(Serial.list());

// Open the port you are using at the rate you want:
   myPort = new Serial(this, Serial.list()[0], 9600);
   myPort.bufferUntil(lf); 
}

void serialEvent(Serial p) {
  //getting command from Arduino (feedBack, value of sensors, buttons events)
  String s = p.readString();
  s = trim(s);
  
  inString = "";
  inString = s;
  // println(s);
  switch(s.charAt(0))
    {
      case 'A': //read analog signal from sensors line
        if (s.length()!=6) return;
        int channel = int(str(s.charAt(1)));
        float value = float(str(s.charAt(2)))*1000 + float(str(s.charAt(3)))*100 + float(str(s.charAt(4)))*10 + float(str(s.charAt(5)));
        if (channel<3) prm[channel].putValue(value); //put Value from sensor to model vars.
    //    inString = str(value);
        break;
      case 'F': //read analog signal from sensors line
        // if (s.length()!=6) return;
        // int channel = int(str(s.charAt(1)));
        // float value = float(str(s.charAt(2)))*1000 + float(str(s.charAt(3)))*100 + float(str(s.charAt(4)))*10 + float(str(s.charAt(5)));
        // if (channel<3) prm[channel].putValue(value); //put Value from sensor to model vars.
        inString = "Feed Back "+s;
        break;
    }
} 

void draw() {

  fill(255);
  // by logic we need to change param of model param, not send direct command
    M.in[0] = hs1.update(); // out(cmd); //commands from three scrollbar will be send to controller
    M.in[1] = hs2.update();         
    M.in[2] = hs3.update();      
   M.update();
  hs1.display();
  hs2.display();
  hs3.display();
 
 /* prm[0].putValue(hs1.getValue()); //graph controlled by horisontal scroll bar
  prm[1].putValue(hs2.getValue());
  prm[2].putValue(hs3.getValue()); */
  g.display();
  
  for(int i = 0; i<3; i++) //three points of it...
      { stroke(prm[i].clr);
        point(g.position-1, g.getY(prm[i].value)); }
      
  textAlign(CENTER);
  stroke(255); //text with values - replace after update
  fill(255);
  rect(0, 40, width, 120);
  fill(0);
  // text(hs1.getValue(),width/2,60);
  text(commonCommand, width/2,60);
  text(inString, width/2,80);
  text(hs3.getValue(),width/2,100);
  stroke(0);
  line(0, height/2, width, height/2);
  line(0, height/2+16, width, height/2+16);
  b.draw();
  M.draw();
}



class Param {
  String name;
  float value;
  color clr; 
  
  
  Param(String N, color C)
     {
       name = N;
       clr = C;
       }
 
 void putValue(float v)
   {
     value = v;
   }
} //end class Param


void mousePressed()
{
  //buttons actions
  if (b.mousePressed()) M.changeMode();
} 

  