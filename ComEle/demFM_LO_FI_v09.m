pkg load signal; % Cargar el paquete de señales si está disponible

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
f_FMmodulada = linspace(-fs/2, fs/2, length(FMmodulada_freq)); % Frecuencias para la señal de prueba

% Crear oscilador local de 120.7 MHz para obtener una IF de 10.7 MHz
f_lo = 120.7e6; % Frecuencia del oscilador local
osc_lo = cos(2 * pi * f_lo * t); % Señal del oscilador local

% Transformar el oscilador local al dominio de la frecuencia
osc_lo_freq = fft(osc_lo);
f_osc_lo = linspace(-fs/2, fs/2, length(osc_lo_freq)); % Frecuencias para el oscilador local

% Mezclar la señal de prueba con el oscilador local para obtener la señal IF
IF_signal = FMmodulada .* osc_lo;

% Transformar la señal IF al dominio de la frecuencia
IF_signal_freq = fft(IF_signal);
f_IF = linspace(-fs/2, fs/2, length(IF_signal_freq)) * (fs/length(IF_signal_freq)); % Frecuencias para la señal IF

% Identificar las componentes de frecuencia significativas
magnitudes = abs(IF_signal_freq);
threshold = max(magnitudes) * 0.1; % Umbral para identificar picos significativos

% Encuentra los picos manualmente
peaks = [];
locs = [];
for i = 2:length(magnitudes)-1
    if magnitudes(i) > magnitudes(i-1) && magnitudes(i) > magnitudes(i+1) && magnitudes(i) > threshold
        peaks = [peaks; magnitudes(i)];
        locs = [locs; i];
    end
end

% Calcular el desplazamiento desde la frecuencia central
frecuencia_central = 10.7e6;
desplazamiento_derecha = max(f_IF(locs) - frecuencia_central);
desplazamiento_izquierda = min(f_IF(locs) - frecuencia_central);

disp(['Desplazamiento hacia la derecha: ', num2str(desplazamiento_derecha), ' Hz']);
disp(['Desplazamiento hacia la izquierda: ', num2str(desplazamiento_izquierda), ' Hz']);

% Valores numéricos de las componentes significativas
componentes_significativas = f_IF(locs) + frecuencia_central;
disp('Componentes significativas en la señal IF:');
disp(num2str(componentes_significativas, '%.0f'));

% Magnitudes de los picos significativos
magnitudes_picos = peaks;
disp('Magnitudes de los picos significativos:');
disp(num2str(magnitudes_picos, '%.2f'));

% Mostrar frecuencias y magnitudes significativas juntas
disp('Frecuencia (Hz)    Magnitud');
for i = 1:length(componentes_significativas)
    disp([num2str(componentes_significativas(i), '%.0f'), '    ', num2str(magnitudes_picos(i), '%.2f')]);
end

% Graficar las señales en el dominio de la frecuencia
figure;

% Primer grupo de gráficas
subplot(3,1,1);
plot(f_FMmodulada + fc, fftshift(abs(FMmodulada_freq)));
title('Señal de Prueba en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([fc - 500e3, fc + 500e3]); % Mostrar un rango más cerrado alrededor de 110 MHz para mejor visualización

subplot(3,1,2);
plot(f_osc_lo + f_lo, fftshift(abs(osc_lo_freq)));
title('Señal del Oscilador Local en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([f_lo - 500e3, f_lo + 500e3]); % Mostrar un rango más cerrado alrededor de 120.7 MHz para mejor visualización

subplot(3,1,3);
plot(f_IF + frecuencia_central, fftshift(abs(IF_signal_freq))); % Ajustar para centrar en 10.7 MHz
title('Señal Intermedia (IF) en el Dominio de la Frecuencia (sin filtrar)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([frecuencia_central - 500e3, frecuencia_central + 500e3]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización

% Segundo grupo de gráficas
figure;

subplot(2,1,1);
plot(f_IF + frecuencia_central, abs(IF_signal_freq)); % Ajustar para centrar en 10.7 MHz
title('Producto del Filtro IF Centrado en el Dominio de la Frecuencia (sin filtrar)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([frecuencia_central - 500e3, frecuencia_central + 500e3]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización

subplot(2,1,2);
plot(f_IF + frecuencia_central, abs(IF_signal_freq)); % Ajustar para centrar en 10.7 MHz
hold on;
plot(f_IF(locs) + frecuencia_central, peaks, 'ro'); % Marcar los picos significativos
title('Componentes Significativas en la Señal IF');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([frecuencia_central - 500e3, frecuencia_central + 500e3]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización
hold off;

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
