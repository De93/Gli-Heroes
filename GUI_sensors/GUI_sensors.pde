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
int refresh_sfondo=1;

//Variabile valore potenziometro e pulsante
int sensorValue;
int prec_sensorValue = 5;
int puls_value = 0;
int err = 15;


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
int current_frame = 0;
int frame_interval = 30;

color rosso = color(255, 0, 0);
color verde = color(0, 255, 0);
color blu = color(0, 0, 255);
color giallo = color(255, 255, 0);
color bianco = color(255,255,255);

void setup() {
  frameRate(60);
  size(900, 950); //Dimensione dell'interfaccia grafica
  
  // Variabili font

 PFont font = loadFont("Algerian-70.vlw");  //inizializzo la variabile e stabilisco font
 PFont carattere = loadFont("Algerian-32.vlw");
 PFont char_tendina = loadFont("Algerian-24.vlw");
 
  //comincio comunicazione seriale
  myPort = new Serial(this, "COM8",9600);
    
  //carico le canzoni
  musica=new Minim (this); //Creo la funzione che fa partire la canzone
  canzone1 = musica.loadFile("Rockabye.mp3");  
  canzone2 = musica.loadFile("Wings of Love.mp3");
  canzone3 = musica.loadFile("Money For Nothing.mp3");
  canzone4 = musica.loadFile("Two Princess.mp3");
  canzone5 = musica.loadFile("Void.mp3");
  
 
  //Creo l'elemento della GUI menù a tendina
  menu_canzoni = new ControlP5(this); 
  menu_canzoni.setColorBackground(color(#050505)); // default color
  menu_canzoni.setColorActive(color(#B42D00));
  menu_canzoni.setColorForeground(color(#6F0000));
  //Array con i titoli delle canzoni
  List lista_canzoni = Arrays.asList("Rockabye", "Wings of Love", "Money For Nothing", "Two Princess", "Void"); //Array che contiene gli elementi del menù a tendina
  
  //Creo il e personalizzo il menu a tendina
  menu_canzoni.addScrollableList("canzoni")
     .setPosition(30, 200)
     .setSize(300, 200)
     .setBarHeight(45)
     .setItemHeight(45)
     .addItems(lista_canzoni)
     .setOpen(false)
     .setFont(char_tendina)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
   
   
  
  
   //Creo la scritta GUITAR HERO e la personalizzo
   titolo = new ControlP5(this);
   titolo.addTextlabel("label")
                    .setText("GUITAR HERO")
                    .setPosition(250,20)
                    .setColorValue(#050505)
                    .setFont(font)
                    ;
   
   //Creo l'elemento bottone
   bottone = new ControlP5(this);
  // bottone.setColorActive(#8B8B8B); // color for mouse-over
   bottone.setColorBackground(color(#050505)); // default color
   bottone.setColorActive(color(#B42D00));
   bottone.setColorForeground(color(#6F0000));

     //Creo il bottone con scritto PLAY e lo personalizzo
  bottone.addButton("PLAY")
         .setValue(0)
         .setPosition(55,450)
         .setSize(103,50)
         .setFont(carattere)
         .setOff()
         ;
   
  //Creo il bottone con scritto PAUSE e lo personalizzo
  bottone.addButton("PAUSE")
         .setValue(0)
         .setPosition(203,450)
         .setSize(103,50)
         .setFont(carattere)
         ; 
  
  //Creo il bottone con scritto STOP e lo personalizzo
  bottone.addButton("STOP")
         .setValue(0)
         .setPosition(120,530)
         .setSize(103,50)
         .setFont(carattere)
         ;

}


void draw() {

  if(refresh_sfondo==1 || mousePressed){ 
      PImage img;                         //riquadro esterno color legno
      img = loadImage("legno1.png");
      img.resize(900,950);
      background(img);
      refresh_sfondo = 0;
  }
  
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
    
   /* RESET BUTTON VALUE */
   
   if (puls_value == 1 && (frameCount - current_frame  >= frame_interval)) puls_value = 0;
   
     /* PARTE DI CODICE PER IL CURSORE */
  
  stroke(153);                          // contorno cerchi
  noFill();                            // per avere cerchi vuoti
  ellipse(470,850, 95, 95);         // cerchi entro cui devi centrare le note
  ellipse(570,850, 95, 95);
  ellipse(670,850, 95, 95);
  ellipse(770,850, 95, 95);  
  
  
   //dice che il cerchio giallo deve apparire nella prima colonna
     if (sensorValue == 0 ) {
       fill(255,245,157, 191); //determina il colore del rettangolo
       ellipse(470,850, 94,94); //determina posizione e dimensione
       
      }
  
  //dice che il cerchio giallo deve apparire nella seconda colonna
     if (sensorValue == 1) {
        fill(255,245,157,191); 
        ellipse(570,850, 94, 94);

     }
    
  //dice che il cerchio giallo deve apparire nella terza colonna
     if (sensorValue == 2) {
        fill(255,245,157,191); 
        ellipse(670,850, 95, 95);

     }  
    
  //dice che il cerchio giallo deve apparire nella quarta colonna
     if (sensorValue == 3) {
        fill(255,245,157,191);
        ellipse(770,850, 95, 95); 
        
     } 
     

/* PARTE DI CODICE PER LE NOTE E LA MUSICA */


 if (canzone1.isPlaying() || canzone2.isPlaying()||canzone3.isPlaying()|| canzone4.isPlaying()||canzone5.isPlaying()){
 strokeWeight(1);
 tiles nota = new tiles(int(random(0, 4)));   //N.B. qui bisogna mettere codice per il BeatDetector!!!


  if (frameCount%70==0) {            //note generate per secondo, frameCount%10=6 note/secondo, Processing ha un valore di default del “frameRate” di 60
    circle.add(nota);
  
  } 
  
  for (int i=0; i<circle.size(); i++) {
    tiles pallino = (tiles) circle.get(i);
    pallino.run();
    pallino.display();
    pallino.move();
    
  /* if(pallino.location.x/100 == sensorValue && puls_value == 1 && pallino.location.y>= (800- err) && pallino.location.y<(800+err)){
      pallino.gone=true;
      myPort.write(sensorValue);
      score = score+1;
      print("Score: ");
      println(score);
      puls_value = 0;
    }*/
  /* if (pallino.gone==true){
      score+=25;   //ogni pallino centrato somma 25 punti
      circle.remove(i); 
    }*/
  
   }
  
  
  PFont caratt = loadFont("Algerian-32.vlw");
  
  textFont(caratt);
  fill(bianco);
  textAlign(CENTER);
  textSize(50);
  text(score, 618, 530);
  
   
  if (score==30) {
 
  textFont(caratt);
  fill(bianco);
  textAlign(CENTER);
  textSize(70);
  text("BRAVO!!", 610, 430);
  }
  if (score==50) {

  textFont(caratt);
  fill(bianco);
  textAlign(CENTER);
  textSize(70);
  text("CONTINUA", 610, 350);
  text("COSI'!", 610, 430);
  }
  if (score==100) {
 
  textFont(caratt);
  fill(bianco);
  textAlign(CENTER);
  textSize(70);
  text("OTTIMO!!", 610, 430);
  }
  if (score==150) {

  textFont(caratt);
  fill(bianco);
  textAlign(CENTER);
  textSize(50);
  text("YOU ARE", 610, 270);
  text("A", 610, 350);
  text("HERO!!", 610, 430);
  }
   
}
  //delay(10);
}

/* FINE DRAW */

/* PARTE CODICE CURSORE & PUSH BUTTON */
 void serialEvent(Serial p){
  int temp;
  temp = p.read();     
  if(temp == 0 || temp == 1 || temp == 2 || temp == 3){
    sensorValue = temp;
  }
  
   
  if(temp == 4) {
    puls_value = 1;
    
    current_frame = frameCount;
    
    
  }
  
  // println(sensorValue); // stampa nel riquadro console (in basso) i valori letti dal sensore
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
  score = 0;
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
    
    for (int k=0; k<circle.size(); k++) {
    tiles pallino = (tiles) circle.get(k);
    pallino.run_2();
    pallino.display_2();
    pallino.move_2();
  }
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
     
  //  println(oggetto_premuto);
    
   
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
   // println(location.x);
    ellipse(location.x+470,location.y+142, 80, 80);
    stroke(0); //contorno nero
    strokeWeight(4); //spessore contorno
  }

  void move() {
    location.y+=2;   //velocità
    if(location.x/100 == sensorValue && puls_value == 1 && location.y>= (800- err) && location.y<(800+err)){
      myPort.write(sensorValue);
      score = score+1;
      print("Score: ");
      println(score);
      puls_value = 0;
    }
  
    //if(location.y == 800 + err) puls_value = 0;
    //print("location: ");
    //print(location.x);
    //print(" ");
    //println(location.y);
  }
  
  
  void run_2() {
    display_2();
    move_2();
  }

  void display_2() {
    location.x=0;
    location.y=0;
    fill(location.x==0?rosso:location.x==100?verde:location.x==200?blu:giallo);
    ellipse(location.x+470,location.y+142, 80, 80);
    stroke(0); //contorno nero
    strokeWeight(4); //spessore contorno
  }

  void move_2() {
    location.y+=2;   //velocità
    }
    
   

}