class Btn {
   
int rectX, rectY;      // Position of square button
int rectWidth = 90;     // Diameter of rect
int rectHeight = 90;
color rectColor, baseColor;
color rectHighlight;
color currentColor;
boolean rectOver = false;
String wrd; //word over the button
boolean pressed = false; 


Btn(int x, int y, int w, int h, String word)
  {
     rectX = x;
     rectY = y;
     rectWidth = w;
     rectHeight = h;
    
     rectColor = color(0);
     rectHighlight = color(51);
     baseColor = color(102);
     currentColor = baseColor;
     wrd = word;
}

void draw() {
  update(mouseX, mouseY);

  
  if (rectOver) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX, rectY, rectWidth, rectHeight);
  fill(255);
  textAlign(LEFT);
  text(wrd, (rectX+2),(rectHeight+rectY)-2);
}

void update(int x, int y) {
 if ( overRect(rectX, rectY, rectWidth, rectHeight) ) {
    rectOver = true;
  } else {
   rectOver = false;
  }
}

boolean mousePressed() {

    return rectOver;
  }


boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

 } //end class