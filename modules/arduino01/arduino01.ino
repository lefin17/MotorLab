/*
2017-01-26
M - motor drive 
L - linear hydraulic driver
P - pump station
 */

const int MsIn = A0;  // Analog input pin that the potentiometer is attached to
const int LsIn = A1; 
const int PsIn = A2;

const int Pp1In = A3; //pressure after the pump
const int Pp2In = A4; //pressure before the pump

//constants for driver motors
const int Mout1 = 9; 
const int Mout2 = 10; 

const int Pout1 = 11; 
const int Pout2 = 6;

const int Lout1 = 3; //check PWM possible connection
const int Lout2 = 5; 

String inputString;

int Ls = 0;        // value of voltage from rotate sensor
int Ps = 0;        // value read from the pot
int Ms = 0;        // value output to the PWM (analog out)
int Pp1 = 0; //value of the pressure sensor after the pump
int Pp2 = 0; //value of the pressure sensor before the pump

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
  pinMode(Mout1, OUTPUT);
  pinMode(Mout2, OUTPUT);
  pinMode(Lout1, OUTPUT);
  pinMode(Lout2, OUTPUT);
  pinMode(Pout2, OUTPUT);
  pinMode(Pout2, OUTPUT);
  inputString = "";
//  check if connection started in terminal mode
}

String out(int value)
  {
    String res = String(value);
    int ln = res.length();
    for(int i = ln; i<4; i++) res = "0" + res;
    return res;
  }
  
void loop() {
  // read the analog in value:
  Ls = analogRead(LsIn);
delay(2);  
  Ps = analogRead(PsIn);   
delay(2);
  Ms = analogRead(MsIn);
  
 //       Serial.println('Fhelp');
 // Serial.println("A0"+out(Ms));   

 // Serial.println("A1"+out(Ls));

//  Serial.println("A2"+out(Ps));
    
  delay(2);                     
}

void serialEvent() {
  char command[6];
  char dev;
  int value;
  boolean stringComplete;
  
 // Serial.println("Fhello");
  while (Serial.available()) {
    stringComplete = false;
    // get the new byte:
    char inChar = (char)Serial.read();
    // add it to the inputString:
    if (inChar!='\n') inputString += inChar;
    if (inputString.length()>10) inputString = "";
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      stringComplete = true;
    }

    if (stringComplete)
      {
        // inputString = trim(inputString);

        if (inputString.length()<2) continue;
        if (inputString.length()>6) continue;
           //    
   
        //command recognizer 
        inputString.toCharArray(command, 6);
        inputString = "";
        DirectControl(command);
      }
  }
}

void DirectControl(char command[6])
  {
  char dev;
  int value;
        dev = command[0];
        value = String(command[2]).toInt()*100 + String(command[3]).toInt()*10 + String(command[4]).toInt();
  
  
  if (value>254) return; 
  if (value<0) return;
        if (dev == 'M' && command[1] =='U')
           { analogWrite(Mout2, LOW); delay(2); analogWrite(Mout1, value); }
        if (dev == 'M' && command[1] == 'D')    
           { analogWrite(Mout1, LOW); delay(2);  analogWrite(Mout2, value); }
        if (dev == 'L' && command[1] == 'U')
          { analogWrite(Lout2, LOW);  delay(2); analogWrite(Lout1, value); }
        if (dev == 'L' && command[1] == 'D')
          { analogWrite(Lout1, LOW);  delay(2); analogWrite(Lout2, value); }
        if (dev == 'P' && command[1] == 'U')
          { analogWrite(Pout2, LOW);  delay(2); analogWrite(Pout1, value); }
        if (dev == 'P' && command[1] == 'D')
          { analogWrite(Pout1, LOW);  delay(2); analogWrite(Pout2, value); }  
        Serial.println("F-"+String(value));   
    // Serial.println("FV"+value);
  }
