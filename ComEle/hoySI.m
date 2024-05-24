% Parámetros iniciales
fs = 10000; % Frecuencia de muestreo (Hz)
t = linspace(0, 1, fs); % Vector de tiempo de 1 segundo

% Supongamos que FMmodulada ya está definida en tu espacio de trabajo
% FMmodulada

% Transformar la señal al dominio de la frecuencia
FMmodulada_freq = fft(FMmodulada);
f = linspace(-fs/2, fs/2, length(FMmodulada_freq)) + 110e6; % Ajuste para centrar en 110 MHz

% Graficar la señal en el dominio del tiempo
figure;
subplot(3,1,1);
plot(t, FMmodulada);
title('Señal FM Modulada en el Dominio del Tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Graficar la señal en el dominio de la frecuencia antes del filtro
subplot(3,1,2);
plot(f, fftshift(abs(FMmodulada_freq)));
title('Señal FM Modulada en el Dominio de la Frecuencia (Antes del Filtro)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([109.995e6, 110.005e6]); % Mostrar un rango más cerrado alrededor de 110 MHz para mejor visualización

% Crear filtro paso banda de 120 kHz
bandwidth = 120e3; % 120 kHz
center_freq = 110e6; % 110 MHz
low_cutoff = center_freq - bandwidth / 2;
high_cutoff = center_freq + bandwidth / 2;

% Generar la respuesta en frecuencia del filtro paso banda
filter_response = (f >= low_cutoff & f <= high_cutoff);

% Aplicar el filtro paso banda
FMmodulada_freq_filtered = FMmodulada_freq .* filter_response;

% Graficar la señal en el dominio de la frecuencia después del filtro
subplot(3,1,3);
plot(f, fftshift(abs(FMmodulada_freq_filtered)));
title('Señal FM Modulada en el Dominio de la Frecuencia (Después del Filtro)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([109.995e6, 110.005e6]); % Mostrar un rango más cerrado alrededor de 110 MHz para mejor visualización
