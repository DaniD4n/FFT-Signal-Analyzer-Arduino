import processing.serial.*;
import ddf.minim.analysis.*;
import controlP5.*;

Serial myPort;
FFT fft;
ControlP5 cp5;

// --- Buffers ---
int bufferSize = 1024;
int[] waveBuffer = new int[bufferSize];
int index = 0;

// --- FFT ---
int fftSize = 1024;
float[] fftBuffer = new float[fftSize];
int fftIndex = 0;
boolean fftReady = false;

// --- Settings ---
float waveformScaleY = 1.0;   // amplitude scale
float waveformScaleX = 1.0;   // time scale
float fftMaxFreq = 4000;      // default Nyquist
boolean logScale = false;

// --- Serial Port UI ---
DropdownList portList;
int selectedPort = -1;

void setup() {
  size(1000, 600);
  surface.setTitle("Arduino Waveform + FFT Viewer");
  
  // UI
  cp5 = new ControlP5(this);

  portList = cp5.addDropdownList("Ports")
    .setPosition(20, 20)
    .setSize(200, 200);
  for (int i = 0; i < Serial.list().length; i++) {
    portList.addItem(Serial.list()[i], i);
  }

  cp5.addSlider("waveformScaleY")
     .setPosition(250, 20)
     .setSize(150, 20)
     .setRange(0.1, 5.0)
     .setValue(1.0)
     .setLabel("Waveform Amplitude");

  cp5.addSlider("waveformScaleX")
     .setPosition(250, 50)
     .setSize(150, 20)
     .setRange(1.0, 5.0)
     .setValue(1.0)
     .setLabel("Waveform Time Zoom");

  cp5.addSlider("fftMaxFreq")
     .setPosition(520, 20)
     .setSize(150, 20)
     .setRange(500, 4000)
     .setValue(4000)
     .setLabel("FFT Range (Hz)");

  cp5.addToggle("logScale")
     .setPosition(520, 50)
     .setSize(20, 20)
     .setValue(false)
     .setLabel("Log FFT");

  fft = new FFT(fftSize, 8000);
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  noFill();

  // --- Waveform ---
  beginShape();
  for (int i = 0; i < bufferSize; i++) {
    int idx = (index + i) % bufferSize;
    float x = map(i, 0, bufferSize/waveformScaleX, 0, width);
    float y = map(waveBuffer[idx]*waveformScaleY, 0, 255, height/2-200, 50);
    vertex(x, y);
  }
  endShape();

  // --- FFT ---
  if (fftReady) {
    fft.forward(fftBuffer);
    stroke(0, 100, 255);
    int bins = fft.specSize();
    float nyquist = 8000 / 2.0;
    float maxFreq = min(fftMaxFreq, nyquist);
    int maxBin = int(map(maxFreq, 0, nyquist, 0, bins));

    for (int i = 1; i < maxBin; i++) {
      float x = map(i, 0, maxBin, 0, width);
      float y;
      if (logScale) {
        float logMin = log(1);
        float logMax = log(fft.getBand(i));
        y = log(1+fft.getBand(i-4))*40;
      } else {
        y = fft.getBand(i) * 2;
      }
      line(x, height-50, x, height-50-y);
    }
    // frequency axis with relative spacing
    int steps = 8;  // number of divisions
    for (int n = 0; n <= steps; n++) {
      float hz = (maxFreq / (float)steps) * n;   // frequency at this step
      float x = map(hz, 0, maxFreq, 0, width);   // where to draw it
    
      stroke(150);
      line(x, height-50, x, height-45);  // small tick
    
      fill(200);
      textAlign(CENTER, TOP);
      text(int(hz) + " Hz", x, height-40);
    }
  }
}

void serialEvent(Serial p) {
  int val = p.read() & 0xFF;
  waveBuffer[index] = val;
  index = (index + 1) % bufferSize;
  fftBuffer[fftIndex] = val - 128;
  fftIndex++;
  if (fftIndex >= fftSize) {
    fftIndex = 0;
    fftReady = true;
  }
}

void controlEvent(ControlEvent e) {
  if (e.isFrom(portList)) {
    selectedPort = int(e.getValue());
    if (myPort != null) myPort.stop();
    myPort = new Serial(this, Serial.list()[selectedPort], 115200);
    myPort.clear();
    println("Connected to " + Serial.list()[selectedPort]);
  }
}
