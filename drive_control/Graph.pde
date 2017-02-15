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