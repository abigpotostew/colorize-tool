/*
  By Stewart Bracken, 2016
  See LICENCE.txt or LICENSE.md for licensing information
*/
import controlP5.*;
import java.awt.Color;

ColorWheel w;
final int WIDTH = 200;

ControlP5 cp5;
float brightnessSlider = 1f;

final static float COLOR_MAX = 1.0f;

color mouseColor = 0;

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
}

public void draw(){
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
  
  fill(mouseColor);
  rect(WIDTH *1.4, 100, 100,100);
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

void slider(float theColor) {
  w.setBrightness(theColor);
  println("a slider event. setting background to "+theColor);
}