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

boolean bRect = true;

// anim controls
int numFrames;

int camoBG = 0;
int alpha = 255;

boolean smooth, stark, gradient;
int r1, r2, r3, r4;
int low, lowmid, highmid, high; // TODO control these through GUI
// pallette
// 253	67	84

PGraphics camo;
PGraphics[] camoBuffers;
boolean bIndBuffer = true;
int numBuffers = 5;

int camoW = 720;
int camoH = 720;

OpenSimplexNoise simplex;

class CamoNoise {

  void init(){

    simplex = new OpenSimplexNoise();

    camo = createGraphics(camoH, camoH); // one buffer for mixed

    camoBuffers = new PGraphics[numBuffers];

    for (int i = 0; i < numBuffers; i++){
      camoBuffers[i] = createGraphics(camoW, camoH);
    }

  }

  void update(){

    float t = 1.0 * iterator / numFrames;

    // Four not as interesting patterns
    if (bIndBuffer){

      for (int i = 0; i < numBuffers; i++){
        camoBuffers[i].beginDraw();
        camoBuffers[i].clear();

        int x, y;
        if (i == 1 && bNoiseOne){
          x = 0;
          y = 0;
          camoRect(camoBuffers[i], x, y, camoOneOff1, camoOneOff2/10, camoOneScale/10, camoOneRadius, low, high);
        }
        else if (i == 2 && bNoiseTwo){
          x = spacing/2;
          y = 0;
          camoRect(camoBuffers[i], x, y, camoTwoOff1, camoTwoOff2/10, camoTwoScale/10, camoTwoRadius, low, high);
        }
        else if (i == 3 && bNoiseThree){
          x = 0;
          y = spacing/2;
          camoRect(camoBuffers[i], x, y, camoThreeOff1, camoThreeOff2/10, camoThreeScale/10, camoThreeRadius, low, high);
        }
        else if (i == 4 && bNoiseFour){
          x = spacing/2;
          y = spacing/2;
          camoRect(camoBuffers[i], x, y, camoFourOff1, camoFourOff2/10, camoFourScale/10, camoFourRadius, low, high);
        }

        camoBuffers[i].endDraw();
      }
    }

    else  if (!bIndBuffer){
      camo.beginDraw();
      camo.clear(); // empty the buffer

      // if (bNoiseOne)  camoRect(camo, 0, 0, camoOneOff1, camoOneOff2/10, camoOneScale/10, camoOneRadius, low, high);
      // if (bNoiseTwo)  camoRect(camo, spacing/2, 0, camoTwoOff1, camoTwoOff2/10, camoTwoScale/10, camoTwoRadius, low, high);
      // if (bNoiseThree)camoRect(camo, 0, spacing/2, camoThreeOff1, camoThreeOff2/10, camoThreeScale/10, camoThreeRadius, low, high);
      // if (bNoiseFour) camoRect(camo, spacing/2, spacing/2, camoFourOff1, camoFourOff2/10, camoFourScale/10, camoFourRadius, low, high);

      if (bNoiseOne)  camoLine(camo, 0, 0, camoOneOff1, camoOneOff2/10, camoOneScale/10, camoOneRadius);
      if (bNoiseTwo)  camoLine(camo, spacing/2, 0, camoTwoOff1, camoTwoOff2/10, camoTwoScale/10, camoTwoRadius);
      if (bNoiseThree)camoLine(camo, 0, spacing/2, camoThreeOff1, camoThreeOff2/10, camoThreeScale/10, camoThreeRadius);
      if (bNoiseFour) camoLine(camo, spacing/2, spacing/2, camoFourOff1, camoFourOff2/10, camoFourScale/10, camoFourRadius);

      camo.endDraw();
    }

    iterator++;

  }

  void display(){

    // draw independant buffers, on on top of each other
    if (bIndBuffer){

      push();
      // draw bg
      translate(viewport_w-camoW, 0);
      fill(camoBG);
      rect(0,0, camoW, camoH); // draw buffer bg

      for (int i = 0; i < numBuffers; i++){
        // show camo
        image(camoBuffers[i], 0, 0);
      }
      pop();
    }

    else {
      // show camo
      push();
      translate(viewport_w-camoW, 0);
      fill(camoBG);
      rect(0,0, camoW, camoH); // draw bg
      image(camo, 0, 0);
      pop();
    }
  }

  void camoRect(PGraphics pg, int originX, int originY, float offset1, float offset2, float s, float r, int col1, int col2){

    push();
    pg.beginDraw();

    float col = 0.0;

    for (int x = originX, i = 0; x < camoW; x += spacing){
      for (int y = originY; y < camoH; y += spacing, i++){

        float off = offset1 * (float)simplex.eval(offset2 * x, offset2 * y);
        float ns = 0.0;

        float easeT = ease(t, 1.0);
        float p = 1.0 * i / i;

        if (bSeed){
          // map(pNoiseSeed(x, y, offset(p)-t, r, s), -1, 1, 0, 255);
          ns = (float)simplex.eval(s * x, s * y, seed + r * sin(TWO_PI * easeT + off), r * cos(TWO_PI * easeT + off));
        }
        else{
          ns = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off));
        }


        if (smooth){
          // col = map(ns, -1, 1, 0, 255);
          // map(pNoise(offset(p)-t, r), -1, 1, 0, 255);
          col = map(ns, -1, 1, 0, 255);
        }
        else if (stark){
          int threshold = 0;
          boolean b = ns > threshold;
          col = b?col1:col2;
          alpha = b?col1:col2;
        }
        else if (gradient){
          float c = map(ns, -1, 1, 0, 255);

          // 4 colours
          if (c <= r1){
            col = low;
          }
          else if (c > r1 && c <= r2){
            col = lowmid;
          }
          else if (c > r2 && c <= r3){
            col = highmid;
          }
          else if (c > r3 && c <= r4){
            col = high;
          }
        }

        // set style and draw
        pg.stroke(col, alpha);
        pg.fill(col, alpha);
        if (bRect)  pg.rect(x, y, spacing/2, spacing/2);
        if (!bRect) pg.point(x+(spacing/2), y+(spacing/2));
      }
    }

    pg.endDraw();
    pop();
  }

  void camoLine(PGraphics pg, int originX, int originY, float offset1, float offset2, float s, float r){

    push();
    pg.beginDraw();

    float col = 0.0;

    for (int x = originX, i = 0; x < camoW; x += spacing){
      for (int y = originY; y < camoH; y += spacing, i++){

        float off = offset1 * (float)simplex.eval(offset2 * x, offset2 * y);
        float ns = 0.0;

        float easeT = ease(t, 1.0);
        float p = 1.0 * i / i;

        if (bSeed){
          // map(pNoiseSeed(x, y, offset(p)-t, r, s), -1, 1, 0, 255);
          ns = (float)simplex.eval(s * x, s * y, seed + r * sin(TWO_PI * easeT + off), r * cos(TWO_PI * easeT + off));
        }
        else{
          ns = (float)simplex.eval(s * x, s * y, r * sin(TWO_PI * t + off), r * cos(TWO_PI * t + off));
        }

        float c = map(ns, -1, 1, 0, 255);
        // int newS = (int)map(ns, -1, 1, 8, 32);
        // spacing = newS;

        // 4 colours
        if (c <= r1){
          col = low;
        }
        else if (c > r1 && c <= r2){
          col = lowmid;
        }
        else if (c > r2 && c <= r3){
          col = highmid;
        }
        else if (c > r3 && c <= r4){
          col = high;
        }

        // set style and draw
        pg.stroke(col, alpha);
        pg.fill(col, alpha);
        if (ns < 0) {
          pg.line(x, y, x + spacing/2, y + spacing/2);
        }
        else {
          pg.line(x, y + spacing/2, x + spacing/2, y);
        }
      }
    }

    pg.endDraw();
    pop();
  }

  // // 1-periodic function from a circle in noise
  float pNoise(int x, int y, float q, float r, float s){
    return (float)simplex.eval(s * x, s * y, r * cos(TWO_PI * q), r * sin(TWO_PI * q));
  }

  float pNoiseSeed(int x, int y, float q, float r, float s){
    return (float)simplex.eval(s * x, s * y, seed + r * cos(TWO_PI * q), r * sin(TWO_PI * q));
  }

  float pNoiseEase(int x, int y, float q, float r, float s, float amt){
    float et = ease(q, amt);
    return (float)simplex.eval(s * x, s * y, seed + r * cos(TWO_PI * q), r * sin(TWO_PI * q));
  }

  float offset(float p){
    return 5.0*pow(p,3.0);
  }

  float ease(float p, float g) {
    if (p < 0.5)
      return 0.5 * pow(2*p, g);
    else
      return 1 - 0.5 * pow(2*(1 - p), g);
  }


}
