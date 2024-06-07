% Parámetros iniciales
fs = 25e6; % Frecuencia de muestreo (Hz)
t = linspace(0, 1, fs); % Vector de tiempo de 1 segundo

% Crear señal de prueba de 10 Hz
audio_signal = sin(2 * pi * 10 * t); % Señal de prueba de 10 Hz

% Frecuencias de subportadoras y portadoras
fc = 110e6; % Frecuencia central de 110 MHz
f1 = 1875; % Frecuencia de 1875 Hz
f2 = 13125; % Frecuencia de 13125 Hz
f3 = 31875; % Frecuencia de 31875 Hz
f4 = 58625; % Frecuencia de 58625 Hz
f_lo = 120.7e6; % Frecuencia del oscilador local
frecuencia_central = 10.7e6; % Frecuencia intermedia (IF) central

% Generación de subportadoras y señales moduladas
fxRight = sin(2 * pi * f1 * t);
fxLeft = sin(2 * pi * f2 * t);
fxCenter = sin(2 * pi * f3 * t);
fxPiloto = sin(2 * pi * f1 * t);

% Modular la señal de prueba en la subportadora de 13,125 Hz
modulated_signal = audio_signal .* cos(2 * pi * f2 * t);

% Generar la señal FM modulada
IndMod = 0.5; % Índice de modulación
subporta = fxPiloto + modulated_signal + cos(2 * pi * f3 * t) + cos(2 * pi * f4 * t);
FMmodulada = cos(2 * pi * fc * t + IndMod * subporta);

% Transformar la señal FM modulada al dominio de la frecuencia
FMmodulada_freq = fftshift(fft(FMmodulada));
f_FMmodulada = linspace(-fs/2, fs/2, length(FMmodulada_freq));

% Crear oscilador local para obtener una IF de 10.7 MHz
osc_lo = cos(2 * pi * f_lo * t); % Señal del oscilador local

% Mezclar la señal de prueba con el oscilador local para obtener la señal IF
IF_signal = FMmodulada .* osc_lo;

% Transformar la señal IF al dominio de la frecuencia
IF_signal_freq = fftshift(fft(IF_signal));
f_IF = linspace(-fs/2, fs/2, length(IF_signal_freq)) * fs / length(IF_signal_freq);

% Filtrar la señal IF para extraer la subportadora centrada en 10.7 MHz + 13,125 Hz
f_IF_subcarrier = 10.7e6 + 13125; % Frecuencia de la subportadora en IF
ancho_banda = 15000; % Ancho de banda de la subportadora (Hz)

% Crear un filtro paso banda centrado en 10.7 MHz +/- 13,125 Hz
Wn = [(f_IF_subcarrier - ancho_banda/2) / (fs/2), (f_IF_subcarrier + ancho_banda/2) / (fs/2)];
[b_bandpass, a_bandpass] = butter(4, Wn, 'bandpass');

% Aplicar el filtro paso banda
subportadora_filtrada = filter(b_bandpass, a_bandpass, IF_signal);

% Transformar la subportadora filtrada al dominio de la frecuencia
subportadora_filtrada_freq = fftshift(fft(subportadora_filtrada));
f_subportadora_filtrada = linspace(-fs/2, fs/2, length(subportadora_filtrada_freq));

% Demodular la subportadora para extraer la señal de prueba de 10 Hz
demodulated_signal = subportadora_filtrada .* cos(2 * pi * f2 * t);

% Filtrar nuevamente para eliminar la componente de alta frecuencia
[b_lowpass, a_lowpass] = butter(4, 20/(fs/2)); % Filtro pasa baja con frecuencia de corte de 20 Hz
demodulated_signal = filter(b_lowpass, a_lowpass, demodulated_signal);

% Transformar la señal demodulada al dominio de la frecuencia
demodulated_signal_freq = fftshift(fft(demodulated_signal));
f_demodulated_signal = linspace(-fs/2, fs/2, length(demodulated_signal_freq));

% Graficar las señales en el dominio de la frecuencia y tiempo
figure;

% Gráficas en el dominio de la frecuencia
subplot(3,1,1);
plot(f_FMmodulada + fc, abs(FMmodulada_freq));
title('Señal de Prueba en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([fc - 1e6, fc + 1e6]);

subplot(3,1,2);
plot(f_IF, abs(IF_signal_freq));
title('Señal Intermedia (IF) en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([5e6, 15e6]);

subplot(3,1,3);
plot(f_subportadora_filtrada, abs(subportadora_filtrada_freq));
title('Subportadora Filtrada en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([f_IF_subcarrier - 1e4, f_IF_subcarrier + 1e4]);

% Gráficas en el dominio del tiempo y frecuencia de la señal demodulada
figure;

subplot(2,1,1);
plot(t, demodulated_signal);
title('Señal Demodulada en el Dominio del Tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');
xlim([0, 0.1]);

subplot(2,1,2);
plot(f_demodulated_signal, abs(demodulated_signal_freq));
title('Señal Demodulada en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([-20, 20]);

disp('Frecuencia central de la subportadora demodulada:');
disp(num2str(f_IF_subcarrier));

