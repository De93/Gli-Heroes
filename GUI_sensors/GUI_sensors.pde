import controlP5.*;
import java.util.*;
import grafica.*;
import ddf.minim.*;
import processing.serial.*; 

/* per poter cominciare la comunicazione seriale è prima necessario aprire l'IDE di Arduino, fare un nuovo sketch contenente il seguente codice e caricarlo sull' Arduino:
void setup() {
Serial.begin(9600);
}

void loop() {
 Serial.write(analogRead(A0)/4);
delay(1);
}
Così facendo, una volta caricato lo sketch sull'Arduino, ha inizio la comunicazione seriale tra PC e Arduino e possiamo, dunque, leggere i valori del potenziometro tramite Processing
*/

Serial myPort; 

//inizializzazione degli elementi della gui
ControlP5 menu_canzoni; //menù a tendina
ControlP5 titolo;  //elemento testuale
ControlP5 bottone;


String oggetto_premuto;
int canzone_selezionata = -1;
int fai_partire=-1;

//Variabile valore potenziometro
int sensorValue;

//Variabili per la riproduzione della canzone
Minim musica; //inizializzazione della funzione per far partire la musica
AudioPlayer canzone1;
AudioPlayer canzone2;
AudioPlayer canzone3;
AudioPlayer canzone4;
AudioPlayer canzone5;

//variabili per pallini
ArrayList circle = new ArrayList();
int score=0;
color rosso = color(255, 0, 0);
color verde = color(0, 255, 0);
color blu = color(0, 0, 255);
color giallo = color(255, 255, 0);
color bianco = color(255,255,255);

void setup() {
  
  size(900, 950); //Dimensione dell'interfaccia grafica
  
  //comincio comunicazione seriale
    myPort = new Serial(this, "COM3",9600);
    
  //carico le canzoni
  musica=new Minim (this); //Creo la funzione che fa partire la canzone
  canzone1 = musica.loadFile("Rockabye.mp3");  
  canzone2 = musica.loadFile("Wings of Love.mp3");
  canzone3 = musica.loadFile("Money For Nothing.mp3");
  canzone4 = musica.loadFile("Two Princess.mp3");
  canzone5 = musica.loadFile("Void.mp3");
  
 
  //Creo l'elemento della GUI menù a tendina
  menu_canzoni = new ControlP5(this); 
  
  //Array con i titoli delle canzoni
  List lista_canzoni = Arrays.asList("Rockabye", "Wings of Love", "Money For Nothing", "Two Princess", "Void", "Carica la tua canzone"); //Array che contiene gli elementi del menù a tendina
  
  //Creo il e personalizzo il menu a tendina
  menu_canzoni.addScrollableList("canzoni")
     .setPosition(30, 200)
     .setSize(300, 200)
     .setBarHeight(45)
     .setItemHeight(45)
     .addItems(lista_canzoni)
     .setOpen(false)
     .setFont(createFont("Arial",15, true))
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
   
   //Creo la scritta GUITAR HERO e la personalizzo
   titolo = new ControlP5(this);
   titolo.addTextlabel("label")
                    .setText("GUITAR HERO")
                    .setPosition(300,20)
                    .setColorValue(0xf0000fff)
                    .setFont(createFont("Georgia",50))
                    ;
   
   //Creo l'elemento bottone
   bottone = new ControlP5(this);
   

     //Creo il bottone con scritto PLAY e lo personalizzo
  bottone.addButton("PLAY")
         .setValue(0)
         .setPosition(55,450)
         .setSize(103,50)
         .setFont(createFont("Arial",25, true))
         .setOff()
         ;
   
  //Creo il bottone con scritto PAUSE e lo personalizzo
  bottone.addButton("PAUSE")
         .setValue(0)
         .setPosition(203,450)
         .setSize(103,50)
         .setFont(createFont("Arial",25, true))
         ; 
  
  //Creo il bottone con scritto STOP e lo personalizzo
  bottone.addButton("STOP")
         .setValue(0)
         .setPosition(120,530)
         .setSize(103,50)
         .setFont(createFont("Arial",25, true))
         ;
         
  
     
}


void draw() {
   
 // PImage img;
 //img = loadImage("guitar_hero.png");
 // background(img);
  background(171,205,239);
  
  strokeWeight(1);
  stroke(50,20,20);
  fill (50,20,20);
  rect(380,100,480,850);
  
  fill(170,170,170);                //corde chitarra
  stroke(255);                   //corde con contorno bianco 
  rect(460, 100, 20, 850);        //(x=distanza dal bordo di sinistra, y partenza, larghezza linea, y di fine=lunghezza)
  rect(560, 100, 20, 850);
  rect(660, 100, 20, 850);
  rect(760, 100, 20, 850);
  
 while(myPort.available()>0){
      sensorValue = myPort.read();
      println(sensorValue); // stampa nel riquadro console (in basso) i valori letti dal sensore
  
      //dice che il rettangolo deve apparire nella prima colonna
      if (0 <= sensorValue && sensorValue <= 255) {
        float x_cursore;
        float sensorValue_normalized= sensorValue *1.176; // valore del sensore (da 0 a 255) * larghezza finestra/val_max_sensore
        x_cursore = sensorValue_normalized + 470;
        stroke(153);
        noFill();
        ellipse(x_cursore,850, 100, 100); //determina posizione e dimensione
      }
}

  
  
  if (canzone1.isPlaying() || canzone2.isPlaying()||canzone3.isPlaying()|| canzone4.isPlaying()||canzone5.isPlaying()){
 
 strokeWeight(1);
 tiles nota = new tiles(int(random(0, 4)));   //N.B. qui bisogna mettere codice per il BeatDetector!!!

  if (frameCount%50==0) {            //note generate per secondo, frameCount%10=6 note/secondo, Processing ha un valore di default del “frameRate” di 60
    circle.add(nota);
  } 
  
  for (int i=0; i<circle.size(); i++) {
    tiles pallino = (tiles) circle.get(i);
    pallino.run();
    pallino.display();
    pallino.move();
   }
  }
  
}


void canzoni(int n) {

  /* request the selected item based on index n */
  println(n, menu_canzoni.get(ScrollableList.class, "canzoni").getItem(n));
    
  //CColor c = new CColor();
  //c.setBackground(color(255,0,0));
  //menu_canzoni.get(ScrollableList.class, "canzoni").getItem(n).put("color", c);
  //println(n);
} 


void PLAY (int i){
    if(canzone_selezionata==0){
    if ( canzone2.isPlaying() || canzone3.isPlaying()|| canzone4.isPlaying()||canzone5.isPlaying() )
  {
    canzone2.pause();
    canzone2.rewind();
    canzone3.pause();
    canzone3.rewind();
    canzone4.pause();
    canzone4.rewind();
    canzone5.pause();
    canzone5.rewind();
    canzone1.play();
  }
    
    else if (canzone1.isPlaying()){
    
  }
  else{
  canzone1.play();
  }
  }
  //Se viene selezionata la canzone 2 la fa partire
  if(canzone_selezionata==1){
    if ( canzone1.isPlaying() || canzone3.isPlaying()|| canzone4.isPlaying()||canzone5.isPlaying() )
  {
    canzone1.pause();
    canzone1.rewind();
    canzone3.pause();
    canzone3.rewind();
    canzone4.pause();
    canzone4.rewind();
    canzone5.pause();
    canzone5.rewind();
    canzone2.play();
  }
    
    else if (canzone2.isPlaying()){
    
  }
  else{
  canzone2.play();
  }
  }
 
  
  //Se viene selezionata la canzone 3 la fa partire
  if(canzone_selezionata==2){
    if ( canzone1.isPlaying() || canzone2.isPlaying()|| canzone4.isPlaying()||canzone5.isPlaying() )
  {
    canzone1.pause();
    canzone1.rewind();
    canzone2.pause();
    canzone2.rewind();
    canzone4.pause();
    canzone4.rewind();
    canzone5.pause();
    canzone5.rewind();
    canzone3.play();
  }
    
    else if (canzone3.isPlaying()){
    
  }
  else{
  canzone3.play();
  }
  }
  
  
      //Se viene selezionata la canzone 4 la fa partire
    if(canzone_selezionata==3){
    if ( canzone1.isPlaying() || canzone2.isPlaying()|| canzone3.isPlaying()||canzone5.isPlaying() )
  {
    canzone1.pause();
    canzone1.rewind();
    canzone2.pause();
    canzone2.rewind();
    canzone3.pause();
    canzone3.rewind();
    canzone5.pause();
    canzone5.rewind();
    canzone4.play();
  }
    
    else if (canzone4.isPlaying()){
    
  }
  else{
  canzone4.play();
  }
  }
  
  
      //Se viene selezionata la canzone 5 la fa partire
  if(canzone_selezionata==4){
    if ( canzone1.isPlaying() || canzone2.isPlaying()|| canzone3.isPlaying()||canzone4.isPlaying() )
  {
    canzone1.pause();
    canzone1.rewind();
    canzone2.pause();
    canzone2.rewind();
    canzone3.pause();
    canzone3.rewind();
    canzone4.pause();
    canzone4.rewind();
    canzone5.play();
  }
    
    else if (canzone5.isPlaying()){

  }
  else{
  canzone5.play();
  }
  }
}  
 

void PAUSE (int i){
 
if ( canzone1.isPlaying() || canzone2.isPlaying()|| canzone3.isPlaying()||canzone4.isPlaying()||canzone5.isPlaying() ){
    canzone1.pause();
    canzone2.pause();
    canzone3.pause();
    canzone4.pause();
    canzone5.pause();
  }
}

void STOP (int j){
 if ( canzone1.isPlaying() || canzone2.isPlaying()|| canzone3.isPlaying()||canzone4.isPlaying()||canzone5.isPlaying() ){
    canzone1.pause();
    canzone1.rewind();
    canzone2.pause();
    canzone2.rewind();
    canzone3.pause();
    canzone3.rewind();
    canzone4.pause();
    canzone4.rewind();
    canzone5.pause();
    canzone5.rewind();
 }

}
  


void controlEvent(ControlEvent theEvent)
{
  if(theEvent.isGroup())
  {
    ;
  }
  else if (theEvent.isController())
  {
    oggetto_premuto = theEvent.getController().toString();
    println(oggetto_premuto);
    
   
    if (oggetto_premuto.equals("canzoni [ScrollableList]")) //Questa mi serve se ho più controller, se no va tutto in canzone_selezionata
    {
      canzone_selezionata = int(theEvent.getController().getValue());
    }
  }
}


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
    println(location.x);
    ellipse(location.x+470,location.y+100, 80, 80);
    stroke(0); //contorno nero
    strokeWeight(4); //spessore contorno
  }

  void move() {
    location.y+=2;                   //velocita
  }
  


}