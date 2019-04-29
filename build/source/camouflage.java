import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class camouflage extends PApplet {



int viewport_w = 600;
int viewport_h = 600;
// iphone x = 2436x1125

// classes
CamoNoise n;
GUI gui;

// style
int bg = 255;

public void settings(){
  size(viewport_w, viewport_h);
}

public void setup(){

  gui = new GUI();
  gui.init(this);

  n = new CamoNoise();
  n.init();

  //motion blur array
  result = new int[width*height][3];
}

public void draw(){

  background(bg);

  if (!recording) {
    if (mouseX >= 0 && mouseX < viewport_w && mouseY >=0 && mouseY < viewport_h){
      t = mouseY*1.0f/height;
    }
    n.update();
    n.display();
  }
  else {
    motionBlur();
  }

  gui.display(this);
}

public void showFPS(){
  surface.setTitle(str(frameRate)); //Set the frame title to the frame rate
}

public void keyPressed(){
  if (keyCode == ENTER){
    recordingStart = time;
    recording = true;
  }
  if (key == '1'){
    bg = 255;
    println("BG white");
  }
  if (key == '2'){
    bg = 0;
    println("BG black");
  }
}


//////////////////////////////////////

// Bees & bombs motion blur
int[][] result;
float t, c;
float mn = .5f * sqrt(3);
float ia = atan(sqrt(.5f));
int samplesPerFrame = 5; // times to sample each frame
//int numFrames; // 4 secs at 24fps
float shutterAngle = 1.5f; // 180 degree shutter
boolean recording = false;
float recordingStart;
int time = 1;
float speed = 0.01f;

public void motionBlur(){
  // GUI numFrames control
  //numFrames = sNumFrames;

  for (int i=0; i<width*height; i++){
    for (int a=0; a<3; a++){
      result[i][a] = 0;
    }
  }

  c = 0;

  for (int sa = 0; sa < samplesPerFrame; sa++) {
    t = map(time-1 + sa * shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);

    // Draw the image
    n.update();
    n.display();
    loadPixels();
    for (int i=0; i<pixels.length; i++) {
      result[i][0] += pixels[i] >> 16 & 0xff;
      result[i][1] += pixels[i] >> 8 & 0xff;
      result[i][2] += pixels[i] & 0xff;
    }
  }

  loadPixels();
  for (int i=0; i<pixels.length; i++){
    pixels[i] = 0xff << 24 |
    PApplet.parseInt(result[i][0]*1.0f/samplesPerFrame) << 16 |
    PApplet.parseInt(result[i][1]*1.0f/samplesPerFrame) << 8 |
    PApplet.parseInt(result[i][2]*1.0f/samplesPerFrame);
  }
  updatePixels();

  saveFrame("img/softWords" + time + ".png");
  println(time,"/",numFrames);

  time++;

  if ((time-recordingStart)==numFrames){
    exit();
  }
}

/// HELPERS ///

public void push(){
  pushMatrix();
  pushStyle();
}

public void pop(){
  popMatrix();
  popStyle();
}


// Noise
float scale1;// = 0.001;
float radius1;// = 0.1;
float scale2 = 0.002f;
float radius2 = 0.2f;
float scale3 = 0.003f;
float radius3 = 0.3f;
float scale4 = 0.004f;
float radius4 = 0.4f;
int numFrames = 200;
int iterator = 0;
float seed;

int off1;
float off2;

// Moire
// int szX, szY = 256;
int spacing = 8;

// pallette
// 253	67	84

PGraphics moire1, moire2, moire3, moire4, camo;

OpenSimplexNoise simplex;

class CamoNoise {

  public void init(){

    simplex = new OpenSimplexNoise();
    moire1 = createGraphics(viewport_w, viewport_h);
    moire2 = createGraphics(viewport_w, viewport_h);
    moire3 = createGraphics(viewport_w, viewport_h);
    moire4 = createGraphics(viewport_w, viewport_h);

    camo = createGraphics(viewport_w, viewport_h);

  }

  public void update(){

    float t = 1.0f * iterator / numFrames;

    camo.beginDraw();

    // Three nice patterns
    // createCamoRect(camo, 0, 0, 2, 0.005, 0.006, 0.1, 0, 255);
    // createCamoRect(camo, spacing/2, spacing/2, 3, 0.001, 0.002, 0.2, 0, 255);
    // createCamoRect(camo, 0, spacing/2, 4, 0.0005, 0.004, 0.4, 0, 255);

    // Three nice patterns
    createCamoRect(camo, 0, 0, off1, off2, scale1, radius1, 0, 255);
    createCamoRect(camo, spacing/2, spacing/2, 2, 0.002f, 0.002f, 0.2f, 255, 255);
    createCamoRect(camo, 0, spacing/2, 3, 0.003f, 0.003f, 0.4f, 0, 255);

    // // Four not as interesting patterns
    // createCamoRect(camo, 0, 0, 2, 0.005, 0.006, 0.1, 0, 255);
    // createCamoRect(camo, spacing/2, spacing/2, 3, 0.001, 0.002, 0.2, 0, 255);
    // createCamoRect(camo, spacing/2, 0, 0.5, 0.007, 0.003, 0.3, 0, 255);
    // createCamoRect(camo, 0, spacing/2, 4, 0.0005, 0.004, 0.4, 0, 255);

    //
    // createCamoLine(camo, 0, 0, 2, 0.005, 0.006, 0.1, 0, 255);
    // createCamoLine(camo, spacing/2, spacing/2, 3, 0.001, 0.002, 0.2, 0, 255);
    // createCamoLine(camo, spacing/2, 0, 0.5, 0.007, 0.003, 0.3, 0, 255);
    // createCamoLine(camo, 0, spacing/2, 4, 0.0005, 0.004, 0.4, 0, 255);

    camo.endDraw();

    iterator++;

  }

  public void display(){
    showFPS();

    image(camo, 0, 0);
  }

  public void createCamoRect(PGraphics pg, int originX, int originY, float offset1, float offset2, float s, float r, int col1, int col2){

    pg.beginDraw();

    for (int x = originX, i = 0; x < viewport_w; x += spacing){
      for (int y = originY; y < viewport_h; y += spacing, i++){

        float off = offset1 * (float)simplex.eval(offset2 * x, offset2 * y);

        // // gradient
        // float ns = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off));
        // float colour = map(ns, -1, 1, 0, 255);

        // stark
        boolean b = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off)) > 0;
        float col = b?col1:col2;

        pg.stroke(col);
        pg.fill(col);
        pg.rect(x, y, spacing/2, spacing/2);
      }
    }

    pg.endDraw();
  }

  public void createCamoLine(PGraphics pg, int originX, int originY, float offset1, float offset2, float s, float r, int col1, int col2){

    pg.beginDraw();

    for (int x = originX, i = 0; x < viewport_w; x += spacing){
      for (int y = originY; y < viewport_h; y += spacing, i++){

        float off = offset1 * (float)simplex.eval(offset2 * x, offset2 * y);

        // // gradient
        // float ns = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off));
        // float colour = map(ns, -1, 1, 0, 255);

        // stark
        boolean b = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off)) > 0;
        float col = b?col1:col2;

        pg.stroke(col, 50);
        pg.fill(col, 50);
        pg.strokeWeight(spacing/4);
        pg.rect(x, y, spacing, spacing/2);
      }
    }

    pg.endDraw();
  }
}

ControlP5 cp5;

// Styling
int lightGrey = color(170,170,170);
int darkGrey = color(44,48,55);

// Sizing
int sliderWidth = 100;
int sliderHeight = 20;

class GUI {

  public void init(PApplet p){
    push();

    cp5 = new ControlP5(p);
    cp5.setAutoDraw(false);

    // Set Styling
    cp5.setColorForeground(lightGrey);
    cp5.setColorBackground(darkGrey);
    cp5.setColorActive(lightGrey);

    //createLabels();
    //createButtons();
    createSliders();

    pop();
  }

  public void display(PApplet p){
    hint(DISABLE_DEPTH_TEST);
    cp5.draw();
    hint(ENABLE_DEPTH_TEST);
  }

  public void createSliders(){
    // Frequency
    cp5.addSlider("scale1").setLabel("scale1").setRange(0.0001f,0.0005f).setValue(0.0001f).setPosition(10,10).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("radius1").setLabel("radius1").setRange(0.01f,0.05f).setValue(0.01f).setPosition(10,30).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("off1").setLabel("off1").setRange(1,9).setValue(1).setPosition(10,50).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("off2").setLabel("off2").setRange(0.0001f,0.0005f).setValue(0.0001f).setPosition(10,70).setSize(sliderWidth,sliderHeight);

  }


}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "camouflage" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
