import grafica.*;
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


//variabili
int sensorValue; // valore della resistenza del potenziometro (viene letta come un numero da 0 a 255)
int x=100;
float y=0;
float i=0;

void setup(){
  size(800,800);
  frameRate(60);
  myPort = new Serial(this, "COM3",9600); // fornisco a Processing le info sulla connessione seriale:
                                          // 9600 è il baud rate, ossia le velocità con cui arduino comunica con il computer    
                                          // COM8 è la porta seriale tramite cui ci si è collegati ad arduino
                                          //è possibile vederla nel momento in cui si carica lo sketch arduino e successivamente copiare ed incollare il nome della porta nelle virgolette
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
  
  
    //Fa apparire il rettangolo giallo quando si muove la rondella del potenziometro
  
    while(myPort.available()>0){
      sensorValue = myPort.read();
      println(sensorValue); // stampa nel riquadro console (in basso) i valori letti dal sensore
  
      //dice che il rettangolo deve apparire nella prima colonna
      if (0 <= sensorValue && sensorValue < 15) {
        fill(255,255,0); //determina il colore del rettangolo
        rect(0,722, 195,178); //determina posizione e dimensione
      }
  
    //dice che il rettangolo deve apparire nella seconda colonna
      if (16 <= sensorValue && sensorValue < 69) {
        fill(255,255,0);
        rect(205,722, 191,178);
      }
    
     //dice che il rettangolo deve apparire nella terza colonna
      if (70 <= sensorValue && sensorValue < 162) {
        fill(255,255,0); 
        rect(405,722, 191,178);
      }  
    
    //dice che il rettangolo deve apparire nella quarta colonna
      if (163 <= sensorValue && sensorValue <= 255) {
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