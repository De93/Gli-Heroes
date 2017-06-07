const int pin_potenziometro = A0;
const int pin_LEDR = 12;
const int pin_LEDG = 9;
const int pin_LEDB = 6;
const int pin_LEDY = 3;
const int pin_button = 10;

int analog_pot;   // valore potenziometro letto (0 : 1023)
int pos;          // posizione pallina da inviare nella seriale
int pos_prec;     // posizione inviata precedentemente 

void setup() {
  Serial.begin(9600);
  
  pinMode(pin_LEDR, OUTPUT);
  pinMode(pin_LEDG, OUTPUT);
  pinMode(pin_LEDB, OUTPUT);
  pinMode(pin_LEDY, OUTPUT);
  pinMode(pin_button, INPUT);

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


delay(1);
}

// rosso verde blu giallo
