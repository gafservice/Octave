% Parámetros iniciales
fs = 1e6; % Frecuencia de muestreo (Hz)
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
f_FMmodulada = linspace(-fs/2, fs/2, length(FMmodulada_freq)) + fc; % Ajuste para centrar en 110 MHz

% Crear oscilador local de 99.3 MHz para obtener una IF de 10.7 MHz
f_lo = 99.3e6; % Frecuencia del oscilador local
osc_lo = cos(2 * pi * f_lo * t); % Señal del oscilador local

% Transformar el oscilador local al dominio de la frecuencia
osc_lo_freq = fft(osc_lo);
f_osc_lo = linspace(-fs/2, fs/2, length(osc_lo_freq)) + f_lo;

% Mezclar la señal de prueba con el oscilador local para obtener la señal IF
IF_signal = FMmodulada .* osc_lo;

% Transformar la señal IF al dominio de la frecuencia
IF_signal_freq = fft(IF_signal);
f_IF = linspace(-fs/2, fs/2, length(IF_signal_freq)) + fc - f_lo; % Ajuste para centrar en la nueva frecuencia intermedia de 10.7 MHz

% Crear un filtro paso bajo para 10.7 MHz
cutoff_freq = 10.7e6; % Frecuencia de corte del filtro
lp_filter = abs(f_IF) <= cutoff_freq; % Crear filtro paso bajo

% Aplicar el filtro paso bajo en el dominio de la frecuencia
IF_signal_freq_filtered = IF_signal_freq .* lp_filter;

% Transformar la señal IF filtrada de vuelta al dominio del tiempo
IF_signal_filtered = ifft(IF_signal_freq_filtered);

% Graficar las señales en el dominio de la frecuencia
figure;

% Señal de Prueba en el Dominio de la Frecuencia
subplot(4,1,1);
plot(f_FMmodulada, fftshift(abs(FMmodulada_freq)));
title('Señal de Prueba en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([fc - 500e3, fc + 500e3]); % Mostrar un rango más cerrado alrededor de 110 MHz para mejor visualización

% Señal del Oscilador Local en el Dominio de la Frecuencia
subplot(4,1,2);
plot(f_osc_lo, fftshift(abs(osc_lo_freq)));
title('Señal del Oscilador Local en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([f_lo - 500e3, f_lo + 500e3]); % Mostrar un rango más cerrado alrededor de 99.3 MHz para mejor visualización

% Señal IF en el Dominio de la Frecuencia (sin filtrar)
subplot(4,1,3);
plot(f_IF, fftshift(abs(IF_signal_freq)));
title('Señal Intermedia (IF) en el Dominio de la Frecuencia (sin filtrar)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.2e6, 11.2e6]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización

% Señal IF en el Dominio de la Frecuencia (filtrada)
subplot(4,1,4);
plot(f_IF, fftshift(abs(IF_signal_freq_filtered)));
title('Señal Intermedia (IF) en el Dominio de la Frecuencia (filtrada)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.2e6, 11.2e6]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización

% Verificaciones adicionales
disp('Información de la señal de prueba:');
disp(['Longitud: ', num2str(length(FMmodulada))]);
disp(['Rango de valores: ', num2str(min(FMmodulada)), ' a ', num2str(max(FMmodulada))]);

disp('Información del oscilador local:');
disp(['Longitud: ', num2str(length(osc_lo))]);
disp(['Rango de valores: ', num2str(min(osc_lo)), ' a ', num2str(max(osc_lo))]);

disp('Información de la señal IF:');
disp(['Longitud: ', num2str(length(IF_signal))]);
disp(['Rango de valores: ', num2str(min(IF_signal)), ' a ', num2str(max(IF_signal))]);


