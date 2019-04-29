

int viewport_w = 600;
int viewport_h = 600;
// iphone x = 2436x1125

// classes
CamoNoise n;
GUI gui;

// style
int bg = 255;

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

  background(bg);

  if (!recording) {
    if (mouseX >= 0 && mouseX < viewport_w && mouseY >=0 && mouseY < viewport_h){
      t = mouseY*1.0/height;
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
float mn = .5 * sqrt(3);
float ia = atan(sqrt(.5));
int samplesPerFrame = 5; // times to sample each frame
//int numFrames; // 4 secs at 24fps
float shutterAngle = 1.5; // 180 degree shutter
boolean recording = false;
float recordingStart;
int time = 1;
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
    int(result[i][0]*1.0/samplesPerFrame) << 16 |
    int(result[i][1]*1.0/samplesPerFrame) << 8 |
    int(result[i][2]*1.0/samplesPerFrame);
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

void push(){
  pushMatrix();
  pushStyle();
}

void pop(){
  popMatrix();
  popStyle();
}
