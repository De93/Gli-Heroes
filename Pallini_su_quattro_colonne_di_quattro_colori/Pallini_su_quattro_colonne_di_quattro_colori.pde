import grafica.*;


//variabili
int x=100;
float y=0;
float i=0;

void setup(){
  size(800,800);
  frameRate(60);
  
}


void draw (){
  
  PImage img;
  img = loadImage("guitar_hero.png");
  background(img);
  
  strokeWeight(10);
  fill(15,15,15);
  line(200,0,200,800);
  strokeWeight(10);
  line(400,0,400,800);
  strokeWeight(10);
  line(600,0,600,800);
  
  strokeWeight(5);
  line(0,720,800,720);
  
  strokeWeight(1);
  
  
    //Fa apparire il rettangolo giallo quando la pallina ci entra dentro
  if(y>675){
    
    //dice che il rettangolo deve apparire nella prima colonna
    if (x==100) {
    fill(255,255,0); //determina il colore del rettangolo
    rect(0,722, 195,178); //determina posizione e dimensione
  }
  
  //dice che il rettangolo deve apparire nella seconda colonna
    if (x==300) {
    fill(255,255,0);
    rect(205,722, 191,178);
  }
    
    //dice che il rettangolo deve apparire nella terza colonna
    if (x==500) {
    fill(255,255,0); 
    rect(405,722, 191,178);
  }  
    
    //dice che il rettangolo deve apparire nella quarta colonna
    if (x==700) {
    fill(255,255,0);
    rect(605,722, 195,178);
  } 
}
  
  
  //pallina nella prima colonna - verde
    if(x==100){
    fill(0,255,0);  
  }
  
  //pallina nella seconda colonna - rossa
    if(x==300){
    fill(255,0,0);
  }
  
  
  //pallina nella terza colonna - blu
  if(x==500){
    fill(0,0,255);
  }
  
  //pallina nella  quarta colonna - viola
  if(x==700){
    fill(153,17,153);
    
}
  
  ellipse(x, y, 70, 70);  
  y=y+10;
  
  
  
  if(y>height){
    y=0;
    i=random(0,4);
    x=int(i)* 200 +100; 
    
    
  }
  

}