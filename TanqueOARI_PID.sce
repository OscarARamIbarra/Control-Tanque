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

//Modelo en espacio de estados en tiempo discreto
sysTankDisc = syslin('d', A, B, C, D);
Gz = ss2tf(sysTankDisc); //Funcion de transferencia pulso

// Definir entrada 
u = 19*ones(1,ltd);
//u(1) = 0;
//u(2:1200) = 31;
//u(1201:2400) = 10;
//u(2401:3600) = 20;
//u(3601:4800) = 5;
//u(4801:6000) = 25;
// Definir condición inicial
x0 = 0;

// Reservar memoria para el estado y la salida
x = zeros(1,ltd);
//xt = zeros(1,ltd);
y = zeros(1,ltd);
x(1) = x0;
// Resolver la ecuación en diferencias
for k=1:ltd-1
    x(k+1) = ((1-(T/(AB*R)))*x(k)) + ((T/AB)*u(k))
    y(k) = (AB*x(k))
end

[num, den] = ss2tf(sysTankDisc);

// Tiempo de muestreo
T_s = 1; // segundos

// Ajustar los valores de K_p, K_i y K_d
K_p = 0.0476; 
K_i = 0.000075; 
K_d = 0; 

FlagK = 3;
z = poly(0, 'z');
select FlagK
case 1 then
    KZ = K_p;
case 2 then 
    KZ = K_p + ((K_i)*((1)/(1-z^(-1))));
case 3 then 
    KZ = K_p + ((K_i)*((1)/(1-z^(-1))))+(K_d*(1-z^(-1)));
end

GH0GZ = (R)*(1-z^(-1))*((z/(z-1))-(z/(z-exp(-Dt/(AB*R)))));
GCL = (KZ*GH0GZ)/(1+(KZ*GH0GZ));
figure
plzr(GCL);


// Parámetros del sistema continuo
K = A;
a = abs(B);

// Discretización manual usando aproximación bilineal (Tustin)
alpha = 2 / T_s;
num_d = [K * alpha, K * alpha];
den_d = [(alpha + a), (alpha - a)];

// Normalizar el denominador
num_d = num_d / den_d(1);
den_d = den_d / den_d(1);

// Función de transferencia del controlador PID
G_PID_num = [K_p + K_i * T_s + K_d / T_s, -(K_p + 2 * K_d / T_s), K_d / T_s];
G_PID_den = [1, -2, 1];
GzPID = [K_p + K_i * T_s + K_d / T_s, (K_p + 2 * K_d / T_s)/2, K_d / T_s];

// Función de transferencia en lazo cerrado con controlador PID
G_cl_PID_num = conv(G_PID_num, num_d);
G_cl_PID_den = conv(G_PID_den, den_d) + conv(G_PID_num, num_d);
sys_cl_PID = syslin('d', G_cl_PID_num, G_cl_PID_den);

// Simulación del sistema en lazo cerrado con entrada escalón (Controlador PID)
n = 100; // Número de puntos
u_escalon = ones(n, 1);
y_cl_PID = 108.6*filter(G_cl_PID_num, G_cl_PID_den, u);

// Graficar la respuesta en lazo cerrado con Controlador PID
scf(2);
plot(td, y_cl_PID, '-g', td, y, '-r', td, 108.6*u, '-b');
xlabel('Tiempo (s)');
ylabel('Volumen del líquido');
title('Respuesta del sistema en lazo cerrado con Controlador PID');
legend('Lazo cerrado PID', 'respuesta en tiempo continuo', 'Señal de entrada multiplicada por la ganancia');
//figure;
//plot(td, 108.6*u, '-b');


