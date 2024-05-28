% Parámetros iniciales
fs = 25e6; % Frecuencia de muestreo (Hz)
t = linspace(0, 1, fs); % Vector de tiempo de 1 segundo

% Crear señal de prueba centrada en 110 MHz con componentes en frecuencias específicas
fc = 110e6; % Frecuencia central de 110 MHz
f1 = 1875; % Frecuencia de 1875 Hz
f2 = 13125; % Frecuencia de 13125 Hz
f3 = 31875; % Frecuencia de 31875 Hz
f4 = 58625; % Frecuencia de 58625 Hz

% Generar la señal de prueba (modulación de amplitud)
test_signal = cos(2 * pi * f1 * t) + cos(2 * pi * f2 * t) + cos(2 * pi * f3 * t) + cos(2 * pi * f4 * t);
FMmodulada = test_signal .* cos(2 * pi * fc * t);

% Transformar la señal de prueba al dominio de la frecuencia
FMmodulada_freq = fft(FMmodulada);
FMmodulada_freq_shifted = fftshift(FMmodulada_freq);
f_FMmodulada = linspace(-fs/2, fs/2, length(FMmodulada_freq_shifted)); % Frecuencias para la señal de prueba

% Crear oscilador local de 120.7 MHz para obtener una IF de 10.7 MHz
f_lo = 120.7e6; % Frecuencia del oscilador local
osc_lo = cos(2 * pi * f_lo * t); % Señal del oscilador local

% Transformar el oscilador local al dominio de la frecuencia
osc_lo_freq = fft(osc_lo);
osc_lo_freq_shifted = fftshift(osc_lo_freq);
f_osc_lo = linspace(-fs/2, fs/2, length(osc_lo_freq_shifted)); % Frecuencias para el oscilador local

% Graficar las señales en el dominio de la frecuencia
figure('Position', [100, 100, 800, 800]); % Crear figura más grande

% Primer grupo de gráficas (ajuste según el código bueno)
subplot(2,1,1);
plot(f_FMmodulada + fc, abs(FMmodulada_freq_shifted));
title('Señal de Prueba en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([109.5e6, 110.5e6]); % Mostrar un rango más cerrado alrededor de 110 MHz
ylim([0, max(abs(FMmodulada_freq_shifted))]); % Asegurar que las componentes se muestren hacia arriba

subplot(2,1,2);
plot(f_osc_lo + f_lo, abs(osc_lo_freq_shifted));
title('Señal del Oscilador Local en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([120.2e6, 121.2e6]); % Mostrar un rango más cerrado alrededor de 120.7 MHz
ylim([0, max(abs(osc_lo_freq_shifted))]); % Asegurar que las componentes se muestren hacia arriba

% Mezclar la señal de prueba con el oscilador local para obtener la señal IF
IF_signal = FMmodulada .* osc_lo;

% Transformar la señal IF al dominio de la frecuencia
IF_signal_freq = fft(IF_signal);
IF_signal_freq_shifted = fftshift(IF_signal_freq);
f_IF = linspace(-fs/2, fs/2, length(IF_signal_freq_shifted)) * fs / length(IF_signal_freq_shifted); % Frecuencias para la señal IF

% Aplicar filtro pasa banda
N = 500; % Orden del filtro
Fc1 = 10.7e6 / (fs / 2); % Frecuencia de corte inferior normalizada
Fc2 = 10.765e6 / (fs / 2); % Frecuencia de corte superior normalizada
h = fir1(N, [Fc1 Fc2], 'bandpass'); % Diseño del filtro FIR pasa banda
IF_signal_filtrada = filter(h, 1, IF_signal);

% Transformar la señal IF filtrada al dominio de la frecuencia
IF_signal_filtrada_freq = fft(IF_signal_filtrada);
IF_signal_filtrada_freq_shifted = fftshift(IF_signal_filtrada_freq);

% Graficar las señales IF en el dominio de la frecuencia
figure('Position', [100, 100, 800, 800]); % Crear figura más grande

subplot(2,1,1);
plot(f_IF, abs(IF_signal_freq_shifted)); % Ajustar para centrar en 10.7 MHz
title('Señal Intermedia (IF) en el Dominio de la Frecuencia (sin filtrar)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.6e6, 10.8e6]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización
ylim([0, max(abs(IF_signal_freq_shifted))]); % Asegurar que las componentes se muestren hacia arriba

subplot(2,1,2);
plot(f_IF, abs(IF_signal_filtrada_freq_shifted)); % Ajustar para centrar en 10.7 MHz
title('Señal IF Filtrada en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.6e6, 10.8e6]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización
ylim([0, max(abs(IF_signal_filtrada_freq_shifted))]); % Asegurar que las componentes se muestren hacia arriba

