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
  wheelByRGB();
}

void SGreen(float theColor) {
  sliderEvent (SliderIndex.GREEN, theColor);
  wheelByRGB();
}

void SBlue(float theColor) {
  sliderEvent (SliderIndex.BLUE, theColor);
  wheelByRGB();
}

void wheelByRGB(){
  float r = sliders[SliderIndex.RED.index()].getValue(),
        g = sliders[SliderIndex.GREEN.index()].getValue(),
        b = sliders[SliderIndex.BLUE.index()].getValue();
  wheel.setSampleRGB (r,g,b);
  updateHSBSliders (wheel.lastSampleColor());
}

void print_3colors(float a,float b, float c, String premsg){
  println((premsg!=null?premsg:"") + String.format(" < %.2f, %.2f, %.2f>",a,b,c));
}

//sets RGB sliders using hsb slider values
void wheelByHSB(){
  float h = sliders[SliderIndex.HUE.index()].getValue(),
        s = sliders[SliderIndex.SATURATION.index()].getValue(),
        b = sliders[SliderIndex.BRIGHTNESS.index()].getValue();
  print_3colors(h,s,b,"BEFORE:");
  wheel.setSampleHSB (h,s,b);
  println (wheel.lastSampleColor());
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
  updateHSBSliders (lastSampleColor);
}

void updateRGBSliders(final ColorStruct lastSampleColor){
  setSlider (SliderIndex.RED, lastSampleColor.r);
  setSlider (SliderIndex.GREEN, lastSampleColor.g);
  setSlider (SliderIndex.BLUE, lastSampleColor.b);
}

void updateHSBSliders(final ColorStruct lastSampleColor){
  setSlider (SliderIndex.HUE, lastSampleColor.h);
  setSlider (SliderIndex.SATURATION, lastSampleColor.s);
  setSlider (SliderIndex.BRIGHTNESS, lastSampleColor.bb);
}