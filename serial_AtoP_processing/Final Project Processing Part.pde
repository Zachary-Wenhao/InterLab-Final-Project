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
PImage flash;
PImage food;
int NUM_OF_VALUES_FROM_ARDUINO = 6;   /** YOU MUST CHANGE THIS ACCORDING TO YOUR PROJECT **/
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
float xpos, ypos;   // Starting position of shape    
float xspeed = 4;  // Speed of the shape
float yspeed = 3;  // Speed of the shape
int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom
int left=0;
int cout_left = 3;
int right = 0;
int cout_right = 3;
int change_direction = 0;

// This is the BALL 2!
// Red catching ball
//
int rad2 = 40;        // Width of the shape
float xpos2, ypos2;   // Starting position of shape   
float xspeed2 = 4;  // Speed of the shape
float yspeed2 = 3;  // Speed of the shape
int xdirection2 = 1;  // Left or Right
int ydirection2 = 1;  // Top to Bottom
int left2=0;
int cout_left2 = 3;
int right2 = 0;
int cout_right2 = 3;
int change_direction2= 0;

//shield
float shieldx;
float shieldy;
int shieldon = 1;
int shielddraw = 0;
int protection = 0;

// Speeder
float speederx;
float speedery;  
int speederon = 1;
int speederdraw = 0;

void setup() {
  fullScreen();
  noStroke();
  frameRate(50);
  ellipseMode(RADIUS);
  // Set the starting position of the shape
  
  //
  xpos = width/8;
  ypos = height/6;
  xpos2 = width/1.2;
  ypos2 = height/1.2;
  shieldx = random(0,width/1.2);
  shieldy = random(0,height/1.2);
  speederx = random(0,width/1.2);
  speedery = random(0,height/1.2); 
  boy = loadImage("boy.png");
  virus = loadImage("virus.png");
  vaccine = loadImage("vaccine.png");
  flash = loadImage("flash.png");
  food = loadImage("food.png");
  setupSerial();
  
}

void draw() {
  getSerialData();
  printArray(sensorValues);

  // use the values like this!
  // sensorValues[0] 

  // add your code
  //
  //----------------Setting for Screens---------------------------------------------------------
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
  background(102);
  textSize(150);
  text("Click to Start!",width/5,height/2);
  fill(0,408,612,204);
  textSize(40);
  //text("Rule: \nThe virus player must catch the boy player within time limit. \nThe boy player could pick up the props that randomly appear on the \nscreen to escape from the virus.", 200, height/1.5);
  fill(0,408,612,204);
}
void gameScreen() {
  // codes of game screen
  left = sensorValues[0];
  right = sensorValues[1];
  change_direction = sensorValues[2];
  left2 = sensorValues[3];
  right2 = sensorValues[4];
  change_direction2 = sensorValues[5];
  println("This is speederdraw:"+str(speederdraw));
 
  background(102);
  if (start_timer == 0){
     //Timer
     begin = millis();
     start_timer = 1;
  }
  timer();
  moving();
  if (frameCount >= 300){
  shielddisplay();
  }
  if (frameCount >= 1000){
  speederdisplay();
  }
  collision();
}
void VirusWinScreen() {
  // codes for game over screen
  background(102);
  textSize(180);
  text("Virus Win!",width/5,height/2);
  fill(0,408,612,204);
}
void BoyWinScreen() {
  // codes for game over screen
  background(102);
  textSize(180);
  text("Boy Win!",width/5,height/2);
  fill(0,408,612,204);
}
  
//
//-------------------Timer----------------------------------
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
//------------shield--------------------------------------------------------------------------
//
void shielddisplay(){
    hit_shield();
    shield_draw();
  if (shieldon == 1){
    shield();
   
}
}
void shield(){
   fill(198,198,32);
   //circle(shieldx,shieldy,20);
   image(vaccine,shieldx,shieldy,vaccine.height/8,vaccine.width/9);
  
}  
void hit_shield(){
     if(dist(xpos,ypos,shieldx,shieldy) <= (rad+100)){
          shieldon = 0;
          shielddraw = 1;
     }
}
void shield_draw(){
    if (shielddraw != 0){
        stroke(234,234,45);
        strokeWeight(20);
        noFill();
         //if (speederdraw != 0){
         //image(flash,xpos,ypos,flash.height/3,flash.width/2);
         //} else{
         //image(boy,xpos,ypos,boy.height/3,boy.width/2);
         //}
        ellipse(xpos+45,ypos+45,70,70);
        protection = 1;
        if (shielddraw > 200) {
       shielddraw = 0;
       protection = 0;
       } else{
       shielddraw += 1;
       }  
    }    
    
}

//
//------------------Speeder------------------------------------------------------------------------------------------------
//
void speederdisplay (){
     if (speederon == 1){
         speeder();
     }
      hit_speeder();
}
void speeder(){
     fill(198,198,32);
     //circle(speederx,speedery,20);
     image(food,speederx,speedery,food.height,food.width/2);
     
}
void hit_speeder(){
     if(dist(xpos,ypos,speederx,speedery) <= (rad+40)){
          speederon =0;
          speederdraw = 1;
          speederx = 1000000;
          speedery = 1000000;
        }
         if (speederdraw > 200) {
          speederdraw = 0;
         } else{
          speederdraw += 1;
         }
       
}

//
//-----------Moving------------------------------------------------------------------------
//
void moving(){
  // Update the position of the shape
  // Ball 1
  if (speederdraw != 0){
  xspeed = 7;
  yspeed = 6;
  }
  if(left == 1){
  
  xpos = xpos + ( (xspeed+cout_left) * xdirection );
  ypos = ypos + ( yspeed  * ydirection )/2;
  }
  if (right == 1){
  xpos = xpos + ( xspeed * xdirection )/2;
  ypos = ypos + ( (yspeed+cout_right)  * ydirection );
  }
  if (left ==0 && right == 0){
  xpos = xpos + ( xspeed * xdirection );
  ypos = ypos + ( yspeed  * ydirection );
  }
  if (change_direction == 1){
  xdirection *= -1;
  ydirection *= -1;
  }
  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reve`rad || xpos < rad) {
    //xdirection *= -1;
  //}
  if (ypos > height-rad || ypos < rad) {
    ydirection *= -1;
  }
  // Draw the shape
  fill(255);
  noStroke();
  //ellipse(xpos, ypos, rad, rad);
  if (speederdraw != 0){
  image(flash,xpos,ypos,flash.height/3,flash.width/2);
  } else{
  image(boy,xpos,ypos,boy.height/3,boy.width/2);
  }
  
  // Ball 2
  if(left2 == 1){
    print("left2 works");
  xpos2 = xpos2 + ( (xspeed2+cout_left2) * xdirection2 );
  ypos2 = ypos2 + ( yspeed2  * ydirection2 )/2;
  }
  if (right2 == 1){
    print("right2 works");
  xpos2 = xpos2 + ( xspeed2 * xdirection2 )/2;
  ypos2 = ypos2 + ( (yspeed2+cout_right2)  * ydirection2 );
  }
  if (left2 ==0 && right2 == 0){
  xpos2 = xpos2 + ( xspeed2 * xdirection2 );
  ypos2 = ypos2 + ( yspeed2  * ydirection2 );
  }
  if (change_direction2 == 1){
  xdirection2 *= -1;
  ydirection2 *= -1;
  }
  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1
  if (xpos2 > width-rad2|| xpos2 < rad2) {
    xdirection2 *= -1;
  }
  if (ypos2 > height-rad2 || ypos2 < rad2) {
    ydirection2 *= -1;
  }
  // Draw the shape
  //fill(255,0,134);
  //noStroke();
  //ellipse(xpos2, ypos2, rad2, rad2);
  image(virus,xpos2,ypos2,virus.height/4,virus.width/4);
 
}
//
//--------------colllision---------------------------------------------------------------------------------
//

void collision()
{ if (protection == 0){
  if (dist(xpos,ypos,xpos2,ypos2) <= (2*rad)+10){
  gameScreen = 2;
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
