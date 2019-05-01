

int viewport_w = 1280;
int viewport_h = 720;
// iphone x = 2436x1125

boolean bMouseTime = true;
int desiredFrameRate = 24;

// classes
CamoNoise n;
GUI gui;

void settings(){
  size(viewport_w, viewport_h);
}

void setup(){

  gui = new GUI();
  gui.init(this);

  n = new CamoNoise();
  n.init();

  //motion blur array
  result = new int[width*height][3];
}

void draw(){
  showFPS();
  gui.display(this);

  if (!recording) {
    if (bMouseTime){
      if (mouseX >= (viewport_w-camoW) && mouseX < viewport_w && mouseY >=0 && mouseY < viewport_h){
        t = map(mouseX*1.0/camoW, 0.7, 1.7, 0.0, 1.0); // TODO fix this bodge, mouse time should equal export sequence time
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

void showFPS(){
  surface.setTitle(str(frameRate)); //Set the frame title to the frame rate
}

void keyPressed(){
  if (keyCode == ENTER){
    recordingStart = frame;
    recording = true;
  }
  if (key == 'i' || key == 'I'){
    bIndBuffer = !bIndBuffer;
    println("independent buffers: " + bIndBuffer);
  }
  if (key == 's' || key == 'S'){
    bSeed = !bSeed;
    println("seed: " + bSeed);
  }
  if (key == 'm' || key == 'M'){
    bMouseTime = !bMouseTime;
    println("mouse time: " + bMouseTime);
  }
  if (key == '1'){

  }
  if (key == '2'){

  }
  if (key == '3'){

  }
  if (key == '4'){

  }
  if (key == 'r'){
    bRect = !bRect;
  }
}


/// HELPERS ///

void push(){
  pushMatrix();
  pushStyle();
}

void pop(){
  popMatrix();
  popStyle();
}

void debug(){

}

//////////////////////////////////////

// Bees & bombs motion blur
int[][] result;
float t, c;
float mn = .5 * sqrt(3);
float ia = atan(sqrt(.5));
int samplesPerFrame = 3; // times to sample each frame
float shutterAngle = 0.5; // 180 degree shutter
boolean recording = false;
float recordingStart;
int frame = 1;
float speed = 0.01;

//TODO exports only the buffer, not including gui

void exportStill(){
  saveFrame("img/camo" + frame + ".png");
  println(".png exported to /img/");
}

void exportSequence(){

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
    int(result[i][0]*1.0/samplesPerFrame) << 16 |
    int(result[i][1]*1.0/samplesPerFrame) << 8 |
    int(result[i][2]*1.0/samplesPerFrame);
  }
  updatePixels();

  saveFrame("img/camo" + frame + ".png");
  println(frame,"/",numFrames);

  frame++;

  if ((frame-recordingStart)==numFrames){
    exit();
  }
}

void exportSequenceMotionBlur(){

}
