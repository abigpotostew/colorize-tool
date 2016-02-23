/*
  By Stewart Bracken, 2016
  See LICENCE.txt or LICENSE.md for licensing information
*/
import controlP5.*;
import java.awt.Color;

import java.awt.Canvas;

ColorWheel w;
final int WIDTH = 200;

ControlP5 cp5;
float brightnessSlider = 1f;

final static float COLOR_MAX = 1.0f;

color mouseColor = 0;
color otherMouseColor = 0;

ScreenCapture scap;

int timer, ptime;

public void setup(){
  size(800,400);
  w=new ColorWheel(WIDTH,WIDTH);
  colorMode(RGB,COLOR_MAX);
  
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("brightnessSlider")
   .setPosition(WIDTH + .1*WIDTH,WIDTH*.1)
   .setSize(20,(int)(WIDTH*.8))
   .setRange(0,1)
   //.setNumberOfTickMarks(5)
   ;
   
   scap = new ScreenCapture();
   timer = 0;
   ptime = 0;
}

public void draw(){
  int cur_time = millis();
  timer += cur_time - ptime;
  ptime = cur_time;
  
  background(0,0,0);
  
    cursor();
  if (mousePressed){
    float v = (1f*mouseX/width);
    //w.setBrightness(v);
  }
  
  
  
  w.setBrightness(brightnessSlider);
  w.draw();
  //println(v);
  
  if(mousePressed){
    mouseEvent();
  }
  
  stroke(1);
  fill(mouseColor);
  rect(WIDTH *1.5, 100, 100,100);
  
  stroke(1);
  fill(otherMouseColor);
  rect(WIDTH *.25, WIDTH*1.2, 100,100);
  
  if (timer>1000){
    //captureColorAtPosition(mouseX,mouseY);
    timer = 0;
  }
}

void mouseEvent(){
  if(w.inBounds(mouseX,mouseY)){
    noCursor();
    mouseColor = get(mouseX,mouseY);
    fill(1);
    stroke(0);
    rect(mouseX,mouseY,3,3);
  }else{
  }
}

void keyReleased(){
  
    if(key=='c'){
      captureColorAtPosition (mouseX,mouseY);
  //java.awt.Point pt = ((PSurfaceAWT)surface).getLocationOnScreen();
    }
}

void captureColorAtPosition(int x, int y){
  otherMouseColor = scap.captureScreenColor ((Canvas)surface.getNative(), x,y);
  println("rgb:",red(otherMouseColor),green(otherMouseColor), blue(otherMouseColor),'\n');
}

void slider(float theColor) {
  w.setBrightness(theColor);
  println("a slider event. setting background to "+theColor);
}