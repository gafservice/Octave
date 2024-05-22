% Parámetros de la señal de entrada
f_RF = 110e6; % Frecuencia de la señal RF en Hz
f_audio1 = 13.125e3; % Frecuencia del primer canal de audio en Hz
f_audio2 = 31.875e3; % Frecuencia del segundo canal de audio en Hz
f_audio3 = 50.625e3; % Frecuencia del tercer canal de audio en Hz

% Parámetros del oscilador local
f_LO = 99.3e6; % Frecuencia del oscilador local en Hz

% Parámetros de la señal modulada en FM
T = 1e-4; % Duración de la señal en segundos
t = 0:1e-9:T; % Vector de tiempo con paso de 1 ns para señal analógica

% Señales de audio
audio1 = sin(2 * pi * f_audio1 * t);
audio2 = sin(2 * pi * f_audio2 * t);
audio3 = sin(2 * pi * f_audio3 * t);

% Señal combinada de audio
audio_signal = audio1 + audio2 + audio3;

% Índice de modulación
kf = 1e5; % Coeficiente de frecuencia para la modulación

% Señal FM modulada
fm_signal = cos(2 * pi * f_RF * t + kf * cumsum(audio_signal));

% Señal del oscilador local
lo_signal = cos(2 * pi * f_LO * t);

% Mezcla de la señal RF con el oscilador local
mixed_signal = fm_signal .* lo_signal;

% Demodulación de la señal (En este caso, no se realiza una demodulación en el código ya que estamos en el dominio analógico)

% Visualización de las señales en el dominio del tiempo
figure;
subplot(3, 1, 1);
plot(t, fm_signal);
title('Señal FM Modulada (Dominio del Tiempo)');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3, 1, 2);
plot(t, mixed_signal);
title('Señal Mezclada (Dominio del Tiempo)');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3, 1, 3);
plot(t, audio_signal);
title('Señal de Audio (Dominio del Tiempo)');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Visualización de las señales en el dominio de la frecuencia
figure;
subplot(3, 1, 1);
fft_fm_signal = abs(fftshift(fft(fm_signal)));
plot(t, fft_fm_signal);
title('Espectro de la Señal FM Modulada (Dominio de la Frecuencia)');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3, 1, 2);
fft_mixed_signal = abs(fftshift(fft(mixed_signal)));
plot(t, fft_mixed_signal);
title('Espectro de la Señal Mezclada (Dominio de la Frecuencia)');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3, 1, 3);
fft_audio_signal = abs(fftshift(fft(audio_signal)));
plot(t, fft_audio_signal);
title('Espectro de la Señal de Audio (Dominio de la Frecuencia)');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');
