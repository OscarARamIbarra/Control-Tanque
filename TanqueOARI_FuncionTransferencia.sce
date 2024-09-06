function dx=TanqueODE(t, x, A, B, u)    
dx = (A*x) + (B*u);    
endfunction    

// Definir el modelo en espacio de estados
r = 8;             //cm
AB = %pi * (r^2);
R = 0.54;           //s/cm^2

A = -(1/AB*R);
B = 1/AB;
C = AB;
D = 0;

// Definir vector de tiempo (s)
t0 = 0;
tf = 1200;
Dt = 1;
t = t0:Dt:tf;
lt = length(t);

T = 1;
td = t0:T:tf;
ltd = length(td);

// Definir entrada 
u = ones(1,ltd);
// Definir condición inicial
x0 = 0;

// Reservar memoria para el estado y la salida
x = zeros(1,ltd);
//xt = zeros(1,ltd);
y = zeros(1,ltd);
x(1) = x0;

//Resolver la ecuación diferencial
x = ode(x0,t0,t,list(TanqueODE,A,B,u));

//Resolver la ecuación algebráica
y = (C*x) + (D*u);

//Modelo en espacio de estados en tiempo discreto
sysTankDisc = syslin('d', A, B, C, D);
Gz = ss2tf(sysTankDisc); //Funcion de transferencia pulso
