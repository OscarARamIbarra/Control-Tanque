//Ramirez Ibarra Oscar Alfredo
// Simular las dinámicas de un tanque
clc;
clear;
close(winsid());

// Función:		
		
function dx=TanqueODE(t, x, A, B, u)	
dx = (A*x) + (B*u);	
endfunction	

// Definir el modelo en espacio de estados
r = 8;             //cm
AB = %pi * (r^2);
R = 0.54;           //s/cm^2

A = 1-1/AB*R;
B = 1/AB;
C = AB;
D = 0;

// Definir vector de tiempo (s)
t0 = 0;
tf = 1200; //1200
Dt = 1;
t = t0:Dt:tf;
lt = length(t);

T = 1;
td = t0:T:tf;
ltd = length(td);

// Definir entrada 
u = ones(1,ltd);
//u = zeros(1,ltd);
//u(1) = 1;
u = 31*u;
// Definir condición inicial
x0 = 0;

// Reservar memoria para el estado y la salida
x = zeros(1,ltd);
xA = zeros(1,lt);
//xt = zeros(1,ltd);
y = zeros(1,ltd);
x(1) = x0;
//Resolver la ecuación diferencial
//x = ode(x0,t0,t,list(TanqueODE,A,B,u));

//Resolver la ecuación algebráica
//y = (C*x)+(D*u);

//Modelo en espacio de estados en tiempo discreto
sysTankDisc = syslin('d', A, B, C, D);
Gz = ss2tf(sysTankDisc); //Funcion de transferencia pulso

// Resolver la ecuación en diferencias
for k=1:ltd-1
    x(k+1) = ((1-(T/(AB*R)))*x(k)) + ((T/AB)*u(k))
    y(k) = (AB*x(k))
end

// Solución analítica
yA = zeros(1,lt);
//yA = ((AB*R) - (AB*R)*exp(-(1/(AB*R)*t)));
yA = 31*((AB*R) - (AB*R)*exp(-(1/(AB*R)*t)));

 yD = zeros(1,lt);
 for k=1:lt
     yD(k) = 31*(AB*R)*(1-(1-(T/(AB*R)))^k);
 end

// Graficar resultados
figure;
plot(td,x,'*b');
xlabel('Time (s)');
ylabel('Height (cm)');

figure;
plot(td,y,'*r',t,yA,'-b');
xlabel('Time (s)');
ylabel('Volumen(cm^3)');
legend('Solution in discrete time', 'Solution in continuous time');

figure;
plot(td,y,'*r',td,yD,'-b');
xlabel('Time (s)');
ylabel('Volumen (cm^3)');
legend('Solucion numerica','Solucion analitica');
