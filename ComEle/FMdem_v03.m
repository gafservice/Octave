% Parámetros iniciales
fs = 1e6; % Frecuencia de muestreo (Hz)
t = linspace(0, 1, fs); % Vector de tiempo de 1 segundo

% Crear señal de prueba centrada en 110 MHz con componentes en frecuencias específicas
fc = 110e6; % Frecuencia central de 110 MHz
bw = 120e3; % Ancho de banda de 120 kHz
f1 = 1875; % Frecuencia de 1875 Hz
f2 = 13125; % Frecuencia de 13125 Hz
f3 = 31875; % Frecuencia de 31875 Hz
f4 = 58625; % Frecuencia de 58625 Hz

% Generar la señal de prueba
test_signal = cos(2 * pi * f1 * t) + cos(2 * pi * f2 * t) + cos(2 * pi * f3 * t) + cos(2 * pi * f4 * t);
test_signal = test_signal .* cos(2 * pi * fc * t);

% Amplificación de la señal de prueba
amplification_factor = 10; % Factor de amplificación
FMmodulada = amplification_factor * test_signal;

% Verificación: Mostrar información básica de la señal de prueba amplificada
disp('Información de la señal de prueba amplificada:');
disp(['Longitud: ', num2str(length(FMmodulada))]);
disp(['Rango de valores: ', num2str(min(FMmodulada)), ' a ', num2str(max(FMmodulada))]);

% Graficar la señal de prueba en el dominio del tiempo
figure;
subplot(5,1,1);
plot(t, FMmodulada);
title('Señal de Prueba Modulada en el Dominio del Tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Transformar la señal al dominio de la frecuencia
FMmodulada_freq = fft(FMmodulada);
f = linspace(-fs/2, fs/2, length(FMmodulada_freq)) + fc; % Ajuste para centrar en 110 MHz

% Graficar la señal de prueba en el dominio de la frecuencia antes del filtro
subplot(5,1,2);
plot(f, fftshift(abs(FMmodulada_freq)));
title('Señal de Prueba en el Dominio de la Frecuencia (Antes del Filtro)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([fc - bw, fc + bw]); % Mostrar un rango más cerrado alrededor de 110 MHz para mejor visualización

% Crear oscilador local de 99.3 MHz para obtener una IF de 10.7 MHz
f_lo = 99.3e6; % Frecuencia del oscilador local
osc_lo = cos(2 * pi * f_lo * t); % Señal del oscilador local

% Verificación: Mostrar información básica del oscilador local
disp('Información del oscilador local:');
disp(['Longitud: ', num2str(length(osc_lo))]);
disp(['Rango de valores: ', num2str(min(osc_lo)), ' a ', num2str(max(osc_lo))]);

% Mezclar la señal de prueba amplificada con el oscilador local para obtener la señal IF
IF_signal = FMmodulada .* osc_lo;

% Verificación: Mostrar información básica de la señal IF
disp('Información de la señal IF:');
disp(['Longitud: ', num2str(length(IF_signal))]);
disp(['Rango de valores: ', num2str(min(IF_signal)), ' a ', num2str(max(IF_signal))]);

% Graficar la señal IF en el dominio del tiempo
subplot(5,1,3);
plot(t, IF_signal);
title('Señal Intermedia (IF) en el Dominio del Tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Transformar la señal intermedia (IF) al dominio de la frecuencia
IF_signal_freq = fft(IF_signal);
f_IF = linspace(-fs/2, fs/2, length(IF_signal_freq)) + 10.7e6; % Ajuste para centrar en la nueva frecuencia intermedia de 10.7 MHz

% Graficar la señal IF en el dominio de la frecuencia
subplot(5,1,4);
plot(f_IF, fftshift(abs(IF_signal_freq)));
title('Señal Intermedia (IF) en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.6e6, 10.8e6]); % Mostrar un rango más cerrado alrededor de la frecuencia intermedia de 10.7 MHz

% Crear filtro paso banda de 120 kHz centrado en 10.7 MHz
bandwidth = 120e3; % 120 kHz
center_freq = 10.7e6; % Frecuencia central de la IF
low_cutoff = center_freq - bandwidth / 2;
high_cutoff = center_freq + bandwidth / 2;

% Generar la respuesta en frecuencia del filtro paso banda
filter_response = (f_IF >= low_cutoff & f_IF <= high_cutoff);

% Aplicar el filtro paso banda
IF_signal_freq_filtered = IF_signal_freq .* filter_response;

% Graficar la señal IF en el dominio de la frecuencia después del filtro
subplot(5,1,5);
plot(f_IF, fftshift(abs(IF_signal_freq_filtered)));
title('Señal Intermedia (IF) en el Dominio de la Frecuencia (Después del Filtro)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.6e6, 10.8e6]); % Mostrar un rango más cerrado alrededor de la frecuencia intermedia de 10.7 MHz
