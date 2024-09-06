// Definir el modelo en espacio de estados
r = 8;             //cm
AB = %pi * (r^2);
R = 0.54
;           //s/cm^2

A = 1-1/AB*R;
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
// Resolver la ecuación en diferencias
for k=1:ltd-1
    x(k+1) = ((1-(T/(AB*R)))*x(k)) + ((T/AB)*u(k))
    y(k) = (AB*x(k))
end
yD = zeros(1,lt);
for k=1:lt
    yD(k) = (AB*R)*(1-(1-(T/(AB*R)))^k);
end
figure;
plot(td,x,'*b');
xlabel('Time (s)');
ylabel('Height (cm)');

figure;
plot(td,y,'*r',td,yD,'-b');
xlabel('Time (s)');
ylabel('Volumen (cm^3)');
legend('Solucion numerica','Solucion analitica');
