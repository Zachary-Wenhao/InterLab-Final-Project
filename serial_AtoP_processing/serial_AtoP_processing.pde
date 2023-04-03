// IMA NYU Shanghai
// Interaction Lab
// For receiving multiple values from Arduino to Processing

/*
 * Based on the readStringUntil() example by Tom Igoe
 * https://processing.org/reference/libraries/serial/Serial_readStringUntil_.html
 */

import processing.serial.*;
PImage boy;
PImage vaccine;
PImage virus;
PImage food;
PImage flash;

int NUM_OF_VALUES_FROM_ARDUINO = 4;   /** YOU MUST CHANGE THIS ACCORDING TO YOUR PROJECT **/
int sensorValues[];  /** this array stores values from Arduino **/


String myString = null;
Serial myPort;


//Game GUI Setting
int gameScreen = 0;

//
//  Timer
int begin;
int duration = 40;
int time = 40;
int start_timer = 0;

// This is BALL 1
// Green Escaping Ball!
int rad = 40;        // Width of the shape
float xpos,ypos,lastx,lasty;   // Starting position of shape    


// This is the BALL 2!
// Red catching ball
//
int rad2 = 40;        // Width of the shape
float xpos2, ypos2,lastx2,lasty2;   // Starting position of shape   


//shield
float shieldx, shieldy;
int shieldtaken = 1;
int shieldon = 1;
int shielddraw = 0;
int protection = 0;
void setup() {
  fullScreen();
  noStroke();
  ellipseMode(RADIUS);
  // Set the starting position of the shape
  
  //
     xpos = 100;
     ypos = 100;
     xpos2 = 400;
     xpos2 = 400;
     
  boy = loadImage("boy.png");
  virus = loadImage("virus.png");
  vaccine = loadImage("vaccine.png");
  food = loadImage("food.png");
  flash = loadImage("flash.png");
  setupSerial();
  
}

void draw() {
  getSerialData();
  printArray(sensorValues);

  // use the values like this!
  // sensorValues[0] 

  // add your code
  //
  //----------------Setting for Screens-------------
  if (gameScreen == 0){
     initScreen();
  } else if (gameScreen == 1){
    gameScreen();
  } else if (gameScreen == 2){
     VirusWinScreen();
  } else if (gameScreen == 3){
     BoyWinScreen();
  }
}
  
 /**********Screen contents**********/ 
  
void initScreen() {
  // codes of initial screen
  background(255,255);
  textSize(150);
  text("Click to Start!",width/5,height/2);
  fill(0,408,612,204);
}
void gameScreen() {
  // codes of game screen
  xpos = sensorValues[0]*1.2;
  ypos = sensorValues[1];
  xpos2 = sensorValues[2]*1.2;
  ypos2 = sensorValues[3];
  background(255,255,255);
  if (start_timer == 0){
     //Timer
     begin = millis();
     start_timer = 1;
  }
  timer();
  //
  moving();
  if (frameCount > 180){
  shielddisplay();}
   if (frameCount > 180){
   collision();
   }
}
void VirusWinScreen() {
  // codes for game over screen
  background(102);
  image(boy,lastx,lasty,boy.height/3,boy.width/2);
  image(virus,lastx2,lasty2,virus.height/4,virus.width/4);
  textSize(180);
  text("Virus Win!",width/4.5,height/2);
  fill(0,408,612,204);
}

void BoyWinScreen() {
  // code for game over screen
  background(102);
  image(boy,lastx,lasty,boy.height/3,boy.width/2);
  image(virus,lastx2,lasty2,virus.height/4,virus.width/4);
  textSize(180);
  text("Boy Win!",width/4.5,height/2);
  fill(0,408,612,204);
}
//
//-------------------Timer-----------------------------
//
void timer(){
if (time > 0){
   time = duration - (millis()-begin)/1000;
   text(time, width/1.9,80);
} else{
   gameScreen = 3;
}

}
//
//------------shield------------------------------
//
void shielddisplay(){
    hit_shield();
    shield_draw();
  if (shieldon == 1){
      changeshield();
    shield();
   }
}

void changeshield(){
if (shieldtaken == 1){
  
  shieldx = random(-100,width/1.2);
  shieldy = random(0,height/1.2);
  }
}
void shield(){
   fill(198,198,32);
   //circle(shieldx,shieldy,20);
   image(vaccine,shieldx,shieldy,vaccine.height/8,vaccine.width/9);
   shieldtaken = 0;
}  

//
//---------------hit shield----------------------------------------------------
//
void hit_shield(){
     if(dist(xpos,ypos,shieldx,shieldy) <= (rad+100)){
          shieldon =0;
          shielddraw = 1;
     }
}

void shield_draw(){
    if (shielddraw != 0){
        stroke(234,234,45);
        strokeWeight(20);
        noFill();
        image(boy,xpos,ypos,boy.height/3,boy.width/2);
        ellipse(xpos+45,ypos+45,70,70);
        shielddraw += 1;
        if (shielddraw > 100) {
       shieldtaken = 1;
       shielddraw = 0;
       shieldon = 1;
    }
    }        
}

//
//-----------Moving-------------------------------------------------------
//
void moving(){
  // Update the position of the shape
  // Ball 1
  image(boy,xpos,ypos,boy.height/3,boy.width/2);
  // Ball 2
  image(virus,xpos2,ypos2,virus.height/4,virus.width/4);
}
//
//--------------colllision----------------------------------------------------

void collision()
{ if (shielddraw == 0){
  if (dist(xpos,ypos,xpos2,ypos2) <= 2*rad){
  gameScreen = 2;
  lastx = xpos;
  lasty = ypos;
  lastx2 = xpos2;
  lasty2 = ypos2;
  }
}
}

/**************INPUTS***************/
public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (gameScreen==0) {
    startGame();
  }
 
}
/********* OTHER FUNCTIONS *********/

// This method sets the necessary variables to start the game  
void startGame() {
  gameScreen=1;
}

void setupSerial() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[ 0 ], 9600);
  // WARNING!
  // You will definitely get an error here.
  // Change the PORT_INDEX to 0 and try running it again.
  // And then, check the list of the ports,
  // find the port "/dev/cu.usbmodem----" or "/dev/tty.usbmodem----" 
  // and replace PORT_INDEX above with the index number of the port.

  myPort.clear();
  // Throw out the first reading,
  // in case we started reading in the middle of a string from the sender.
  myString = myPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
  myString = null;

  sensorValues = new int[NUM_OF_VALUES_FROM_ARDUINO];
}

void getSerialData() {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil( 10 ); // 10 = '\n'  Linefeed in ASCII
    if (myString != null) {
      String[] serialInArray = split(trim(myString), ",");
      if (serialInArray.length == NUM_OF_VALUES_FROM_ARDUINO) {
        for (int i=0; i<serialInArray.length; i++) {
          sensorValues[i] = int(serialInArray[i]);
        }
      }
    }
  }
}
