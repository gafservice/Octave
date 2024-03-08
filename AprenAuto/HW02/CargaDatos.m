## Carga de Datos
pkg list
## sudo apt-get install octave-image
pkg load image;
## sudo apt-get install octave-io
pkg load io;

% Especifica la ruta del archivo CSV
ubi_file = '/home/famltp02/Documents/GitHub/Octave/AprenAuto/HW02/BPC.csv';

% Usa csv2cell para cargar los datos en una celda
pkg load io;
## datos_celda = csv2cell(ubi_file);
datos = csvread(ubi_file);
##Muestra los datos en forma de celda
##disp(datos_celda);
## z = csvread(ubi_file, 1,1, 1,6)
y = dlmread (ubi_file, 2, 2, 2:5)
## z = datos_celda(2:11, 3)
## X = datos_celda(2:11, 4:5)
## p = [150, 3; 200, 4; 120, 2];

## z es la variable que contiene los precios reales de las casas
## X es la variable que contiene metros cuadrados de construcion y numero de habitaciones que contiene cada casas
## disp(size(p))
## disp(size(X))
## disp(size(z))

