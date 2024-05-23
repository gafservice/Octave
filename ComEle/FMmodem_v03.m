% Para los análisis que hace Matlab en función del tiempo es necesario
% tener una referencia para las gráficas y comportamiento de las funciones
% Para nuestro caso se va a usar 1 segundo denominado 'foto' la cual va a tener 
% una exposición de 0 a 1 segundo, subdividida en 10000 pares
foto = 1; % Duración de la señal (segundos), dichos valores se visualizan
% en el eje x
fs = 10000; % Frecuencia de muestreo (Hz)
t = linspace(0, foto, fs); % Vector de tiempo

% Definición de las variables
Right = 1;
Left = 1;
Center = 1;

BandWidth = 120000; % Frecuencia central (Hz)
FXporta = 110000000;  % Ancho de banda (Hz)
fxpiloto = 1875; % 1875 hz
fxbase = fxpiloto * 2; % 3750 hz
fxbaja = fxpiloto * 7; % 13125 hz
fxmedia = fxpiloto * 17; % 31875  hz
fxalta = fxpiloto * 27; % 50625 hz 
 
%para poder distribuir equitativamente el ancho de banda contemplamos los siguientes
%tenemos un ancho de banda de 120 los cuales basado en fourier donde del análisis en
%el dominio de la frecuencia sabemos que las señales se repiten, por lo tanto solo se
%puede usar la mitad del ancho de banda es decir 60, de 60 lo tenemos que dividir en tres portadoras
% de tal forma que cada una no exceda del 15000 hz, por lo tanto nos queda 15000 libres los cuales 
% se usan para que sirvan de salvaguarda entre las subportadoras, separando cada subportadora + frecuencia maxima en 
% 5000 hz partiendo de la frecuencia de 19000
% y tomando lo anterior expuesto es que sacamos los valores de las otras subportadoras 
% que para referencia serán 13125, 31875 y 50625
espacio_guarda = 3750; % hz
FmaxAudioMax = 15000;

% Cálculo del índice de modulación
HBW = BandWidth / 2;
IndMod =  HBW / FmaxAudioMax;

% Generación de las señales
fxRight = sin(2*pi*Right*t);
fxLeft = sin(2*pi*Left*t);
fxCenter = sin(2*pi*Center*t);

% Generación de sub_portadoras
fxPiloto = sin(2*pi*fxpiloto*t);
fxBaja = sin(2*pi*fxbaja*t);
fxMedia = sin(2*pi*fxmedia*t);
fxAlta = sin(2*pi*fxalta*t);

% Desplazamiento por medio de multiplicación 
desCH01 = sin(2*pi*(fxRight + fxBaja).*t); % Multiplicación element-wise
desCH02 = sin(2*pi*(fxLeft + fxMedia).*t);
desCH03 = sin(2*pi*(fxCenter + fxAlta).*t);

% Multiplicación de las subportadoras de audio con la frecuencia piloto
subporta = fxPiloto + desCH01 + desCH02 + desCH03;

% Modulación FM
FMmodulada = cos(2*pi*FXporta*t + IndMod*subporta);

% Transformada de Fourier
N = length(t);
f = (-fs/2 : fs/N : fs/2 - fs/N); % Vector de frecuencias

% Cálculo de la FFT para cada señal y operación
FFT_fxRight = fftshift(fft(fxRight, N));
FFT_fxLeft = fftshift(fft(fxLeft, N));
FFT_fxCenter = fftshift(fft(fxCenter, N));
FFT_modCH01 = fftshift(fft(desCH01, N));
FFT_modCH02 = fftshift(fft(desCH02, N));
FFT_modCH03 = fftshift(fft(desCH03, N));
FFT_subporta = fftshift(fft(subporta, N));
FFT_FModulada = fftshift(fft(FMmodulada, N));

% Visualización de los resultados en función del tiempo
figure('Position', [100, 100, 800, 600]);

subplot(3,1,1);
plot(t, fxRight, 'b');
title('Señal Right en el tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,2);
plot(t, fxLeft, 'r');
title('Señal Left en el tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,3);
plot(t, fxCenter, 'g');
title('Señal Center en el tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

figure('Position', [100, 100, 800, 600]);

subplot(3,1,1);
plot(t, desCH01, 'm');
title('CH01 modulada');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,2);
plot(t, desCH02, 'c');
title('CH02 modulada');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,3);
plot(t, desCH03, 'y');
title('CH03 modulada');
xlabel('Tiempo (s)');
ylabel('Amplitud');

figure('Position', [100, 100, 800, 600]);

subplot(3,1,1);
plot(t, subporta, 'k');
title('Suma de Portadoras');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,2);
plot(t, FMmodulada, 'm');
title('Señal FMmodulada en el tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Visualización de los resultados en función de la frecuencia
figure('Position', [100, 100, 800, 600]);

subplot(3,1,1);
plot(f, abs(FFT_fxRight), 'b');
title('Espectro de frecuencia de la señal Right');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3,1,2);
plot(f, abs(FFT_fxLeft), 'r');
title('Espectro de frecuencia de la señal Left');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3,1,3);
plot(f, abs(FFT_fxCenter), 'g');
title('Espectro de frecuencia de la señal Center');
subplot(3,1,3);
plot(f, abs(FFT_fxCenter), 'g');
title('Espectro de frecuencia de la señal Center');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

figure('Position', [100, 100, 800, 600]);

subplot(3,1,1);
plot(f, abs(FFT_modCH01), 'm');
title('Espectro de frecuencia de CH01 modulada');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3,1,2);
plot(f, abs(FFT_modCH02), 'c');
title('Espectro de frecuencia de CH02 modulada');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3,1,3);
plot(f, abs(FFT_modCH03), 'y');
title('Espectro de frecuencia de CH03 modulada');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

figure('Position', [100, 100, 800, 600]);

subplot(3,1,1);
plot(f, abs(FFT_subporta), 'k');
title('Espectro de frecuencia de Suma de Portadoras');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3,1,2);
plot(f, abs(FFT_FModulada), 'm');
title('Espectro de frecuencia de la señal FMmodulada');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');
