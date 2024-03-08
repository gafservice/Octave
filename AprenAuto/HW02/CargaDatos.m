format short

## Carga de Datos
pkg list
## sudo apt-get install octave-image
pkg load image;
## sudo apt-get install octave-io
pkg load io;

% Especifica la ruta del archivo CSV
ubi_file = 'BPC.csv';

% Usa csv2cell para cargar los datos en una celda
## datos_celda = csv2cell(ubi_file);

md = csvread(ubi_file);
##Muestra los datos en forma de celda
##disp(datos_celda);
## z = csvread(ubi_file, 1,1, 1,6)
## y = dlmread (ubi_file, 2, 2, 2:5)

## p representa datos dimesiones de casas para averiguarles su precios
p = [150, 3; 200, 4; 120, 2]

## datos de metros cuarados de construccion de  casas  ya existentes
mcc = md(2:11, 4)

## datos de numero de dormitorios de  casas  ya existent
ndd = md(2:11, 6)

## compilacion de datos de mcc y ndd un usa sola matriz
X = [mcc,ndd]

## datos de precios de propiedades con casas  ya existent
z = md(2:11, 3)


whos p
whos mcc
whos ndd
whos z
whos X
## z = datos_celda(2:11, 3)
## X = datos_celda(2:11, 4:5)
## p = [150, 3; 200, 4; 120, 2];

## z es la variable que contiene los precios reales de las casas
## X es la variable que contiene metros cuadrados de construcion y numero de habitaciones que contiene cada casas
disp(size(p))
disp(size(X))
disp(size(z))

format short