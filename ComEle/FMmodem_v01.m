% Para los anlisis que hace Matlab en funcin del tiempo es necesario
% tener una referencia para las grficas y comportamiento de las funciones
% Para nuestro caso se va a usar 1 segundo denominado 'foto' la cual va a tener 
% una exposicin de 0 a 1 segundo, subdividida en 10000 pares
foto = 1; % Duracin de la seal (segundos), dichos valores se visualizan
% en el eje x
fs = 10000; % Frecuencia de muestreo (Hz)
t = linspace(0, foto, fs); % Vector de tiempo

% Definicin de las variables
Right = 1;
Left = 1;
Center = 1;

BandWidth = 120000; % Frecuencia central (Hz)
FXporta = 110000000;  % Ancho de banda (Hz
fxpiloto = 1875 % 1875 hz
fxbase = fxpiloto * 2% 3750 hz
fxbaja = fxpiloto * 7% 13125 hz
fxmedia = fxpiloto * 17 % 31875  hz
fxalta = fxpiloto * 27 % 50625 hz 
 
%para poder distribuir equitativamente el ancho de banda contemplamos los siguiente
%tenemos un ancho de banda de 120 los cuales basado en fourier donde del analicis en
%el dominio de la frecuencia sabemos que la seales se repiten, por lo tanto solo se
%uede usar la mitad del ancho de banda es decir 60, de 60 lo tenemos que dividir en tres portadoras
% de tal forma que cada una no exceda del 15000 hz, por lo tanto nos queda 1500o libres los cuales 
% se usan para que sirvan de salvaguarda entre las subportadoras, separando cada subportadora + frecuencia maxima en 
% 5000 hz partiendo de la freuciancia de 19000
% y tomando lo naterior expuesto es que sacamos los valores de las otras subportadoras 
% que para referencia seran 19000, 39000 y 59000
espacio_guarda =3500 ; % hz
FmaxAudio = 15000;


% Clculo del ndice de modulacin
HBW = BandWidth / 2;
%IndMod = FmaxAudio / HBW;
IndMod =  HBW / FmaxAudio 
%#############################no estoy seguro del calculo del indici de modulacion
% Generacin de las seales
fxRight = sin(2*pi*Right*t);
fxLeft = sin(2*pi*Left*t);
fxCenter = sin(2*pi*Center*t);

% Generacin de sub_portadoras
fxPiloto = sin(2*pi*fxpiloto*t);
fxBaja = sin(2*pi*fxbaja*t);
fxMedia = sin(2*pi*fxmedia*t);
fxAlta = sin(2*pi*fxalta*t);

% Desplazamiento por medio de multiplicacion 
%desCH01 = fxRight .* fxBaja;
%desCH02 = fxLeft .* fxMedia;
%desCH03 = fxCenter .* fxAlta;
desCH01 = sin(2*pi*(fxRight + fxBaja).*t);
desCH02 = sin(2*pi*(fxLeft + fxMedia).*t);
desCH03 = sin(2*pi*(fxCenter + fxAlta).*t);


%multiplizado de las subportadoras de audio con la frecuencia piloto
subporta = fxPiloto + desCH01 + desCH02 + desCH03;

% Modulacin FM
FMmodulada = cos(2*pi*FXporta*t + IndMod*subporta);

% Transformada de Fourier
N = length(t);
f = (-fs/2 : fs/N : fs/2 - fs/N); % Vector de frecuencias

% Clculo de la FFT para cada seal y operacin
FFT_fxRight = fftshift(fft(fxRight, N));
FFT_fxLeft = fftshift(fft(fxLeft, N));
FFT_fxCenter = fftshift(fft(fxCenter, N));
FFT_modCH01 = fftshift(fft(desCH01, N));
FFT_modCH02 = fftshift(fft(desCH02, N));
FFT_modCH03 = fftshift(fft(desCH03, N));
FFT_subporta = fftshift(fft(subporta, N));
FFT_FModulada = fftshift(fft(FMmodulada, N));

% Visualizacin de los resultados en funcin del tiempo
figure;

subplot(3,1,1);
plot(t, fxRight, 'b');
title('Seal Right en el tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,2);
plot(t, fxLeft, 'r');
title('Seal Left en el tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,3);
plot(t, fxCenter, 'g');
title('Seal Center en el tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

figure;

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

figure;

subplot(3,1,1);
plot(t, subporta, 'k');
title('Suma de Portadoras');
xlabel('Tiempo (s)');
ylabel('Amplitud');


subplot(3,1,2);
plot(t, FMmodulada, 'm');
title('Seal FMmodulada en el tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Visualizacin de los resultados en funcin de la frecuencia
figure;

subplot(3,1,1);
plot(f, abs(FFT_fxRight), 'b');
title('Espectro de frecuencia de la seal Right');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3,1,2);
plot(f, abs(FFT_fxLeft), 'r');
title('Espectro de frecuencia de la seal Left');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3,1,3);
plot(f, abs(FFT_fxCenter), 'g');
title('Espectro de frecuencia de la seal Center');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

figure;

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

figure;

subplot(3,1,1);
plot(f, abs(FFT_subporta), 'k');
title('Espectro de frecuencia de Suma de Portadoras');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(3,1,2);
plot(f, abs(FFT_FModulada), 'm');
title('Espectro de frecuencia de la seal FMmodulada');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');