enum SliderIndex{
  RED(0,"SRed","R"), GREEN(1,"SGreen","G"), BLUE(2,"SBlue","B"), 
  HUE(3,"SHue","H"), SATURATION(4,"SSaturation","S"), BRIGHTNESS(5,"Sbrightness","B");
  int idx;
  String name,displayName;
  SliderIndex(int i, String _name, String _dispName){
    idx=i;
    name=_name;
    displayName = _dispName;
  }
  int index(){return idx;}
  String getName(){return name;}
  String getDisplayName(){return displayName;}
}
      
Slider[] sliders;

void setupGUI(ControlP5 cp5, Rectangle dimensions){
  sliders = new Slider[6];
  int barWidth = (int)(dimensions.width * .9);
  int barHeight = dimensions.height / 7;
  
  int i;
  for(SliderIndex s : SliderIndex.values()){
    i = s.index();
    sliders[i] = cp5.addSlider (s.getName())
     .setLabel (s.getDisplayName())
     .setPosition ( (dimensions.width-barWidth)/2 + dimensions.x, 
     barHeight*i + (i>2?barHeight:0) + dimensions.y)
     .setSize (barWidth, (int)(barHeight*.9))
     .setRange (0f,1f)
     //.setLock (s==SliderIndex.SATURATION?true:false)
     .setValue (1f)
   ;
  }
}

void sliderEvent(SliderIndex si, float val){
  if (si==null) return;
   //println (si.getName()+":",sliders[si.index()].getValue());
}

void SRed(float theColor) {
  sliderEvent (SliderIndex.RED, theColor);
}

void SGreen(float theColor) {
  sliderEvent (SliderIndex.GREEN, theColor);
}

void SBlue(float theColor) {
  sliderEvent (SliderIndex.BLUE, theColor);
}

void wheelByHSB(){
  float h = sliders[SliderIndex.HUE.index()].getValue(),
        s = sliders[SliderIndex.SATURATION.index()].getValue(),
        b = sliders[SliderIndex.BRIGHTNESS.index()].getValue();
  //println(h,s,b);
  wheel.setSampleHSB (h,s,b);
}

void SHue(float theColor) {
  sliderEvent (SliderIndex.HUE, theColor);
  wheelByHSB();
}

void SSaturation(float theColor) {
  sliderEvent (SliderIndex.SATURATION, theColor);
  wheelByHSB();
}

void Sbrightness(float val) {
  sliderEvent (SliderIndex.BRIGHTNESS, val);
  wheelByHSB();
}

void setSlider(SliderIndex si, float val){
  sliders[si.index()].setValue(val);
}

void updateGUISlidersRGB (float r, float g, float b){//, float h, float s, float br
  setSlider (SliderIndex.RED, r);
  setSlider (SliderIndex.GREEN, g);
  setSlider (SliderIndex.BLUE, b);
  float[] hsb = wheel.colorTmp;
  Color.RGBtoHSB(int(r*255), int(g*255), int(b*255), hsb);
  setSlider (SliderIndex.HUE, hsb[0]);
  setSlider (SliderIndex.SATURATION, hsb[1]);
  setSlider (SliderIndex.BRIGHTNESS, hsb[2]);
  
  println(r,g,b);
  println(hsb[0], hsb[1], hsb[2]);
}