

// Noise
float scale1;// = 0.001;
float radius1;// = 0.1;
float scale2 = 0.002;
float radius2 = 0.2;
float scale3 = 0.003;
float radius3 = 0.3;
float scale4 = 0.004;
float radius4 = 0.4;
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

  void init(){

    simplex = new OpenSimplexNoise();
    moire1 = createGraphics(viewport_w, viewport_h);
    moire2 = createGraphics(viewport_w, viewport_h);
    moire3 = createGraphics(viewport_w, viewport_h);
    moire4 = createGraphics(viewport_w, viewport_h);

    camo = createGraphics(viewport_w, viewport_h);

  }

  void update(){

    float t = 1.0 * iterator / numFrames;

    camo.beginDraw();

    // Three nice patterns
    // createCamoRect(camo, 0, 0, 2, 0.005, 0.006, 0.1, 0, 255);
    // createCamoRect(camo, spacing/2, spacing/2, 3, 0.001, 0.002, 0.2, 0, 255);
    // createCamoRect(camo, 0, spacing/2, 4, 0.0005, 0.004, 0.4, 0, 255);

    // Three nice patterns
    createCamoRect(camo, 0, 0, off1, off2, scale1, radius1, 0, 255);
    createCamoRect(camo, spacing/2, spacing/2, 2, 0.002, 0.002, 0.2, 255, 255);
    createCamoRect(camo, 0, spacing/2, 3, 0.003, 0.003, 0.4, 0, 255);

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

  void display(){
    showFPS();

    image(camo, 0, 0);
  }

  void createCamoRect(PGraphics pg, int originX, int originY, float offset1, float offset2, float s, float r, int col1, int col2){

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

  void createCamoLine(PGraphics pg, int originX, int originY, float offset1, float offset2, float s, float r, int col1, int col2){

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
