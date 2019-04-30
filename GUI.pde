import controlP5.*;
ControlP5 cp5;

// Styling
color lightGrey = color(170,170,170);
color darkGrey = color(44,48,55);
color labelColour = color(0,0,0);
color guiBG = color(0, 0, 0);

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

  void init(PApplet p){
    push();

    cp5 = new ControlP5(p);
    cp5.setAutoDraw(false);

    setStyling();
    createGroups();

    createControls();
    createAccordian();

    pop();

  }

  void display(PApplet p){
    push();
    hint(DISABLE_DEPTH_TEST);
    fill(guiBG);
    rect(0,0, guiW, guiH);
    cp5.draw();
    hint(ENABLE_DEPTH_TEST);
    pop();
  }

  void createGroups(){
    // noise
    noiseGroupOne = cp5.addGroup("Noise One").setBackgroundHeight(50);
    noiseGroupTwo = cp5.addGroup("Noise Two").setBackgroundHeight(50);
    noiseGroupThree = cp5.addGroup("Noise Three").setBackgroundHeight(50);
    noiseGroupFour = cp5.addGroup("Noise Four").setBackgroundHeight(50);

    // global
    globalGroup = cp5.addGroup("Global Settings").setBackgroundHeight(150);
  }

  void setStyling(){
    cp5.setColorForeground(lightGrey);
    cp5.setColorBackground(darkGrey);
    cp5.setColorActive(lightGrey);
  }

  void createAccordian(){

    accordion = cp5.addAccordion("acc").setPosition(40,40).setWidth(200)
                .addItem(globalGroup).addItem(noiseGroupOne).addItem(noiseGroupTwo).addItem(noiseGroupThree).addItem(noiseGroupFour);

    accordion.open(0);
    accordion.close(1,2,3,4);
    accordion.setCollapseMode(Accordion.MULTI);
  }

  void createControls(){
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
  void globalControls(int x, int y, Group g){

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

  void noiseControls(int x, int y, String s, String r, String o1, String o2, Group g){
    cp5.addSlider(s).setLabel("scale").setRange(0.01,0.5).setValue(0.02).setPosition(x,y).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(r).setLabel("radius").setRange(0.01,0.5).setValue(0.1).setPosition(x,y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(o1).setLabel("off1").setRange(1,9).setValue(1).setPosition(x,y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(o2).setLabel("off2").setRange(0.01,0.20).setValue(0.01).setPosition(x,y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
  }

  void bNoiseOne(boolean theFlag) {
    if(theFlag==true) {
      bNoiseOne = true;
    } else {
      bNoiseOne = false;
    }
    println("bNoise One = " + bNoiseOne);
  }


}
