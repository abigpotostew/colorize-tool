/*
  By Stewart Bracken, 2016
  See LICENCE.txt or LICENSE.md for licensing information
*/

class ColorWheel{
    
    PGraphics wheel_buffer, mask, original_buffer;
    private float brightness;
    private boolean dirty;
    int w,h;
    PVector center;
    PVector samplePosition;
    
    int INC;
    
    private PVector ZERO;
    private PVector[] vectorBuffer;
    public float[] colorTmp;
    private PVector nCenter = new PVector(.5,.5);
    
    private ColorStruct[] rgbhsbBuffer;
    private ColorStruct lastSampleColor;
    
    ColorWheel(int _w, int _h){
      vectorBuffer = vectorBuffer(5);
      ZERO = vectorBuffer[0];
      colorTmp = new float[3];
      rgbhsbBuffer = colorStructBuffer(3);
      lastSampleColor = rgbhsbBuffer[0];
      
      w = _w;
      h = _h;
      center = new PVector(w/2,h/2);
      dirty = true;
      setBrightness (COLOR_MAX);
      setupBuffer();
      
      samplePosition = new PVector(center.x,center.y);
      
    }
    
    private void setupBuffer(){
      wheel_buffer = createGraphics(w,h);
      //wheel_buffer.smooth(8);
      
      mask = createGraphics(w,h);
      mask.smooth(8);
      mask.beginDraw();
      mask.background(0);
      mask.noStroke();
      mask.fill(255);
      mask.ellipse(center.x, center.y, w,h);
      mask.endDraw();
      
      original_buffer = createGraphics(w,h); //original wheel buffer at full brightness
      firstTimeGenBuffer();
      drawWheel(); //draw wheel onto view buffer
    }
    
    private PGraphics viewBuffer(){
        return wheel_buffer;
    }
    private PGraphics fullColorBuffer(){
      return original_buffer;
    }
    
    private void startBuffer (PGraphics pg){
      pg.beginDraw();
      pg.colorMode (RGB, COLOR_MAX); //need this cus resets after begin draw
      pg.background (color(COLOR_MAX,0));
    }
    
    private void endBuffer (PGraphics pg){
      pg.endDraw();
    }

    //call once to get full brightness (slow)
    private void firstTimeGenBuffer(){
      startBuffer (original_buffer);
      //draw the thing
      generateWheel (original_buffer);
      endBuffer (original_buffer);
    }
    
    public void posToColor(int _x, int _y, ColorStruct _out){
      PVector screen_point = vectorBuffer[1]; //normalized position of pixel
      PVector normalized_point = vectorBuffer[2];
      PVector target = vectorBuffer[3];
      PVector n_target = vectorBuffer[4];
      float hue=0, saturation;
      float d=0,alpha;
      
      screen_point.set(_x,_y);
      screen_point.normalize(normalized_point);
      target.set (screen_point.x - center.x, screen_point.y - center.y);

      d = PVector.dist (center, screen_point);
      
      hue = (float)Math.atan2(target.y, target.x);
      if (hue<0){
        hue+= TWO_PI;
      }
      hue = map (hue, 0, TWO_PI, 0, COLOR_MAX);
      saturation = min(d,1f);
      saturation = d/(center.x);
      
      _out.setHSB (hue, saturation, brightness);
      _out.setRGB(Color.HSBtoRGB(hue, saturation, brightness));
    }
    

    // redraw from
    private void generateWheel(PGraphics pg){
      pg.loadPixels();
      int[] p = pg.pixels;
      ColorStruct rgbhsb = rgbhsbBuffer[1];
      int x,y;
      for(int i=0;i<p.length;++i){
        x = i%w;
        y = i/w;
        posToColor (x,y,rgbhsb);

        pg.stroke (rgbhsb.rgb);
        pg.point (x, y); //<>//
      }
      
      pg.mask(mask);
      //println(angle, "n_point:", normalized_point, "screen_p:",screen_point, "nCenter", nCenter, "center", center);
      //println("dist:", d);
      
    }
    
    //input [0..1]
    void setBrightness(float _bright){
      brightness = clamp(_bright, 0, COLOR_MAX);//map(, 0,255, 0,COLOR_MAX);
      dirty = true;
      //println(_bright);
    }
    
    private float getBrightness(){
      return brightness;
    }
    
    private void drawWheel(){
      PGraphics viewOut = viewBuffer();
      PGraphics fullColor = fullColorBuffer();
      startBuffer (viewOut);
      viewOut.tint (getBrightness()); //tint by brightness
      viewOut.image (fullColor,0,0);
      endBuffer (viewOut);
      dirty = false;
        
      //println("drawIteration",drawIteration++);
  }
      
    void draw(){
      draw(0,0);
    }
    void draw(int x, int y){
      if (dirty){
        drawWheel();
      }
      image(viewBuffer(),x,y);
    }
    
    public boolean inBounds(int x, int y){
      PVector mouse = vectorBuffer[1];
      mouse.set(x,y);
      //PVector center = vectorBuffer[2];
      return PVector.dist(mouse,center)<center.x;
    }
    
    public PVector lastSamplePosition(){
      return samplePosition;
    }
    
    private int viewBufferSample(int _x, int _y){
      if (samplePosition.x != _x || samplePosition.y != _y){
        posToColor (_x, _y, lastSampleColor);
        
      //println(_x,_y, INC++);
      //println(lastSampleColor.r,lastSampleColor.g,lastSampleColor.b);
      //println(lastSampleColor.h,lastSampleColor.s,lastSampleColor.bb);
      }
      return lastSampleColor.rgb;
    }
    
    private int viewBufferSample(float _x, float _y){
      return viewBufferSample ((int)_x, (int)_y);
    }
    
    private int viewBufferSample(PVector p){
      return viewBufferSample (p.x, p.y);
    }
   
    public color sampleAt(float _x, float _y){
      return sampleAt ((int)_x, (int)_y);
    }
    
    public color sampleAt (int _x, int _y){
      if (dirty){ //<>//
        drawWheel();
      }
      if (samplePosition.x == _x && samplePosition.y == _y){
        return viewBufferSample (samplePosition);
      }
      
      //find position inside wheel and return color
      PVector targetPosition = vectorBuffer[1];
      targetPosition.set (_x, _y);
      float dist = PVector.dist (targetPosition, center);
      if (dist > center.x){
        targetPosition.normalize (targetPosition);
        targetPosition.mult (center.x*.98);
        targetPosition.add (center);
      }
      //always floor for consistency
      targetPosition.set ((int)targetPosition.x,(int)targetPosition.y);
      color out = viewBufferSample (targetPosition);
      samplePosition.set (targetPosition);
      return out;
    }
    
    //gui requests integer position. then set color for that position
    //private void colorToPos (h,s,b){
      
    //}
    
    public color lastSample(){
      return viewBufferSample (lastSamplePosition());
    }
    
    public void setSampleRGB(float r, float g, float b){
      //call hsb code
    }
    public void setSampleHSB(float h, float s, float b){
      float angle = h*TWO_PI;
      float dist = s*center.x;
      setBrightness(b);
      float x = cos(angle)*dist;
      float y = sin(angle)*dist;
      float newColor = sampleAt (x + center.x,y+center.y);
    }
    
    //rgb is [0..1]
    public float[] RGBtoHSB (float r, float g, float b){
      float[] tmp = colorTmp;
      Color.RGBtoHSB(sRGB(r),sRGB(g),sRGB(b),tmp);
      return tmp;
    }
    //conve
    //convert color from 0..1 to 0..255 
    int sRGB(float c){
      return int(c*255);
    }
}