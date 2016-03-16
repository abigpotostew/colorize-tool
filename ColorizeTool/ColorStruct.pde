import java.text.DecimalFormat;

class ColorStruct{
  public color rgb;
  public float r,g,b;
  public float h,s,bb;
  void setRGB(color _rgb){
    rgb = _rgb;
    r = 1f*(rgb >> 16 & 0xFF)/255;
    g =  1f*(rgb >> 8 & 0xFF)/255;
    b = 1f*(mouseColor & 0xFF)/255;
  }
  void setHSB (float hue, float saturation, float brightness){
    h = min(hue,1f);
    s = saturation;
    bb = brightness;
  }
  
  public String toString(){
    return String.format("RGB: < %.2f, %.2f, %.2f>, HSB: < %.2f, %.2f, %.2f>",r,g,b,h,s,bb);
  }
}

ColorStruct[] colorStructBuffer(int n){
  ColorStruct[] buffer = new ColorStruct[n];
  for (int i=0;i<n;++i){
    buffer[i] = new ColorStruct();
  }
  return buffer;
}