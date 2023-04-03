// IMA NYU Shanghai
// Interaction Lab
// For sending multiple values from Arduino to Processing

#define joyX A0
#define joyY A1
#define joyM A4
#define joyN A5
int sensor1, sensor2, sensor3, sensor4;
//// variables will change:
//int buttonState1 = 0;         // variable for reading the pushbutton status
//int buttonState2 = 0;         // variable for reading the pushbutton status
//int buttonState3 = 0;         // variable for reading the pushbutton status
//int buttonState4 = 0;         // variable for reading the pushbutton status
//int buttonState5 = 0;         // variable for reading the pushbutton status
//int buttonState6 = 0;         // variable for reading the pushbutton status
//const int buttonPin1 = 2;     // the number of the pushbutton pin
//const int buttonPin2 = 3;     // the number of the pushbutton pin
//const int buttonPin3 = 4;     // the number of the pushbutton pin
//const int buttonPin4 = 8;     // the number of the pushbutton pin
//const int buttonPin5 = 9;     // the number of the pushbutton pin
//const int buttonPin6 = 10;     // the number of the pushbutton pin
//int sensor1, sensor2, sensor3,sensor4, sensor5, sensor6;
void setup() {
  Serial.begin(9600);
  // initialize the pushbutton pin as an input:
//  pinMode(buttonPin1, INPUT);
//  pinMode(buttonPin2, INPUT);
//  pinMode(buttonPin3, INPUT);
//  pinMode(buttonPin4, INPUT);
//  pinMode(buttonPin5, INPUT);
//  pinMode(buttonPin6, INPUT);
}

void loop() {
  // to send values to Processing assign the values you want to send
  //this is an example
  
  
  sensor1 = map(analogRead(joyX),0,1023,0,1390);
  sensor2 = map(analogRead(joyY),0,1023,0,940);
  sensor3 = map(analogRead(joyM),0,1023,0,1000);
  sensor4 = map(analogRead(joyN),0,1023,0,800);
//  int sensor3 = 0;
//  int sensor4 = 0;
//  int sensor5 = 0;
//  int sensor6 = 0;
//  buttonState1 = digitalRead(buttonPin1);
//  buttonState2 = digitalRead(buttonPin2);
//  buttonState3 = digitalRead(buttonPin3);
//  buttonState4 = digitalRead(buttonPin4);
//  buttonState5 = digitalRead(buttonPin5);
//  buttonState6 = digitalRead(buttonPin6);
////  int sensor1 = buttonState1;
////  int sensor2 = buttonState2;
//  if (buttonState1 == HIGH){
//    sensor1 = 1;
//    }
//   
//  if (buttonState2 == HIGH){
//    sensor2 = 1;
//    }
//   if (buttonState3 == HIGH){
//    sensor3 = 1;
//    }
//   if (buttonState4 == HIGH){
//    sensor4 = 1;
//    }
//   
//  if (buttonState5 == HIGH){
//    sensor5 = 1;
//    }
//   if (buttonState6 == HIGH){
//    sensor6 = 1;
//    }


 
  
  // send the values keeping this format
  Serial.print(sensor1);
  Serial.print(",");  // put comma between sensor values
  Serial.print(sensor2);
  Serial.print(",");  // put comma between sensor values
  Serial.print(sensor3);
  Serial.print(",");  // put comma between sensor values
  Serial.print(sensor4);
//  Serial.print(",");  // put comma between sensor values
//  Serial.print(sensor5);
//  Serial.print(",");  // put comma between sensor values
//  Serial.print(sensor6);
  Serial.println(); // add linefeed after sending the last sensor value

  // too fast communication might cause some latency in Processing
  // this delay resolves the issue.
  delay(100);

  // end of example sending values
}
