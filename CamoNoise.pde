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

  void init(){

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

  void update(){

    float t = 1.0 * iterator / numFrames;

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

  void display(){

    // show camo
    push();
    translate(viewport_w-camoW, 0);
    // draw bg
    fill(camoBG);
    rect(0,0, camoW, camoH);
    image(camo, 0, 0);
    pop();
  }

  void camoRect(PGraphics pg, int originX, int originY, float offset1, float offset2, float s, float r, int col1, int col2){

    push();
    pg.beginDraw();

    float col = 0.0;

    for (int x = originX, i = 0; x < viewport_w; x += spacing){
      for (int y = originY; y < viewport_h; y += spacing, i++){

        float off = offset1 * (float)simplex.eval(offset2 * x, offset2 * y);
        float ns = 0.0;

        float easeT = ease(t, 1.0);
        float p = 1.0 * i / i;

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
  float pNoise(float q, float r){
    return (float)simplex.eval(seed + r * cos(TWO_PI * q), r * sin(TWO_PI * q));
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
