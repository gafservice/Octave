% Parámetros iniciales
fs = 1e8; % Frecuencia de muestreo (Hz) ajustada
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

% Crear un filtro pasabanda para la frecuencia intermedia (10.64 MHz a 10.76 MHz)
n = 1000; % Orden del filtro
Wn = [10.64e6 10.76e6] / (fs / 2); % Rango de frecuencias normalizado
filtro_pasabanda = fir1(n, Wn, 'bandpass');

% Filtrar la señal IF
IF_filtered = filtfilt(filtro_pasabanda, 1, IF_signal);

% Transformar la señal IF filtrada al dominio de la frecuencia
IF_filtered_freq = fft(IF_filtered);

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

% Señal IF en el Dominio de la Frecuencia
subplot(4,1,3);
plot(f_IF, fftshift(abs(IF_signal_freq)));
title('Señal Intermedia (IF) en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.2e6, 11.2e6]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización

% Señal IF Filtrada en el Dominio de la Frecuencia
subplot(4,1,4);
plot(f_IF, fftshift(abs(IF_filtered_freq)));
title('Señal Intermedia (IF) Filtrada en el Dominio de la Frecuencia');
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

% Desplegar los valores alrededor de las frecuencias de interés en la señal IF filtrada
frecuencias_interes = [10.7e6 + f1, 10.7e6 + f2, 10.7e6 + f3, 10.7e6 + f4];
for i = 1:length(frecuencias_interes)
    % Encontrar el índice más cercano a la frecuencia de interés
    [~, idx] = min(abs(f_IF - frecuencias_interes(i)));
    % Mostrar la frecuencia de interés y los valores alrededor
    disp(['Valores alrededor de la frecuencia ', num2str(frecuencias_interes(i)), ' Hz:']);
    disp(IF_filtered(max(1, idx-5):min(length(IF_filtered), idx+5)));
end
