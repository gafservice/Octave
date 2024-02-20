pkg load control
pkg load signal
s=tf("s")


% Parámetros de la ecuación de transferencia
Kp = 1;  % Ganancia
T = 2;  % Constante de tiempo

% Ecuación de transferencia
numerator = [Kp];
denominator = [T, T-1];
G = tf(numerator, denominator);
pkg load control
pkg load signal
s=tf("s")
% Generar el tiempo para la simulación
t = 0:0.01:15;  % Ajustar el tiempo según tus necesidades

% Generar la señal de entrada (pulso cuadrado) que inicia a los 5 segundos y dura 0.5 segundos
input_signal = (t >= 5) & (t < 5.5);

% Inicializar la salida como cero
output_signal = zeros(size(t));

% Encontrar el índice del tiempo donde comienza el pulso
pulse_start_index = find(input_signal, 1);

% Evaluar la función de transferencia solo durante el pulso
output_signal(pulse_start_index:end) = lsim(G, input_signal(pulse_start_index:end), t(pulse_start_index:end));

% Evaluar la ecuación de estado sin la influencia del pulso cuadrado
state_equation_response = lsim(G, zeros(size(t)), t);

% Graficar las tres señales por separado
figure;

subplot(3, 1, 1);
plot(t, input_signal);
title('Pulso Cuadrado de Entrada');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3, 1, 2);
plot(t, output_signal);
title('Respuesta de la Ecuación de Transferencia al Pulso Cuadrado');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3, 1, 3);
plot(t, state_equation_response);
title('Respuesta de la Ecuación de Transferencia sin Pulso Cuadrado');
xlabel('Tiempo (s)');
ylabel('Amplitud');