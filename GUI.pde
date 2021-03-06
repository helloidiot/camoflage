import controlP5.*;
ControlP5 cp5;

// Styling
color guiFore = color(170,170,170);
color guiActive = color(200,0,0);
color guiBack = color(44,48,55);
color guiBG = color(0, 0, 0);

int guiW = viewport_w;
int guiH = viewport_h;


// Sizing
int sliderW = 100;
int sliderH = 15;
PVector sliderPos = new PVector(10, 10);
int sliderPadding = 10;
int sliderSpacing = sliderH+sliderPadding;

int toggleW = 20;
int toggleH = sliderH;
int toggleSpacingX = 40;
int toggleSpacingY = 10;
int controlGap = 30;

// TODO
// gradient sliders

Accordion accordion;
int accordionW = 200;
int accordionH = 150;
Group noiseGroupOne, noiseGroupTwo, noiseGroupThree, noiseGroupFour, animationGroup, styleGroup;

String filename;

class GUI {

  void init(PApplet p){
    push();

    cp5 = new ControlP5(p);
    cp5.setAutoDraw(false);

    setGlobalStyling();
    createGroups();
    createAccordian();
    createControls();

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
    noiseGroupOne = cp5.addGroup("Noise One").setBackgroundHeight(accordionH);
    noiseGroupTwo = cp5.addGroup("Noise Two").setBackgroundHeight(accordionH);
    noiseGroupThree = cp5.addGroup("Noise Three").setBackgroundHeight(accordionH);
    noiseGroupFour = cp5.addGroup("Noise Four").setBackgroundHeight(accordionH);

    // global
    animationGroup = cp5.addGroup("Animation Settings").setBackgroundHeight(accordionH);

    // style
    styleGroup = cp5.addGroup("Style Settings").setBackgroundHeight(350);
  }

  void setGlobalStyling(){
    cp5.setColorForeground(guiFore);
    cp5.setColorBackground(guiBack);
    cp5.setColorActive(guiActive);
  }

  void createAccordian(){
    accordion = cp5.addAccordion("accordion").setPosition(sliderPos.x,sliderPos.y).setWidth(accordionW)
                .addItem(animationGroup).addItem(styleGroup).addItem(noiseGroupOne).addItem(noiseGroupTwo).addItem(noiseGroupThree).addItem(noiseGroupFour);

    accordion.open(0,1);
    accordion.close(2,3,4,5);
    accordion.setCollapseMode(Accordion.MULTI);
  }

  void createControls(){
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
  void animationControls(PVector p, Group g){

    PVector _p = new PVector(p.x, p.y);

    cp5.addSlider("numFrames").setLabel("numFrames").setRange(24,240).setValue(48).setPosition(p.x,_p.y).setSize(sliderW,sliderH).moveTo(g);

    cp5.addToggle("bNoiseOne").setLabel("Noise 1").setPosition(_p.x,_p.y+=sliderSpacing).setSize(toggleW,toggleH).setValue(false).moveTo(g);
    cp5.addToggle("bNoiseTwo").setLabel("Noise 2").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).setValue(false).moveTo(g);
    cp5.addToggle("bNoiseThree").setLabel("Noise 3").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).setValue(false).moveTo(g);
    cp5.addToggle("bNoiseFour").setLabel("Noise 4").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).setValue(false).moveTo(g);

    cp5.addButton("exportStill").setPosition(p.x,_p.y+=sliderSpacing*2).setSize(sliderW,sliderH).moveTo(g);
    cp5.addButton("exportSequence").setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
  }

  // global controls
  void styleControls(PVector p, Group g){

    PVector _p = new PVector(p.x, p.y);

    cp5.addSlider("spacing").setLabel("spacing").setRange(0,64).setValue(16).setNumberOfTickMarks(31).setPosition(_p.x,_p.y).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider("camoBG").setLabel("background").setRange(0,255).setValue(10).setNumberOfTickMarks(255).setPosition(_p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);

    // shading choices
    cp5.addToggle("smooth").setPosition(_p.x,_p.y+=controlGap).setSize(toggleW,toggleH).moveTo(g);
    cp5.addToggle("stark").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).moveTo(g);
    cp5.addToggle("gradient").setPosition(_p.x+=toggleSpacingX,_p.y).setSize(toggleW,toggleH).moveTo(g);

    cp5.addSlider("r1").setLabel("range 1").setRange(0,255).setValue(85).setPosition(p.x,_p.y+=sliderSpacing*2).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider("r2").setLabel("range 2").setRange(0,255).setValue(128).setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider("r3").setLabel("range 3").setRange(0,255).setValue(192).setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider("r4").setLabel("range 4").setRange(0,255).setValue(255).setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);

    cp5.addSlider("low").setLabel("low").setRange(0,255).setValue(0).setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider("lowmid").setLabel("lowmid").setRange(0,255).setValue(128).setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider("highmid").setLabel("highmid").setRange(0,255).setValue(192).setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider("high").setLabel("high").setRange(0,255).setValue(255).setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);

    cp5.addSlider("alpha").setLabel("alpha").setRange(0,255).setValue(255).setPosition(p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);

  }

  void noiseControls(PVector p, String s, String r, String o1, String o2, Group g){

    PVector _p = new PVector(p.x, p.y);

    cp5.addSlider(s).setLabel("scale").setRange(0.01,0.5).setValue(0.02).setPosition(_p.x,_p.y).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(r).setLabel("radius").setRange(0.01,0.5).setValue(0.1).setPosition(_p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(o1).setLabel("off1").setRange(1,9).setValue(1).setPosition(_p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
    cp5.addSlider(o2).setLabel("off2").setRange(0.01,0.20).setValue(0.01).setPosition(_p.x,_p.y+=sliderSpacing).setSize(sliderW,sliderH).moveTo(g);
  }



}
