

int viewport_w = 1280;
int viewport_h = 720;
// iphone x = 2436x1125

boolean bMouseTime = true;

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

  background(10);

  if (!recording) {
    if (bMouseTime){
      if (mouseX >= (viewport_w-camoW) && mouseX < viewport_w && mouseY >=0 && mouseY < viewport_h){
        t = mouseX*1.0/camoW;
      }
    }
    n.update();
    n.display();
  }
  else {
    motionBlur();
  }

  gui.display(this);
}

void showFPS(){
  surface.setTitle(str(frameRate)); //Set the frame title to the frame rate
}

void keyPressed(){
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
    smooth = true;
    stark = false;
    gradient = false;
  }
  if (key == 'w'){
    smooth = false;
    stark = true;
    gradient = false;
  }
  if (key == 'e'){
    smooth = false;
    stark = false;
    gradient = true;
  }
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

void motionBlur(){
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
  }

  loadPixels();
  for (int i=0; i<pixels.length; i++){
    pixels[i] = 0xff << 24 |
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
