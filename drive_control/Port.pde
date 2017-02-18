 class Port  {
  String name;
  int value;
  int oldvalue; 
  int type; //0 - value command, float to int transfer
            //1 - string command - change functionality to controller
            

  Port(String portName, int portType)
    {
        name = portName;
        type = portType;
    }
    
  void update()
    {
       if (type==0) writeValue();
    }
    
  void writeValue()
    {
      String Direction = "";
      String command = "";
      String strValue = "";
      if (value!=oldvalue)
        {
           Direction = (value>=0) ? "U" : "D"; //Up & Down
             strValue = str(abs(value));  
             while(strValue.length()<3) strValue = "0" + strValue; 
             command = name + Direction + strValue + '\n';
             oldvalue = value;
             commonCommand = command; //send to display
             myPort.write(command); // send cannel name, direction and value */
        }
    }
}