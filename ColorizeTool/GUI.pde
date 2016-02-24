Slider sliderRed, sliderGreen, sliderBlue;
Slider sliderHue, sliderSat, sliderBright;
Slider[] sliders;

void setupGUI(ControlP5 cp5, Rectangle dimensions){
  sliders = new Slider[6];
  int barWidth = (int)(dimensions.width * .9);
  int barHeight = dimensions.height / 7;
  
  String[] names = {"red", "green", "blue", "hue", "saturation", "brightness"};
  
  for(int i=0; i<6; ++i){
    sliders[i] = cp5.addSlider (names[i])
   .setPosition ( (dimensions.width-barWidth)/2 + dimensions.x, 
     barHeight*i + (i>2?barHeight:0) + dimensions.y)
   .setSize (barWidth, (int)(barHeight*.9))
   .setRange (0,1)
   //.setNumberOfTickMarks(5)
   ;
  }
}