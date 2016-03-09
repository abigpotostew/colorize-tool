/*
  By Stewart Bracken, 2016
  See LICENCE.txt or LICENSE.md for licensing information
*/
import controlP5.*;
import java.awt.Color;

import java.awt.Canvas;

ColorWheel wheel;
final int WIDTH = 350;

ControlP5 cp5;
float brightnessSlider = 1f;

final static float COLOR_MAX = 1.0f;

color mouseColor = 0;
color otherMouseColor = 0;

ScreenCapture scap;

int timer, ptime;
boolean colorWheelSelected;

public void setup(){
  size(800,400);
  wheel=new ColorWheel(WIDTH,WIDTH);
  colorMode(RGB,COLOR_MAX);
  
  
  cp5 = new ControlP5 (this);
  
  //cp5.addSlider ("brightnessSlider")
  // .setPosition (WIDTH + .1*WIDTH,WIDTH*.1)
  // .setSize (20,(int)(WIDTH*.8))
  // .setRange (0,1)
  // //.setNumberOfTickMarks(5)
  // ;
   
   setupGUI (cp5, new Rectangle (
     int(width/2), 
     int(height*.4),
     int(width*.45),
     int(height*.6)
     )
   );
   
   scap = new ScreenCapture();
   timer = 0;
   ptime = 0;
   
   mouseColor = wheel.lastSample();
}

public void draw(){
  int cur_time = millis();
  timer += cur_time - ptime;
  ptime = cur_time;
  
  background(0,0,0);
  
  
  //wheel.setBrightness(brightnessSlider);
  wheel.draw();
  //println(v);
  
  if(mousePressed){
    mouseDownEvent();
  }
  //draw rect at sample position
  PVector samPosition = wheel.lastSamplePosition();//w.sampleAt (mouseX,mouseY);
  mouseColor = wheel.lastSampleColor().rgb;
  //println(samPosition);
  fill(1);
  stroke(0);
  rect (samPosition.x,samPosition.y,4,4);
  
  stroke(1);
  fill(mouseColor);
  rect(WIDTH *1.15, WIDTH*.05, WIDTH*.3, WIDTH*.3);
  
  stroke(1);
  fill(otherMouseColor);
  rect(WIDTH *1.65, WIDTH*.05, WIDTH*.3, WIDTH*.3);
  
  if (timer>1000){
    //captureColorAtPosition(mouseX,mouseY);
    timer = 0;
  }
}

void mousePressed(){
  if (wheel.inBounds (mouseX, mouseY)){
    colorWheelSelected = true;
    noCursor();
    //println("pressed");
  }
}

void mouseDownEvent(){
  if (colorWheelSelected){
    mouseColor = wheel.sampleAt (mouseX, mouseY);
    
    updateGUISliders (wheel.lastSampleColor());
    
    //get(mouseX,mouseY);
    /*updateGUISlidersRGB(1f*(mouseColor >> 16 & 0xFF)/255, 
                     1f*(mouseColor >> 8 & 0xFF)/255,
                     1f*(mouseColor & 0xFF)/255);*/
     
    
    //fill(1);
    //stroke(0);
    //rect(mouseX,mouseY,3,3);
  //}else{
  //}
  }
}

void mouseReleased(){
  
    cursor();
    colorWheelSelected = false;
  //println("release");
}

void keyReleased(){
  
    if(key=='c'){
      captureColorAtPosition (mouseX,mouseY);
  //java.awt.Point pt = ((PSurfaceAWT)surface).getLocationOnScreen();
    }
}

void captureColorAtPosition(int x, int y){
  otherMouseColor = scap.captureScreenColor ((Canvas)surface.getNative(), x,y);
  //println("rgb:",red(otherMouseColor),green(otherMouseColor), blue(otherMouseColor),'\n');
} //<>//