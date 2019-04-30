

// Noise
float camoOneScale, camoTwoScale, camoThreeScale, camoFourScale;
float camoOneRadius, camoTwoRadius, camoThreeRadius, camoFourRadius;
float scale2 = 0.002;
float radius2 = 0.2;


float scale3 = 0.003;
float radius3 = 0.3;
float scale4 = 0.004;
float radius4 = 0.4;

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

  void init(){

    simplex = new OpenSimplexNoise();
    // moire1 = createGraphics(camoW, camoH);
    // moire2 = createGraphics(camoW, camoH);
    // moire3 = createGraphics(camoW, camoH);
    // moire4 = createGraphics(camoW, camoH);

    camo = createGraphics(camoH, camoH);

  }

  void update(){

    float t = 1.0 * iterator / numFrames;

    camo.beginDraw();
    camo.clear(); // empty the buffer

    // Three nice patterns
    // camoRect(camo, 0, 0, 2, 0.005, 0.006, 0.1, 0, 255);
    // camoRect(camo, spacing/2, spacing/2, 3, 0.001, 0.002, 0.2, 0, 255);
    // camoRect(camo, 0, spacing/2, 4, 0.0005, 0.004, 0.4, 0, 255);

    // Three nice patterns
    // camoRect(camo, 0, 0, camoOneOff1, camoOneOff2/10, camoOneScale/10, camoOneRadius, 0, 255);
    // camoRect(camo, spacing/2, spacing/2, camoTwoOff1, camoTwoOff2/10, camoTwoScale/10, camoTwoRadius, 0, 255);
    // camoRect(camo, 0, spacing/2, camoThreeOff1, camoThreeOff2/10, camoThreeScale/10, camoThreeRadius, 0, 255);

    // // Four not as interesting patterns
    if (bNoiseOne)  camoRect(camo, 0, 0, camoOneOff1, camoOneOff2/10, camoOneScale/10, camoOneRadius, 0, 255);
    if (bNoiseTwo)  camoRect(camo, spacing/2, 0, camoTwoOff1, camoTwoOff2/10, camoTwoScale/10, camoTwoRadius, 0, 255);
    if (bNoiseThree)camoRect(camo, 0, spacing/2, camoThreeOff1, camoThreeOff2/10, camoThreeScale/10, camoThreeRadius, 0, 255);
    if (bNoiseFour) camoRect(camo, spacing/2, spacing/2, camoFourOff1, camoFourOff2/10, camoFourScale/10, camoFourRadius, 0, 255);

    camo.endDraw();

    iterator++;

  }

  void display(){

    // show camo
    push();
    translate(viewport_w-camoW, 0);
    // draw bg
    fill(bg);
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

}
