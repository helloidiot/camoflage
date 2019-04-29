import controlP5.*;
ControlP5 cp5;

// Styling
color lightGrey = color(170,170,170);
color darkGrey = color(44,48,55);

// Sizing
int sliderWidth = 100;
int sliderHeight = 20;

class GUI {

  void init(PApplet p){
    push();

    cp5 = new ControlP5(p);
    cp5.setAutoDraw(false);

    // Set Styling
    cp5.setColorForeground(lightGrey);
    cp5.setColorBackground(darkGrey);
    cp5.setColorActive(lightGrey);

    //createLabels();
    //createButtons();
    createSliders();

    pop();
  }

  void display(PApplet p){
    hint(DISABLE_DEPTH_TEST);
    cp5.draw();
    hint(ENABLE_DEPTH_TEST);
  }

  void createSliders(){
    // Frequency
    cp5.addSlider("scale1").setLabel("scale1").setRange(0.01,0.05).setValue(0.0001).setPosition(10,10).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("radius1").setLabel("radius1").setRange(0.01,0.05).setValue(0.01).setPosition(10,30).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("off1").setLabel("off1").setRange(1,9).setValue(1).setPosition(10,50).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("off2").setLabel("off2").setRange(0.01,0.05).setValue(0.01).setPosition(10,70).setSize(sliderWidth,sliderHeight);
    cp5.addSlider("numFrames").setLabel("numFrames").setRange(24,240).setValue(48).setPosition(10,90).setSize(sliderWidth,sliderHeight);
    //cp5.addSlider("spacing").setLabel("spacing").setRange(4,64).setValue(16).setNumberOfTickMarks(31).setPosition(10,90).setSize(sliderWidth,sliderHeight);
  }


}
