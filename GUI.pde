import controlP5.*;
ControlP5 cp5;

// Styling
color lightGrey = color(170,170,170);
color darkGrey = color(44,48,55);
color labelColour = color(0,0,0);

// Sizing
int sliderWidth = 100;
int sliderHeight = 20;
int sliderY = 10;
int sliderX = 10;
int sliderSpacing = sliderHeight+10;

class GUI {

  void init(PApplet p){
    push();

    cp5 = new ControlP5(p);
    cp5.setAutoDraw(false);

    setStyling();

    //createLabels();
    //createButtons();
    createGlobalSliders(sliderX, viewport_h-100);
    createCamoSliders();

    pop();
  }

  void setStyling(){
    // Set Styling
    cp5.setColorForeground(lightGrey);
    cp5.setColorBackground(darkGrey);
    cp5.setColorActive(lightGrey);
  }

  void display(PApplet p){
    hint(DISABLE_DEPTH_TEST);
    cp5.draw();
    hint(ENABLE_DEPTH_TEST);
  }

  void createCamoSliders(){
    push();
    createCamoOneSliders(sliderX, sliderY);
    createCamoTwoSliders(sliderX, 150);
    createCamoThreeSliders(sliderX, 300);
    createCamoFourSliders(sliderX, 450);
    pop();
  }

  void createLabels(){

  }

  // global controls
  void createGlobalSliders(int x, int y){
    //cp5.addSlider("spacing").setLabel("spacing").setRange(4,64).setValue(16).setNumberOfTickMarks(31).setPosition(10,90).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("numFrames").setLabel("numFrames").setRange(24,240).setValue(48).setPosition(x,y).setSize(sliderWidth,sliderHeight);
  }

  // camo controls
  void createCamoOneSliders(int x, int y){
    cp5.addSlider("camoOneScale").setLabel("scale").setRange(0.01,0.5).setValue(0.02).setPosition(x,y).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoOneRadius").setLabel("radius").setRange(0.01,0.5).setValue(0.1).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoOneOff1").setLabel("off1").setRange(1,9).setValue(1).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoOneOff2").setLabel("off2").setRange(0.01,0.05).setValue(0.01).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
  }

  void createCamoTwoSliders(int x, int y){
    cp5.addSlider("camoTwoScale").setLabel("scale").setRange(0.01,0.5).setValue(0.02).setPosition(x,y).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoTwoRadius").setLabel("radius").setRange(0.01,0.5).setValue(0.1).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoTwoOff1").setLabel("off1").setRange(1,9).setValue(1).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoTwoOff2").setLabel("off2").setRange(0.01,0.05).setValue(0.01).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
  }

  void createCamoThreeSliders(int x, int y){
    cp5.addSlider("camoThreeScale").setLabel("scale").setRange(0.01,0.5).setValue(0.02).setPosition(x,y).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoThreeRadius").setLabel("radius").setRange(0.01,0.5).setValue(0.1).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoThreeOff1").setLabel("off1").setRange(1,9).setValue(1).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoThreeOff2").setLabel("off2").setRange(0.01,0.05).setValue(0.01).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
  }

  void createCamoFourSliders(int x, int y){
    cp5.addSlider("camoFourScale").setLabel("scale").setRange(0.01,0.5).setValue(0.02).setPosition(x,y).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoFourRadius").setLabel("radius").setRange(0.01,0.5).setValue(0.1).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoFourOff1").setLabel("off1").setRange(1,9).setValue(1).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("camoFourOff2").setLabel("off2").setRange(0.01,0.05).setValue(0.01).setPosition(x,y+=sliderSpacing).setSize(sliderWidth,sliderHeight);
  }


}
