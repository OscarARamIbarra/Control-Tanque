
const int Trigger = 6;
const int Echo = 7;

// Asignaciones pins
//const int PIN_INPUT = A0;
const int PIN_OUTPUT = 3;

// Constantes del controlador
double Kp=0.0476, Ki=0.000075, Kd=0;

// variables externas del controlador
double Input, Output, Setpoint;
 
// variables internas del controlador
unsigned long currentTime, previousTime;
double elapsedTime;
double error, lastError, cumError, rateError;
 
void setup()
{
  pinMode(Trigger, OUTPUT);
  pinMode(Echo, INPUT);
  digitalWrite(Trigger, LOW);
  //Input = analogRead(PIN_INPUT);
  Setpoint = 2000;
}    
 
void loop(){
  
  //pidController.Compute();
  digitalWrite(Trigger, HIGH);
  delayMicroseconds(10);
  digitalWrite(Trigger, LOW);

  double t;
  double h;
  double d;
  double v;
  t = pulseIn(Echo, HIGH);
  d = t/59;
  h = 21.5-d;
  v = h*200;
  
  Input = v;
  Output = computePID(Input);    
  // calcular el controlador
  delay(100);
  analogWrite(PIN_OUTPUT, Output);      
  // escribir la salida del controlador

}
 
double computePID(double inp){     
        currentTime = millis();                          
        // obtener el tiempo actual
        elapsedTime = (double)(currentTime - previousTime);     
        // calcular el tiempo transcurrido
        error = Setpoint - Input;                              
        // determinar el error entre la consigna y la medición
        cumError += error * elapsedTime;                    
        // calcular la integral del error
        rateError = (error - lastError) / elapsedTime;       
        // calcular la derivada del error
 
        double output = Kp*error + Ki*cumError + Kd*rateError;     
        // calcular la salida del PID
 
        lastError = error;                                    
        // almacenar error anterior
        previousTime = currentTime;                           
        // almacenar el tiempo anterior
 
        return output;
}
