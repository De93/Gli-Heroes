import controlP5.*;
import java.util.*;
import grafica.*;
import ddf.minim.*;

//inizializzazione degli elementi della gui
ControlP5 menu_canzoni; //menù a tendina
ControlP5 titolo;  //elemento testuale
ControlP5 bottone;

//inizializzazione delle variabili per far muovere le palline
int x=500;
float y=150;
float i=0;


String oggetto_premuto;
int canzone_selezionata = -1;
int fai_partire=-1;



//Variabili per la riproduzione della canzone
Minim musica; //inizializzazione della funzione per far partire la musica
AudioPlayer canzone1;
AudioPlayer canzone2;
AudioPlayer canzone3;
AudioPlayer canzone4;
AudioPlayer canzone5;


void setup() {
  
  size(1250, 950); //Dimensione dell'interfaccia grafica
  
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
                    .setPosition(500,20)
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
  background(171,205,239);
  //print("...");
  //println(canzone_selezionata);
  
  //PImage img;
  //img = loadImage("guitar_hero.png");  
  //background(img);
  
  strokeWeight(15);
  stroke(0,0,255);
  fill (255);
  rect(400,100,800,800);
  
  stroke (0);
  strokeWeight(10);
  fill(15,15,15);
  line(600,107,600,892);
  strokeWeight(10);
  line(800,107,800,892);
  strokeWeight(10);
  line(1000,107,1000,892);
  
  strokeWeight(5);
  line(408,800,1192,800);
  
  strokeWeight(1);
  
  
  if(canzone1.isPlaying()||canzone2.isPlaying()||canzone3.isPlaying()||canzone4.isPlaying()||canzone5.isPlaying()){
    fai_partire=1;
  }
  else{
    fai_partire=0;
  }
  
  
  if(fai_partire==1){
    
  //pallina nella prima colonna - verde
    if(x==500){
    fill(0,255,0);  
  }
  
  //pallina nella seconda colonna - rossa
    if(x==700){
    fill(255,0,0);
  }
  
  
  //pallina nella terza colonna - blu
  if(x==900){
    fill(0,0,255);
  }
  
  //pallina nella  quarta colonna - viola
  if(x==1100){
    fill(153,17,153);
    
}
  
  ellipse(x, y, 70, 70);  
  y=y+10;
  
  
  
  if(y>875){
    y=150;
    i=random(0,4);
    x=int(i)* 200 +500; 
    
    
  }
  
  }
  //if (canzone_selezionata==1){
  //  fai_partire=9;
  //}
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