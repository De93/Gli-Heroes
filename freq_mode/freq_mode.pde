import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

ArrayList circle = new ArrayList();
color rosso = color(255, 0, 0);
color verde = color(0, 255, 0);
color blu = color(0, 0, 255);
color giallo = color(255, 255, 0);
color bianco = color(255,255,255);

float kickSize, snareSize, hatSize;

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void setup()
{
  size(400, 700);   //larghezza e lunghezza schermo
  
  minim = new Minim(this);
  
  song = minim.loadFile("Rockabye.mp3", 1024);
  song.play();
  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  // note that what sensitivity you choose will depend a lot on what kind of audio 
  // you are analyzing. in this example, we use the same BeatDetect object for 
  // detecting kick, snare, and hat, but that this sensitivity is not especially great
  // for detecting snare reliably (though it's also possible that the range of frequencies
  // used by the isSnare method are not appropriate for the song).
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  
}

void draw()
{
  background(50,20,20);  //sfondo marrone scuro (RGB)
  
  // draw a green rectangle for every detect band
  // that had an onset this frame
  
  fill(170,170,170);                //corde chitarra
  stroke(255);                   //corde con contorno bianco 
  rect(40,  0, 20, 700);        //(x=distanza dal bordo di sinistra, y partenza, larghezza linea, y di fine=lunghezza)
  rect(140, 0, 20, 700);
  rect(240, 0, 20, 700);
  rect(340, 0, 20, 700);
 
  class tiles {
  PVector location;
  Boolean gone=false;

  tiles(float i) {
    location = new PVector(i*100, 0);
  }
void run() {
    display();
    move();
  }

  void display() {
    fill(location.x==0?rosso:location.x==100?verde:location.x==200?blu:giallo);
    ellipse(location.x+50,location.y, 80, 80);
    stroke(0); //contorno nero
    strokeWeight(4); //spessore contorno
  }

  void move() {
    location.y+=2;                   //velocita
  }}

tiles nota = new tiles(int(random(0, 4)));
for(int i = 0; i < beat.detectSize(); ++i)
  { // test one frequency band for an onset
     if ( beat.isOnset(i) ){
                             circle.add(nota);
                            }
  
  
  for (int j=0; j<circle.size(); j++) {
    tiles pallino = (tiles) circle.get(j);
    pallino.run();
    pallino.display();
    pallino.move(); 
  }
 }
}