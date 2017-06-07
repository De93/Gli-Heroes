const int pin_potenziometro = A0;
const int pin_LEDR = 12;
const int pin_LEDG = 9;
const int pin_LEDB = 6;
const int pin_LEDY = 3;
const int pin_button = 7;


int analog_pot;   // valore potenziometro letto (0 : 1023)
int pos;          // posizione pallina da inviare nella seriale
int pos_prec;     // posizione inviata precedentemente 
int pin_LED;
int data_received;
volatile bool button_flag = LOW;

void setup() {
  Serial.begin(9600);
  
  pinMode(pin_LEDR, OUTPUT);
  pinMode(pin_LEDG, OUTPUT);
  pinMode(pin_LEDB, OUTPUT);
  pinMode(pin_LEDY, OUTPUT);
  pinMode(pin_button, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(pin_button), setButtonFlag , FALLING);

}

void loop() {

  analog_pot = analogRead(pin_potenziometro);
  
  if(analog_pot >= 0 && analog_pot < 60)     pos = 0;
  if(analog_pot >= 64 && analog_pot < 276)   pos = 1;
  if(analog_pot >= 280 && analog_pot < 648)  pos = 2;
  if(analog_pot >= 652 && analog_pot < 1023) pos = 3;
  
  if(pos != pos_prec) {
     Serial.write(pos);
     pos_prec = pos;
    }

  if(button_flag == HIGH) {
    Serial.write(4);
    button_flag = LOW;
   }

   if(Serial.available()>0){
    data_received = Serial.read();
      if(data_received == 0){
        digitalWrite(pin_LEDR, HIGH);        
        delay(200);
        digitalWrite(pin_LEDR, LOW);
        }
        
      if(data_received == 1){
        digitalWrite(pin_LEDG, HIGH);        
        delay(200);
        digitalWrite(pin_LEDG, LOW);
        }
      if(data_received == 2){
        digitalWrite(pin_LEDB, HIGH);        
        delay(200);
        digitalWrite(pin_LEDB, LOW);
        }
      if(data_received == 3){
        digitalWrite(pin_LEDY, HIGH);        
        delay(200);
        digitalWrite(pin_LEDY, LOW);
      }
    }


delay(1);
}

void setButtonFlag(){
  button_flag = HIGH;
  }
// rosso verde blu giallo
