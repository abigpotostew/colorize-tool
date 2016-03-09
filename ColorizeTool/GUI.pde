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
     .setBroadcast(false) //temporarily don't call slider events
     .setLabel (s.getDisplayName())
     .setPosition ( (dimensions.width-barWidth)/2 + dimensions.x, 
     barHeight*i + (i>2?barHeight:0) + dimensions.y)
     .setSize (barWidth, (int)(barHeight*.9))
     .setRange (0f,1f)
     //.setLock (s==SliderIndex.SATURATION?true:false)
     .setValue (s==SliderIndex.SATURATION?0f:1f)
     .setBroadcast(true)
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
  updateRGBSliders (wheel.lastSampleColor());
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

//this is called to override the value without triggering the above events
void setSlider (SliderIndex si, float val){
  sliders[si.index()].setBroadcast(false); //don't trigger gui events for this
  sliders[si.index()].setValue(val);
  sliders[si.index()].setBroadcast(true);
}

//newer
void updateGUISliders (final ColorStruct lastSampleColor){
  updateRGBSliders (lastSampleColor);
  setSlider (SliderIndex.HUE, lastSampleColor.h);
  setSlider (SliderIndex.SATURATION, lastSampleColor.s);
  setSlider (SliderIndex.BRIGHTNESS, lastSampleColor.bb);
}

void updateRGBSliders(final ColorStruct lastSampleColor){
  setSlider (SliderIndex.RED, lastSampleColor.r);
  setSlider (SliderIndex.GREEN, lastSampleColor.g);
  setSlider (SliderIndex.BLUE, lastSampleColor.b);
}