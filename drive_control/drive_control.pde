import processing.serial.*;

HScrollbar hs1, hs2, hs3;  // Three scrollbars
Graph g; // object with graph of input values; (whole width)
Param[] prm; //object with params to show, record calculate
String commonCommand; 
Serial myPort;
//possible to update scroll bar only when needed.. (only if last value not equal current one)
// 2017-01-26 
//http://pastebin.com/kSrU3nVH - here graph can be taken
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
  
  hs1 = new HScrollbar(0, height/2-8, width, 16, 16, true, 255, 'L');
  hs2 = new HScrollbar(0, height/2+8, width, 16, 16, true, 255, 'M');
  hs3 = new HScrollbar(0, height/2+24, width, 16,16, true, 255, 'P');
  int yMin_g = round(height/2+30);
  g = new Graph(yMin_g, height, color(0), color(255), false, 1024); //new graph   
  
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
 
  hs1.update();
  hs2.update();
  hs3.update();
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
}

class Graph {
  int position;
  int w, h; //width
  int yMin, yMax; 
  int hColor, bColor; // headline & background color
  boolean simetrical;
  int maxValue; 
  
  Graph(int yMn, int yMx, color hClr, color bClr, boolean sim, int mV)
    {
      w = width;
      position = 0;
      h = yMx - yMn; //height of 
      yMin = yMn;
      yMax = yMx; 
      hColor = hClr; //
      bColor = bClr;
      simetrical = sim;
      maxValue = mV;
    }
    
    void display()
      {  
        if (position > w) position = 0;
         stroke(hColor);
         line(position+1, yMin, position+1, yMax);
         stroke(bColor); 
         line(position, yMin, position, yMax);
         position++; 
      }
      
     int getY(float value)
     {
       int res;
       if (maxValue == 0) return 0;
       if (simetrical) 
         {
            res = round((yMin+yMax)/2 - value*(yMax-yMin)/2/maxValue);
         }
         else
            res = round(yMax-value*(yMax-yMin)/maxValue);
         return res;
     }
} //end class Graph

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos, oldpos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  boolean simetrical; //simetrical about central axis or from min to max
  int maxValue; //maximum value
  float ratio;
  char channelName;

  HScrollbar (float xp, float yp, int sw, int sh, int l, boolean s, int mV, char name) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    oldpos = newspos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
    maxValue = mV;
    simetrical = s;
    channelName = name;
  }

  void update() {
    String command = "";
    String  strValue = "";
    String Direction = "";
    int tmp;
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
 
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
    else spos = newspos;
    //serial send 
         if (oldpos != spos) 
          {  
             tmp = getValue();
             Direction = (tmp>=0) ? "U" : "D"; 
             strValue = str(abs(tmp));
             while(strValue.length()<3) strValue = "0" + strValue; 
             command = str(channelName) + Direction + strValue + '\n';
             commonCommand = command; //send to display
             myPort.write(command); // send cannel name, direction and value
             oldpos = spos;
          }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }
  
  int getValue() {
    int res = 0;
    float v = getPos();
    if (simetrical) { res = round(-maxValue + v*2*maxValue/(sposMax-sposMin+sheight)); }
    else res  = round(v*maxValue/(sposMax-sposMin+sheight));
    return res;
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}