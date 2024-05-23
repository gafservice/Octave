% Duración de la señal en segundos
duration = 1; 
% Frecuencia de muestreo en Hz
fs = 1e7; 
% Vector de tiempo
t = linspace(0, duration, fs); 

% Frecuencia de RF a sintonizar en Hz
freq_RF = 110e6;
% Frecuencia intermedia (FI) en Hz
freq_FI = 10.7e6;
% Ancho de banda en Hz
bandwidth = 120e3;

% Frecuencia del oscilador local (LO) en Hz
freq_LO = freq_RF - freq_FI;

% Generación de la señal de RF (sinusoidal a 110 MHz)
%FMmodulada = sin(2 * pi * freq_RF * t);  % Ejemplo de señal FM modulada
signal_RF = FMmodulada;

% Generación de la señal del LO (sinusoidal a 99.3 MHz)
signal_LO = sin(2 * pi * freq_LO * t);

% Mezcla de señales (multiplicación para obtener la FI)
mixed_signal = signal_RF .* signal_LO;

% Transformada de Fourier de la señal mezclada
N = length(t);
FFT_mixed = fft(mixed_signal);
f = linspace(-fs/2, fs/2, N);

% Crear un filtro pasabajo en el dominio de la frecuencia
fc = (freq_FI + bandwidth/2) / (fs/2); % Frecuencia de corte normalizada
H = double(abs(f) <= fc * fs/2);

% Aplicar el filtro a la señal en el dominio de la frecuencia
filtered_FFT = FFT_mixed .* fftshift(H);

% Transformada inversa de Fourier para obtener la señal filtrada
filtered_signal = ifft(filtered_FFT);

% Visualización de los resultados en el dominio del tiempo
figure('Position', [100, 100, 1200, 800]);

subplot(4,1,1);
plot(t, signal_RF);
title('Señal de RF (110 MHz)');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(4,1,2);
plot(t, signal_LO);
title('Señal del Oscilador Local (99.3 MHz)');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(4,1,3);
plot(t, mixed_signal);
title('Señal Mezclada (FI sin filtrar)');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(4,1,4);
plot(t, real(filtered_signal));
title('Señal Filtrada (FI de 10.7 MHz)');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Visualización de los resultados en el dominio de la frecuencia
figure('Position', [100, 100, 1200, 800]);

subplot(4,1,1);
plot(f, abs(fftshift(fft(signal_RF))));
title('Espectro de Frecuencia de la Señal RF');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(4,1,2);
plot(f, abs(fftshift(fft(signal_LO))));
title('Espectro de Frecuencia de la Señal LO');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(4,1,3);
plot(f, abs(fftshift(FFT_mixed)));
title('Espectro de Frecuencia de la Señal Mezclada');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(4,1,4);
plot(f, abs(fftshift(filtered_FFT)));
title('Espectro de Frecuencia de la Señal Filtrada');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');



