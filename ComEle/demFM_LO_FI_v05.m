


% Código para Octave

% Utilizar el contenido del archivo proporcionado
% Asegúrate de que las funciones y variables dentro de FMmodem_v03.m están correctamente definidas y se pueden utilizar

% Definir parámetros
fs = 1e9; % Frecuencia de muestreo en Hz
t = 0:1/fs:1e-6; % Vector de tiempo, 1 us de duración

% Frecuencias
f_OL = 110e6;   % Frecuencia del Oscilador Local en Hz
f_FI = 10.7e6;  % Frecuencia Intermedia en Hz

% Cargar y ejecutar el archivo FMmodem_v03.m para generar la señal FM modulada
run('/mnt/data/FMmodem_v03.m');

% Suponiendo que el archivo define una señal FMmodulada llamada 'FMmodulada'
% Esta señal se generará dentro del archivo proporcionado

% Oscilador Local
OL_signal = cos(2 * pi * f_OL * t); % Oscilador Local

% Mezcla de señales
sum_signal = FMmodulada .* OL_signal; % Producto de mezcla

% Transformada de Fourier para ver las señales en frecuencia
n = length(t);
f = (-n/2:n/2-1)*(fs/n)/1e6; % Vector de frecuencias en MHz

FM_spectrum = abs(fftshift(fft(FMmodulada)));
OL_spectrum = abs(fftshift(fft(OL_signal)));
sum_spectrum = abs(fftshift(fft(sum_signal)));

% Graficar señales en el dominio del tiempo
figure;
subplot(3,1,1);
plot(t*1e6, FMmodulada);
title('Señal de RF (FM modulada)');
xlabel('Tiempo (\mus)');
ylabel('Amplitud');

subplot(3,1,2);
plot(t*1e6, OL_signal);
title('Oscilador Local');
xlabel('Tiempo (\mus)');
ylabel('Amplitud');

subplot(3,1,3);
plot(t*1e6, sum_signal);
title('Señal Mezclada');
xlabel('Tiempo (\mus)');
ylabel('Amplitud');

% Graficar espectros en el dominio de la frecuencia
figure;
subplot(3,1,1);
plot(f, FM_spectrum);
title('Espectro de la Señal de RF');
xlabel('Frecuencia (MHz)');
ylabel('Magnitud');

subplot(3,1,2);
plot(f, OL_spectrum);
title('Espectro del Oscilador Local');
xlabel('Frecuencia (MHz)');
ylabel('Magnitud');

subplot(3,1,3);
plot(f, sum_spectrum);
title('Espectro de la Señal Mezclada');
xlabel('Frecuencia (MHz)');
ylabel('Magnitud');
