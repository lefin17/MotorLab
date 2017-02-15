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
             Direction = (tmp>=0) ? "U" : "D"; //Up & Down
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
    res = (simetrical) ? round(-maxValue + v*2*maxValue/(sposMax-sposMin+sheight)) : 
                         round(v*maxValue/(sposMax-sposMin+sheight)); // not simmetrical
    return res;
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}