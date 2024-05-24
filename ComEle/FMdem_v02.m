% Parámetros iniciales
fs = 1e6; % Frecuencia de muestreo (Hz)
t = linspace(0, 1, fs); % Vector de tiempo de 1 segundo

% Supongamos que FMmodulada ya está definida en tu espacio de trabajo
% Verificar longitud de FMmodulada
if ~exist('FMmodulada', 'var')
    error('La señal FMmodulada no está definida en el espacio de trabajo.');
end

original_length = length(FMmodulada);

% Resamplear FMmodulada si las longitudes no coinciden
if original_length ~= length(t)
    disp('Resampleando FMmodulada para que coincida con la longitud de t...');
    FMmodulada = resample(FMmodulada, length(t), original_length);
end

% Verificar de nuevo la longitud de FMmodulada después del resampleo
if length(FMmodulada) ~= length(t)
    error('La longitud de FMmodulada debe ser igual a la longitud de t después del resampleo.');
end

% Amplificación de la señal FMmodulada
amplification_factor = 10; % Factor de amplificación
FMmodulada_amplified = amplification_factor * FMmodulada;

% Verificación: Mostrar información básica de FMmodulada amplificada
disp('Información de la señal FMmodulada amplificada:');
disp(['Longitud: ', num2str(length(FMmodulada_amplified))]);
disp(['Rango de valores: ', num2str(min(FMmodulada_amplified)), ' a ', num2str(max(FMmodulada_amplified))]);

% Graficar la señal en el dominio del tiempo
figure;
subplot(4,1,1);
plot(t, FMmodulada_amplified);
title('Señal FM Modulada Amplificada en el Dominio del Tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Crear oscilador local de 99.3 MHz para obtener una IF de 10.7 MHz
f_lo = 99.3e6; % Frecuencia del oscilador local
osc_lo = cos(2 * pi * f_lo * t); % Señal del oscilador local

% Verificación: Mostrar información básica del oscilador local
disp('Información del oscilador local:');
disp(['Longitud: ', num2str(length(osc_lo))]);
disp(['Rango de valores: ', num2str(min(osc_lo)), ' a ', num2str(max(osc_lo))]);

% Mezclar la señal FMmodulada amplificada con el oscilador local para obtener la señal IF
IF_signal = FMmodulada_amplified .* osc_lo;

% Verificación: Mostrar información básica de la señal IF
disp('Información de la señal IF:');
disp(['Longitud: ', num2str(length(IF_signal))]);
disp(['Rango de valores: ', num2str(min(IF_signal)), ' a ', num2str(max(IF_signal))]);

% Graficar la señal IF en el dominio del tiempo
subplot(4,1,2);
plot(t, IF_signal);
title('Señal Intermedia (IF) en el Dominio del Tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Transformar la señal intermedia (IF) al dominio de la frecuencia
IF_signal_freq = fft(IF_signal);
f_IF = linspace(-fs/2, fs/2, length(IF_signal_freq)) + 10.7e6; % Ajuste para centrar en la nueva frecuencia intermedia de 10.7 MHz

% Graficar la señal IF en el dominio de la frecuencia
subplot(4,1,3);
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
subplot(4,1,4);
plot(f_IF, fftshift(abs(IF_signal_freq_filtered)));
title('Señal Intermedia (IF) en el Dominio de la Frecuencia (Después del Filtro)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.6e6, 10.8e6]); % Mostrar un rango más cerrado alrededor de la frecuencia intermedia de 10.7 MHz
