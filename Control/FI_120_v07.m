% Parámetros iniciales
fs = 25e6; % Frecuencia de muestreo (Hz)
t = linspace(0, 1, fs); % Vector de tiempo de 1 segundo

% Crear señal de prueba centrada en 110 MHz con componentes en frecuencias específicas
fc = 110e6; % Frecuencia central de 110 MHz

Right = 2000;
Left = 1000;
Center = 500;

BandWidth = 120000; % Ancho de banda (Hz)
FXporta = 110e6; % Frecuencia portadora (Hz)
fxpiloto = 1875; % 1875 Hz
fxbase = fxpiloto * 2; % 3750 Hz
fxbaja = fxpiloto * 7; % 13125 Hz
fxmedia = fxpiloto * 17; % 31875 Hz
fxalta = fxpiloto * 27; % 50625 Hz

% Generación de las señales
fxRight = sin(2 * pi * Right * t);
fxLeft = sin(2 * pi * Left * t);
fxCenter = sin(2 * pi * Center * t);

% Generación de subportadoras
fxPiloto = sin(2 * pi * fxpiloto * t);
fxBaja = sin(2 * pi * fxbaja * t);
fxMedia = sin(2 * pi * fxmedia * t);
fxAlta = sin(2 * pi * fxalta * t);

% Desplazamiento por medio de multiplicación 
desCH01 = sin(2 * pi * (fxRight + fxbaja) .* t); % Multiplicación element-wise
desCH02 = sin(2 * pi * (fxLeft + fxmedia) .* t);
desCH03 = sin(2 * pi * (fxCenter + fxalta) .* t);

% Generar la señal de prueba (modulación de amplitud)
subporta = fxPiloto + desCH01 + cos(2 * pi * 31875 * t) + cos(2 * pi * 50625 * t); % Se reemplazan f3 y f4 por valores específicos
IndMod = 0.5; % Índice de modulación (ajusta según sea necesario)
FMmodulada = cos(2 * pi * FXporta * t + IndMod * subporta);

% Transformar la señal de prueba al dominio de la frecuencia
FMmodulada_freq = fftshift(fft(FMmodulada));
f_FMmodulada = linspace(-fs/2, fs/2, length(FMmodulada_freq)); % Frecuencias para la señal de prueba

% Crear oscilador local de 120.7 MHz para obtener una IF de 10.7 MHz
f_lo = 120.7e6; % Frecuencia del oscilador local
osc_lo = cos(2 * pi * f_lo * t); % Señal del oscilador local

% Transformar el oscilador local al dominio de la frecuencia
osc_lo_freq = fftshift(fft(osc_lo));
f_osc_lo = linspace(-fs/2, fs/2, length(osc_lo_freq)); % Frecuencias para el oscilador local

% Mezclar la señal de prueba con el oscilador local para obtener la señal IF
IF_signal = FMmodulada .* osc_lo;

% Transformar la señal IF al dominio de la frecuencia
IF_signal_freq = fftshift(fft(IF_signal));
f_IF = linspace(-fs/2, fs/2, length(IF_signal_freq)) * fs / length(IF_signal_freq); % Frecuencias para la señal IF

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
componentes_significativas = f_IF(locs);
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

% Graficar las señales en el dominio de la frecuencia de forma independiente
figure;
plot(f_FMmodulada + fc, abs(FMmodulada_freq));
title('Señal de Prueba en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([fc - 60e3, fc + 60e3]); % Mostrar un rango más amplio alrededor de 110 MHz

figure;
plot(f_osc_lo + f_lo, abs(osc_lo_freq));
title('Señal del Oscilador Local en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([f_lo - 60e3, f_lo + 60e3]); % Mostrar un rango más amplio alrededor de 120.7 MHz

figure;
plot(f_IF, abs(IF_signal_freq)); % Ajustar para centrar en 10.7 MHz
title('Señal Intermedia (IF) en el Dominio de la Frecuencia (sin filtrar)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.6e6 - 60e3, 10.7e6 + 60e3]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización

figure;
plot(f_IF, abs(IF_signal_freq)); % Ajustar para centrar en 10.7 MHz
hold on;
plot(f_IF(locs), peaks, 'ro'); % Marcar los picos significativos
title('Componentes Significativas en la Señal IF');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([10.6e6 - 60e3, 10.7e6 + 60e3]); % Mostrar un rango más cerrado alrededor de 10.7 MHz para mejor visualización
hold off;

% Aplicar filtro en el dominio de la frecuencia para extraer la componente de 13125 Hz (subportadora)
filtro_pasabanda = (f_IF > (frecuencia_central + fxbaja - 7500)) & (f_IF < (frecuencia_central + fxbaja + 7500));
IF_signal_filtrada_freq = IF_signal_freq .* filtro_pasabanda;

% Transformar la señal filtrada de vuelta al dominio del tiempo
IF_signal_filtrada = ifft(ifftshift(IF_signal_filtrada_freq));

% Demodular la subportadora para extraer la señal de prueba de 10 Hz
demodulated_signal = IF_signal_filtrada .* cos(2 * pi * fxbaja * t);

% Transformar la señal demodulada al dominio de la frecuencia
demodulated_signal_freq = fftshift(fft(demodulated_signal));
f_demodulated_signal = linspace(-fs/2, fs/2, length(demodulated_signal_freq));

% Aplicar filtro en el dominio de la frecuencia para eliminar la componente de alta frecuencia
filtro_pasabaja = (abs(f_demodulated_signal) < Right); % Frecuencia de corte ajustada a la frecuencia de Right
demodulated_signal_freq_filtrada = demodulated_signal_freq .* filtro_pasabaja;

% Transformar la señal filtrada de vuelta al dominio del tiempo
demodulated_signal_filtrada = ifft(ifftshift(demodulated_signal_freq_filtrada));

% Ganancia adicional para la señal demodulada
ganancia = max(abs(fxRight)) / max(abs(demodulated_signal_filtrada));
demodulated_signal_filtrada = demodulated_signal_filtrada * ganancia;

% Graficar la señal demodulada en el dominio del tiempo
figure;
plot(t, demodulated_signal_filtrada);
title('Señal Demodulada en el Dominio del Tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');
xlim([0, 0.01]); % Mostrar una pequeña porción del tiempo para mejor visualización

% Graficar la señal demodulada en el dominio de la frecuencia
figure;
plot(f_demodulated_signal, abs(demodulated_signal_freq_filtrada));
title('Señal Demodulada en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([-Right, Right]); % Ajustar el rango de frecuencia para centrarse alrededor de la frecuencia de Right

% Comparar la señal original y la señal demodulada
figure;
subplot(2,1,1);
plot(t, fxRight);
title('Señal Original (fxRight)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
xlim([0, 0.01]);

subplot(2,1,2);
plot(t, demodulated_signal_filtrada);
title('Señal Demodulada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
xlim([0, 0.01]);

disp('Frecuencia central de la subportadora demodulada:');
disp(num2str(fxbaja));

% Filtrar la señal IF para extraer la componente de 1875 Hz
filtro_pasabanda_piloto = (f_IF > (frecuencia_central + fxpiloto - 1000)) & (f_IF < (frecuencia_central + fxpiloto + 1000));
IF_signal_piloto_filtrada_freq = IF_signal_freq .* filtro_pasabanda_piloto;

% Transformar la señal filtrada de vuelta al dominio del tiempo
IF_signal_piloto_filtrada = ifft(ifftshift(IF_signal_piloto_filtrada_freq));

% Demodular la señal piloto para extraer la señal de prueba
senal_piloto = IF_signal_piloto_filtrada .* cos(2 * pi * frecuencia_central * t);

% Transformar la señal demodulada al dominio de la frecuencia
senal_piloto_freq = fftshift(fft(senal_piloto));
f_senal_piloto = linspace(-fs/2, fs/2, length(senal_piloto_freq));

% Aplicar filtro en el dominio de la frecuencia para eliminar la componente de alta frecuencia
filtro_pasabaja_piloto = (abs(f_senal_piloto) < 2000); % Frecuencia de corte de 2 kHz
senal_piloto_freq_filtrada = senal_piloto_freq .* filtro_pasabaja_piloto;

% Transformar la señal filtrada de vuelta al dominio del tiempo
senal_piloto_filtrada = ifft(ifftshift(senal_piloto_freq_filtrada));

% Graficar la señal piloto en el dominio de la frecuencia
figure;
plot(f_senal_piloto, abs(senal_piloto_freq_filtrada));
title('Señal Piloto en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([-5e3, 5e3]); % Mostrar un rango cerrado alrededor de la frecuencia de 0 Hz

% Encontrar el valor de la frecuencia más cercana a 1875 Hz antes del PLL
[~, idx_antes_PLL] = min(abs(f_senal_piloto - 1875));
frecuencia_antes_PLL = f_senal_piloto(idx_antes_PLL);
disp(['Frecuencia antes del PLL: ', num2str(frecuencia_antes_PLL), ' Hz']);

% Implementación de un PLL básico para seguir la señal piloto de 1875 Hz
% Parámetros del PLL
Kp = 0.1; % Ganancia proporcional
Ki = 0.01; % Ganancia integral
N = length(senal_piloto);
f0 = 1875; % Frecuencia nominal de la señal piloto
vco_freq = zeros(1, N);
phase_error = zeros(1, N);
integral = 0;

% Inicialización del VCO
vco_phase = 0;
vco_output = zeros(1, N);

% Bucle PLL
for n = 1:N
    % VCO
    vco_output(n) = cos(2 * pi * f0 * t(n) + vco_phase);
    
    % Error de fase
    phase_error(n) = senal_piloto_filtrada(n) * vco_output(n);
    
    % Integrador
    integral = integral + Ki * phase_error(n);
    
    % Controlador PI
    vco_freq(n) = f0 + Kp * phase_error(n) + integral;
    
    % Actualización de la fase del VCO
    if n < N
        vco_phase = vco_phase + 2 * pi * vco_freq(n) / fs;
    end
end

% Obtener el valor de la frecuencia después del PLL
frecuencia_despues_PLL = mean(vco_freq);

% Calcular las variables fxbajadem, fxmediadem, fxaltadem
fxbajadem = frecuencia_despues_PLL * 7;
fxmediadem = frecuencia_despues_PLL * 17;
fxaltadem = frecuencia_despues_PLL * 27;

% Graficar la frecuencia del VCO
figure;
plot(t, vco_freq);
title('Frecuencia del VCO del PLL');
xlabel('Tiempo (s)');
ylabel('Frecuencia (Hz)');
xlim([0, 0.01]); % Mostrar una pequeña porción del tiempo para mejor visualización

% Mostrar los valores
disp(['Frecuencia antes del PLL: ', num2str(frecuencia_antes_PLL), ' Hz']);
disp(['Frecuencia después del PLL: ', num2str(frecuencia_despues_PLL), ' Hz']);
disp(['fxbajadem: ', num2str(fxbajadem), ' Hz']);
disp(['fxmediadem: ', num2str(fxmediadem), ' Hz']);
disp(['fxaltadem: ', num2str(fxaltadem), ' Hz']);


