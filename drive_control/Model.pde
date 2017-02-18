class Model
  {
int mode=0; // process mode (swiching by button)
float[] in; //numeric in
int[] oldout; //old value on out position which send to controller
Port[] out;

    Model()
     {
       in = new float[3];
       out = new Port[3];
       for(int i = 0; i<3; i++) in[i] = 0; //start condition
       out[0] = new Port("M", 0);
       out[1] = new Port("L", 0);
       out[2] = new Port("P", 0);
     }
    
    void simple() 
      {
        for(int i=0; i<3; i++) out[i].value = round(in[i]);
      }
      
    void update()
      {
       switch(mode)
         {
           case 0: simple();
                   for(int i = 0; i<3; i++) out[i].update();
                   break;
         }
      }

    void changeMode()
      {
         mode = (mode == 0) ? 1 : 0;
      }
    void draw()
       {
           update();
           fill(0);
           text(mode+"--",50,100);
       }
 
  }// end Model class