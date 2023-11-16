pkg load control
pkg load signal
s=tf("s")
% Parámetros del modelo SISO para el ángulo del péndulo
ka = 2;      % Ganancia proporcional
za = 1;      % Valor de za en el numerador
wn = 5;      % Frecuencia natural
zeta = 0.5;  % Factor de amortiguamiento

% Modelo de espacio de estados
A = [0, 1; -wn^2, -2*zeta*wn];
B = [0; ka];
C = [1, -za];  % Incluye el cero en el numerador
D = 0;

sys_ss = ss(A, B, C, D);

% Generar el tiempo para la simulación
t = 0:0.01:10;  % Ajustar el tiempo según tus necesidades

% Simular la respuesta al impulso para el modelo de espacio de estados
impulse_response_ss = lsim(sys_ss, zeros(size(t)), t, zeros(2, 1));

% Graficar la respuesta al impulso
figure;
plot(t, impulse_response_ss(:, 1));
title('Respuesta al Impulso del Modelo de Espacio de Estados');
xlabel('Tiempo (s)');
ylabel('Amplitud');