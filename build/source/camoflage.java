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
int desiredFrameRate = 24;

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
        t = map(mouseX*1.0f/camoW, 0.7f, 1.7f, 0.0f, 1.0f); // TODO fix this bodge, mouse time should equal export sequence time
        //println("mouse control t: " + t);
      }
    }
    n.update();
    n.display();
  }
  else {
    exportSequence();
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
  if (key == 's' || key == 'S'){
    bSeed = !bSeed;
  }
  if (key == 'm' || key == 'M'){
    bMouseTime = !bMouseTime;
  }
  if (key == '1'){
    camoBG = 255;
    println("BG white");
  }
  if (key == '2'){
    camoBG = 10;
    println("BG black");
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

//TODO exports only the buffer, not including gui

public void exportStill(){
  saveFrame("img/camo" + frame + ".png");
  println(".png exported to /img/");
}

public void exportSequence(){

  for (int i=0; i<width*height; i++){
    for (int a=0; a<3; a++){
      result[i][a] = 0;
    }
  }

  c = 0;

  for (int sa = 0; sa < samplesPerFrame; sa++) {
    t = map(frame-1 + sa * shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
    //println("motion blur t: " + t);

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
    pixels[i] = 0xff << desiredFrameRate |
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

public void exportSequenceMotionBlur(){

}
int spacing = 12;

// Noise
float camoOneScale, camoTwoScale, camoThreeScale, camoFourScale;
float camoOneRadius, camoTwoRadius, camoThreeRadius, camoFourRadius;

boolean bNoiseOne, bNoiseTwo, bNoiseThree, bNoiseFour;
int iterator = 0;
float seed = random(10,1000);
float d = random(10,120);
boolean bSeed = true;

int camoOneOff1, camoTwoOff1, camoThreeOff1, camoFourOff1;
float camoOneOff2, camoTwoOff2, camoThreeOff2, camoFourOff2;

// anim controls
int numFrames;

int camoBG = 0;

boolean soft, stark, gradient;
int low = 0;
int lowmid = 80;
int highmid = 160;
int high = 255;
// pallette
// 253	67	84

PGraphics camo;
PGraphics[] camoBuffers;
boolean indBuffer;
int numBuffers = 4;

int camoW = 720;
int camoH = 720;

OpenSimplexNoise simplex;

class CamoNoise {

  public void init(){

    simplex = new OpenSimplexNoise();

    camo = createGraphics(camoH, camoH); // one buffer for mixed
    // camoBuffer1 = createGraphics(camoW, camoH); // one buffer for each
    // camoBuffer2 = createGraphics(camoW, camoH);
    // camoBuffer3 = createGraphics(camoW, camoH);
    // camoBuffer4 = createGraphics(camoW, camoH);

    // for (int i = 0; i < numBuffers; i++){
    //   camoBuffers[i] = createGraphics(camoW, camoH);
    // }

  }

  public void update(){

    float t = 1.0f * iterator / numFrames;

    camo.beginDraw();
    camo.clear(); // empty the buffer

    // Four not as interesting patterns
    if (indBuffer){

      for (int i = 0; i < numBuffers; i++){
        camoBuffers[i].beginDraw();
        camoBuffers[i].clear();

        int x, y;
        if (i == 1 && bNoiseOne){
          x = 0;
          y = 0;
          camoRect(camoBuffers[i], x, y, camoOneOff1, camoOneOff2/10, camoOneScale/10, camoOneRadius, 0, 255);
        }
        else if (i == 2 && bNoiseTwo){
          x = spacing/2;
          y = 0;
          camoRect(camoBuffers[i], x, y, camoTwoOff1, camoTwoOff2/10, camoTwoScale/10, camoTwoRadius, 0, 255);
        }
        else if (i == 3){
          x = 0;
          y = spacing/2;
          camoRect(camoBuffers[i], x, y, camoThreeOff1, camoThreeOff2/10, camoThreeScale/10, camoThreeRadius, 0, 255);
        }
        else if (i == 4){
          x = 0;
          y = spacing/2;
          camoRect(camoBuffers[i], x, y, camoFourOff1, camoFourOff2/10, camoFourScale/10, camoFourRadius, 0, 255);
        }

        camoBuffers[i].endDraw();
      }
    }
    else  if (!indBuffer){
      if (bNoiseOne)  camoRect(camo, 0, 0, camoOneOff1, camoOneOff2/10, camoOneScale/10, camoOneRadius, 0, 255);
      if (bNoiseTwo)  camoRect(camo, spacing/2, 0, camoTwoOff1, camoTwoOff2/10, camoTwoScale/10, camoTwoRadius, 0, 255);
      if (bNoiseThree)camoRect(camo, 0, spacing/2, camoThreeOff1, camoThreeOff2/10, camoThreeScale/10, camoThreeRadius, 0, 255);
      if (bNoiseFour) camoRect(camo, spacing/2, spacing/2, camoFourOff1, camoFourOff2/10, camoFourScale/10, camoFourRadius, 0, 255);
    }

    camo.endDraw();

    iterator++;

  }

  public void display(){

    // show camo
    push();
    translate(viewport_w-camoW, 0);
    // draw bg
    fill(camoBG);
    rect(0,0, camoW, camoH);
    image(camo, 0, 0);
    pop();
  }

  public void camoRect(PGraphics pg, int originX, int originY, float offset1, float offset2, float s, float r, int col1, int col2){

    push();
    pg.beginDraw();

    float col = 0.0f;

    for (int x = originX, i = 0; x < viewport_w; x += spacing){
      for (int y = originY; y < viewport_h; y += spacing, i++){

        float off = offset1 * (float)simplex.eval(offset2 * x, offset2 * y);
        float ns = 0.0f;

        float easeT = ease(t, 1.0f);
        float p = 1.0f * i / i;

        if (bSeed){
          ns = (float)simplex.eval(s * x, s * y, seed + r * sin(TWO_PI * easeT + off), r * cos(TWO_PI * easeT + off));
        }
        else{
          ns = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off));

        }


        if (soft){
          // col = map(ns, -1, 1, 0, 255);
          map(pNoise(offset(p)-t, r), -1, 1, 0, 255);
          col = map(ns, -1, 1, 0, 255);
        }
        else if (stark){
          boolean b = ns > 0;
          col = b?col1:col2;
        }
        else if (gradient){
          float c = map(ns, -1, 1, 0, 255);


          // 4 colours
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

  // // 1-periodic function from a circle in noise
  public float pNoise(float q, float r){
    return (float)simplex.eval(seed + r * cos(TWO_PI * q), r * sin(TWO_PI * q));
  }

  public float offset(float p){
    return 5.0f*pow(p,3.0f);
  }

  public float ease(float p, float g) {
    if (p < 0.5f)
      return 0.5f * pow(2*p, g);
    else
      return 1 - 0.5f * pow(2*(1 - p), g);
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
PVector sliderPos = new PVector(10, 10);
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
int accordionW = 200;
int accordionH = 50;
Group noiseGroupOne, noiseGroupTwo, noiseGroupThree, noiseGroupFour, animationGroup, styleGroup;

String filename;

class GUI {

  public void init(PApplet p){
    push();

    cp5 = new ControlP5(p);
    cp5.setAutoDraw(false);

    setStyling();
    createGroups();
    createAccordian();
    createControls();

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
    noiseGroupOne = cp5.addGroup("Noise One").setBackgroundHeight(accordionH);
    noiseGroupTwo = cp5.addGroup("Noise Two").setBackgroundHeight(accordionH);
    noiseGroupThree = cp5.addGroup("Noise Three").setBackgroundHeight(accordionH);
    noiseGroupFour = cp5.addGroup("Noise Four").setBackgroundHeight(accordionH);

    // global
    animationGroup = cp5.addGroup("Animation Settings").setBackgroundHeight(accordionH);

    // style
    styleGroup = cp5.addGroup("Style Settings").setBackgroundHeight(accordionH);
  }

  public void setStyling(){
    cp5.setColorForeground(lightGrey);
    cp5.setColorBackground(darkGrey);
    cp5.setColorActive(lightGrey);
  }

  public void createAccordian(){
    accordion = cp5.addAccordion("accordion").setPosition(sliderPos.x,sliderPos.y).setWidth(accordionW)
                .addItem(animationGroup).addItem(styleGroup).addItem(noiseGroupOne).addItem(noiseGroupTwo).addItem(noiseGroupThree).addItem(noiseGroupFour);

    accordion.open(0,1);
    accordion.close(2,3,4,5);
    accordion.setCollapseMode(Accordion.MULTI);
  }

  public void createControls(){
    push();

    // animation
    animationControls(sliderPos, animationGroup);

    // style
    styleControls(sliderPos, styleGroup);

    // should be conditional depending on user selection
    noiseControls(sliderPos, "camoOneScale", "camoOneRadius", "camoOneOff1", "camoOneOff2", noiseGroupOne);
    noiseControls(sliderPos, "camoTwoScale", "camoTwoRadius", "camoTwoOff1", "camoTwoOff2", noiseGroupTwo);
    noiseControls(sliderPos, "camoThreeScale", "camoThreeRadius", "camoThreeOff1", "camoThreeOff2", noiseGroupThree);
    noiseControls(sliderPos, "camoFourScale", "camoFourRadius", "camoFourOff1", "camoFourOff2", noiseGroupFour);

    pop();
  }

  // animation controls
  public void animationControls(PVector p, Group g){

    PVector _p = new PVector(p.x, p.y);

    cp5.addSlider("numFrames").setLabel("numFrames").setRange(24,240).setValue(48).setPosition(_p.x,_p.y).setSize(sliderW,sliderH).moveTo(g);

    cp5.addToggle("bNoiseOne").setLabel("Noise 1").setPosition(_p.x,_p.y+=sliderSpacing).setSize(toggleW,toggleH).setValue(false).setMode(ControlP5.SWITCH).moveTo(g);
    cp5.addToggle("bNoiseTwo").setLabel("Noise 2").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).setValue(false).setMode(ControlP5.SWITCH).moveTo(g);
    cp5.addToggle("bNoiseThree").setLabel("Noise 3").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).setValue(false).setMode(ControlP5.SWITCH).moveTo(g);
    cp5.addToggle("bNoiseFour").setLabel("Noise 4").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).setValue(false).setMode(ControlP5.SWITCH).moveTo(g);

    cp5.addButton("exportStill").setPosition(p.x,_p.y+=sliderSpacing*2).setSize(sliderW,sliderH);
    cp5.addButton("exportSequence").setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH);
  }

  // global controls
  public void styleControls(PVector p, Group g){

    PVector _p = new PVector(p.x, p.y);

    cp5.addSlider("spacing").setLabel("spacing").setRange(4,64).setValue(16).setNumberOfTickMarks(31).setPosition(_p.x,_p.y).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider("camoBG").setLabel("background").setRange(0,255).setValue(10).setNumberOfTickMarks(255).setPosition(_p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);

    // shading choices
    cp5.addToggle("soft").setPosition(_p.x,_p.y+=controlGap).setSize(toggleW,toggleH).moveTo(g);
    cp5.addToggle("stark").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).moveTo(g);
    cp5.addToggle("gradient").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).moveTo(g);


  }

  public void noiseControls(PVector p, String s, String r, String o1, String o2, Group g){

    PVector _p = new PVector(p.x, p.y);

    cp5.addSlider(s).setLabel("scale").setRange(0.01f,0.5f).setValue(0.02f).setPosition(_p.x,_p.y).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(r).setLabel("radius").setRange(0.01f,0.5f).setValue(0.1f).setPosition(_p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(o1).setLabel("off1").setRange(1,9).setValue(1).setPosition(_p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(o2).setLabel("off2").setRange(0.01f,0.20f).setValue(0.01f).setPosition(_p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
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
