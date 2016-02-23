
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.Robot;
import java.awt.AWTException;
import processing.awt.PSurfaceAWT;
import java.awt.Frame;
import java.awt.Point;

class ScreenCapture{
  Robot robot;
  //BufferedImage image;
  Rectangle tmp;
  ScreenCapture(){
    tmp = new Rectangle();
    try{
      robot = new Robot();
      println ("robot success");
    }catch(AWTException e){
      println("failed to create robot, maybe you are running this sketch on a headless device? that's whack");
      exit();
    }catch (java.lang.SecurityException e){
      println("don't have permission to get screen color");
    }
  }
  
  //canvas is from normal mode PSurfaceAWT (Canvas) surface.getNative()
  color captureScreenColor(final Canvas canvas, int _x, int _y){
    Rectangle bounds = tmp;
    Point scrn_pt = canvas.getLocationOnScreen();
    println("POINT: ",scrn_pt);
    println("MOJSE: ",_x, _y);
    bounds.setBounds (scrn_pt.x , scrn_pt.y , 1,1);
    println("before:",bounds); 
    bounds.x += _x;
    bounds.y += _y;
    
    /* //this way works but getPixelColor is a shortcut
    image = robot.createScreenCapture(bounds);
    println("after:",bounds); 
    //return image.getRGB(0,0); //doesn't work out of sketch window
    */
    
    Color pxl_color = robot.getPixelColor(bounds.x,bounds.y);
    return pxl_color.getRGB();
  }
}