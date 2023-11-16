% Parámetros de la ecuación de transferencia
kp = 1;      % Ganancia proporcional
ka = 2;      % Ganancia integral
wn = 5;      % Frecuencia natural
zeta = 0.5;  % Factor de amortiguamiento

% Ecuación de transferencia
numerator = [kp];
denominator = [1, zeta*2*wn, wn^2];
G = tf(numerator, denominator);

% Generar el tiempo para la simulación
t = 0:0.01:10;  % Ajustar el tiempo según tus necesidades

% Simular la respuesta al impulso
impulse_response = lsim(G, ones(size(t)), t);

% Graficar la respuesta al impulso
figure;
plot(t, impulse_response);
title('Respuesta al Impulso del Sistema');
xlabel('Tiempo (s)');
ylabel('Amplitud');