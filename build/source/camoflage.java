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

public class camoflage extends PApplet {



int viewport_w = 1280;
int viewport_h = 720;
// iphone x = 2436x1125

boolean bMouseTime = true;

// classes
CamoNoise n;
GUI gui;

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
  showFPS();
  gui.display(this);

  if (!recording) {
    if (bMouseTime){
      if (mouseX >= (viewport_w-camoW) && mouseX < viewport_w && mouseY >=0 && mouseY < viewport_h){
        t = mouseX*1.0f/camoW;
      }
    }
    n.update();
    n.display();
  }
  else {
    motionBlur();
  }

}

public void showFPS(){
  surface.setTitle(str(frameRate)); //Set the frame title to the frame rate
}

public void keyPressed(){
  if (keyCode == ENTER){
    recordingStart = frame;
    recording = true;
  }
  if (key == 'm' || key == 'M'){
    bMouseTime = !bMouseTime;
  }
  if (key == '1'){
    bg = 255;
    println("BG white");
  }
  if (key == '2'){
    bg = 10;
    println("BG black");
  }
  if (key == 'q'){
    soft = true;
    stark = false;
    gradient = false;
  }
  if (key == 'w'){
    soft = false;
    stark = true;
    gradient = false;
  }
  if (key == 'e'){
    soft = false;
    stark = false;
    gradient = true;
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

public void debug(){

}

//////////////////////////////////////

// Bees & bombs motion blur
int[][] result;
float t, c;
float mn = .5f * sqrt(3);
float ia = atan(sqrt(.5f));
int samplesPerFrame = 3; // times to sample each frame
float shutterAngle = 0.5f; // 180 degree shutter
boolean recording = false;
float recordingStart;
int frame = 1;
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
    t = map(frame-1 + sa * shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);

    // Draw the image
    n.update();
    n.display();
    loadPixels();
    for (int i=0; i<pixels.length; i++) {
      result[i][0] += pixels[i] >> 16 & 0xff;
      result[i][1] += pixels[i] >> 8 & 0xff;
      result[i][2] += pixels[i] & 0xff;
    }
    updatePixels();
  }

  loadPixels();
  for (int i=0; i<pixels.length; i++){
    pixels[i] = 0xff << 24 |
    PApplet.parseInt(result[i][0]*1.0f/samplesPerFrame) << 16 |
    PApplet.parseInt(result[i][1]*1.0f/samplesPerFrame) << 8 |
    PApplet.parseInt(result[i][2]*1.0f/samplesPerFrame);
  }
  updatePixels();

  saveFrame("img/camo" + frame + ".png");
  println(frame,"/",numFrames);

  frame++;

  if ((frame-recordingStart)==numFrames){
    exit();
  }
}


// Noise
float camoOneScale, camoTwoScale, camoThreeScale, camoFourScale;
float camoOneRadius, camoTwoRadius, camoThreeRadius, camoFourRadius;
float scale2 = 0.002f;
float radius2 = 0.2f;


float scale3 = 0.003f;
float radius3 = 0.3f;
float scale4 = 0.004f;
float radius4 = 0.4f;

int iterator = 0;
float seed;

int camoOneOff1, camoTwoOff1, camoThreeOff1, camoFourOff1;
float camoOneOff2, camoTwoOff2, camoThreeOff2, camoFourOff2;

// anim controls
int numFrames;

// Moire
// int szX, szY = 256;
int spacing = 12;

// pallette
// 253	67	84
int low = 0;
int lowmid = 80;
int highmid = 160;
int high = 255;
int bg = 0;

boolean soft;
boolean stark;
boolean gradient;

boolean bNoiseOne, bNoiseTwo, bNoiseThree, bNoiseFour;

PGraphics moire1, moire2, moire3, moire4, camo;

int camoW = 720;
int camoH = 720;

OpenSimplexNoise simplex;

class CamoNoise {

  public void init(){

    simplex = new OpenSimplexNoise();
    // moire1 = createGraphics(camoW, camoH);
    // moire2 = createGraphics(camoW, camoH);
    // moire3 = createGraphics(camoW, camoH);
    // moire4 = createGraphics(camoW, camoH);

    camo = createGraphics(camoH, camoH);

  }

  public void update(){

    float t = 1.0f * iterator / numFrames;

    camo.beginDraw();
    camo.clear(); // empty the buffer

    // Three nice patterns
    // createCamoRect(camo, 0, 0, 2, 0.005, 0.006, 0.1, 0, 255);
    // createCamoRect(camo, spacing/2, spacing/2, 3, 0.001, 0.002, 0.2, 0, 255);
    // createCamoRect(camo, 0, spacing/2, 4, 0.0005, 0.004, 0.4, 0, 255);

    // Three nice patterns
    // createCamoRect(camo, 0, 0, camoOneOff1, camoOneOff2/10, camoOneScale/10, camoOneRadius, 0, 255);
    // createCamoRect(camo, spacing/2, spacing/2, camoTwoOff1, camoTwoOff2/10, camoTwoScale/10, camoTwoRadius, 0, 255);
    // createCamoRect(camo, 0, spacing/2, camoThreeOff1, camoThreeOff2/10, camoThreeScale/10, camoThreeRadius, 0, 255);

    // // Four not as interesting patterns
    if (bNoiseOne)  createCamoRect(camo, 0, 0, camoOneOff1, camoOneOff2/10, camoOneScale/10, camoOneRadius, 0, 255);
    if (bNoiseTwo)  createCamoRect(camo, spacing/2, 0, camoTwoOff1, camoTwoOff2/10, camoTwoScale/10, camoTwoRadius, 0, 255);
    if (bNoiseThree)createCamoRect(camo, 0, spacing/2, camoThreeOff1, camoThreeOff2/10, camoThreeScale/10, camoThreeRadius, 0, 255);
    if (bNoiseFour) createCamoRect(camo, spacing/2, spacing/2, camoFourOff1, camoFourOff2/10, camoFourScale/10, camoFourRadius, 0, 255);

    // lines
    // createCamoLine(camo, 0, 0, 2, 0.005, 0.006, 0.1, 0, 255);
    // createCamoLine(camo, spacing/2, spacing/2, 3, 0.001, 0.002, 0.2, 0, 255);
    // createCamoLine(camo, spacing/2, 0, 0.5, 0.007, 0.003, 0.3, 0, 255);
    // createCamoLine(camo, 0, spacing/2, 4, 0.0005, 0.004, 0.4, 0, 255);

    camo.endDraw();

    iterator++;

  }

  public void display(){

    // show camo
    push();
    translate(viewport_w-camoW, 0);
    // draw bg
    fill(bg);
    rect(0,0, camoW, camoH);
    image(camo, 0, 0);
    pop();
  }

  public void createCamoRect(PGraphics pg, int originX, int originY, float offset1, float offset2, float s, float r, int col1, int col2){
    push();
    pg.beginDraw();

    float col = 0.0f;

    for (int x = originX, i = 0; x < viewport_w; x += spacing){
      for (int y = originY; y < viewport_h; y += spacing, i++){

        float off = offset1 * (float)simplex.eval(offset2 * x, offset2 * y);

        if (soft){
          float ns = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off));
          col = map(ns, -1, 1, 0, 255);
        }
        else if (stark){
          boolean b = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off)) > 0;
          col = b?col1:col2;
        }
        else if (gradient){
          float ns = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off));
          float c = map(ns, -1, 1, 0, 255);

          if (c <= 85){
            col = low;
          }
          else if (c > 85 && c <= 128){
            col = lowmid;
          }
          else if (c > 128 && c <= 192){
            col = highmid;
          }
          else if (c > 192 && c <= 255){
            col = high;
          }
        }

        // set style and draw
        pg.stroke(col);
        pg.fill(col);
        pg.rect(x, y, spacing/2, spacing/2);
      }
    }

    pg.endDraw();
    pop();
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
int labelColour = color(0,0,0);
int guiBG = color(0, 0, 0);

int guiW = viewport_w;
int guiH = viewport_h;


// Sizing
int sliderW = 100;
int sliderH = 10;
int sliderY = 10;
int sliderX = 10;
int sliderPadding = 10;
int sliderSpacing = sliderH+sliderPadding;

int toggleW = 20;
int toggleH = sliderH;
int toggleSpacingX = 40;
int toggleSpacingY = 10;
int controlGap = 30;

// TODO
// add switches to turn off different layers of noise
// accordians for each noise setting

Accordion accordion;
Group noiseGroupOne, noiseGroupTwo, noiseGroupThree, noiseGroupFour, globalGroup;
RadioButton radioShading;

class GUI {

  public void init(PApplet p){
    push();

    cp5 = new ControlP5(p);
    cp5.setAutoDraw(false);

    setStyling();
    createGroups();

    createControls();
    createAccordian();

    pop();

  }

  public void display(PApplet p){
    push();
    hint(DISABLE_DEPTH_TEST);
    fill(guiBG);
    rect(0,0, guiW, guiH);
    cp5.draw();
    hint(ENABLE_DEPTH_TEST);
    pop();
  }

  public void createGroups(){
    // noise
    noiseGroupOne = cp5.addGroup("Noise One").setBackgroundHeight(50);
    noiseGroupTwo = cp5.addGroup("Noise Two").setBackgroundHeight(50);
    noiseGroupThree = cp5.addGroup("Noise Three").setBackgroundHeight(50);
    noiseGroupFour = cp5.addGroup("Noise Four").setBackgroundHeight(50);

    // global
    globalGroup = cp5.addGroup("Global Settings").setBackgroundHeight(150);
  }

  public void setStyling(){
    cp5.setColorForeground(lightGrey);
    cp5.setColorBackground(darkGrey);
    cp5.setColorActive(lightGrey);
  }

  public void createAccordian(){

    accordion = cp5.addAccordion("acc").setPosition(40,40).setWidth(200)
                .addItem(globalGroup).addItem(noiseGroupOne).addItem(noiseGroupTwo).addItem(noiseGroupThree).addItem(noiseGroupFour);

    accordion.open(0);
    accordion.close(1,2,3,4);
    accordion.setCollapseMode(Accordion.MULTI);
  }

  public void createControls(){
    push();

    // global
    globalControls(sliderX, sliderY, globalGroup);

    // should be conditional depending on user selection
    noiseControls(sliderX, sliderY, "camoOneScale", "camoOneRadius", "camoOneOff1", "camoOneOff2", noiseGroupOne);
    noiseControls(sliderX, sliderY, "camoTwoScale", "camoTwoRadius", "camoTwoOff1", "camoTwoOff2", noiseGroupTwo);
    noiseControls(sliderX, sliderY, "camoThreeScale", "camoThreeRadius", "camoThreeOff1", "camoThreeOff2", noiseGroupThree);
    noiseControls(sliderX, sliderY, "camoFourScale", "camoFourRadius", "camoFourOff1", "camoFourOff2", noiseGroupFour);

    pop();
  }

  // global controls
  public void globalControls(int x, int y, Group g){

    int _x = x;
    int _y = y;

    cp5.addSlider("spacing").setLabel("spacing").setRange(4,64).setValue(16).setNumberOfTickMarks(31).setPosition(x,y).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider("numFrames").setLabel("numFrames").setRange(24,240).setValue(48).setPosition(x,y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);

    cp5.addToggle("bNoiseOne").setLabel("Noise 1").setPosition(x,y+=sliderSpacing).setSize(toggleW,toggleH).setValue(false).setMode(ControlP5.SWITCH).moveTo(g);
    cp5.addToggle("bNoiseTwo").setLabel("Noise 2").setPosition(x+=toggleSpacingX,y).setSize(toggleW,toggleH).setValue(false).setMode(ControlP5.SWITCH).moveTo(g);
    cp5.addToggle("bNoiseThree").setLabel("Noise 3").setPosition(x+=toggleSpacingX,y).setSize(toggleW,toggleH).setValue(false).setMode(ControlP5.SWITCH).moveTo(g);
    cp5.addToggle("bNoiseFour").setLabel("Noise 4").setPosition(x+=toggleSpacingX,y).setSize(toggleW,toggleH).setValue(false).setMode(ControlP5.SWITCH).moveTo(g);

    // shading choices
    cp5.addToggle("soft").setPosition(_x,y+=controlGap).setSize(toggleW,toggleH).moveTo(g);
    cp5.addToggle("stark").setPosition(_x+=toggleSpacingX,y).setSize(toggleW,toggleH).moveTo(g);
    cp5.addToggle("gradient").setPosition(_x+=toggleSpacingX,y).setSize(toggleW,toggleH).moveTo(g);

  }

  public void noiseControls(int x, int y, String s, String r, String o1, String o2, Group g){
    cp5.addSlider(s).setLabel("scale").setRange(0.01f,0.5f).setValue(0.02f).setPosition(x,y).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(r).setLabel("radius").setRange(0.01f,0.5f).setValue(0.1f).setPosition(x,y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(o1).setLabel("off1").setRange(1,9).setValue(1).setPosition(x,y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(o2).setLabel("off2").setRange(0.01f,0.05f).setValue(0.01f).setPosition(x,y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
  }

  public void bNoiseOne(boolean theFlag) {
    if(theFlag==true) {
      bNoiseOne = true;
    } else {
      bNoiseOne = false;
    }
    println("bNoise One = " + bNoiseOne);
  }


}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "camoflage" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
