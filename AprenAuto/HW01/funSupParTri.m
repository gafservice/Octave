## Copyright (C) 2024 FAMltp02
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} funSupParTri (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: FAMltp02 <famltp02@famltp02>
## Author: Gerardo Araya Fallas
## Created: 2024-02-18
## funSupParTri() es una función que se crea con el proposito de capturar 
## tipos de valores: 
## matriz2x2 (Matriz de dos por dos
## Vector (Vector de dos dimensiones)
## Rangos (Rangos valores de inicio y final en los cuales se evalua la ecuacion)
## Algunas funciones que puede utilizar son, entre otras: sum, sumsq, 
## vecnorm, dot, meshgrid,surf, contour


function funSupParTri(M22, V02, Rangos)
## Sea la matriz A ∈ IRn×n simétrica, y sea el vector x ∈ IRn
## funcion a evaluar
## f(x) = 1/2 x⊤ A x + b⊤x
## f(x) necesita que los valores que se ingresen como X, sean valores vectoriales
## en un determinado rango, para lo cual se ingresa valores por medio de la funcion
## funSupParTri()

  disp(M22);
  disp(V02);
  disp(Rangos);
  
 
#La función meshgrid
#Devuelve una lista de matrices de coordenadas a partir de vectores de coordenadas
# fuente: https://interactivechaos.com/es/manual/tutorial-de-numpy/la-funcion-meshgrid
#La instrucción meshgrid(Rangos(1):0.3:Rangos(2), Rangos(1):0.3:Rangos(2)) 
#en GNU Octave genera matrices bidimensionales x1 y x2 utilizando la función meshgrid. 
#Los datos generados son matrices que representan todas las combinaciones posibles de coordenadas
# en el rango especificado.
# fuente: https://chat.openai.com/c/1acd1a3c-9def-4fdc-adc7-1cdac79cf302
[x1, x2] = meshgrid(Rangos(1):0.3:Rangos(2), Rangos(1):0.3:Rangos(2)); 

whos x1 x2

## 1.4.3 Rangos
##Un “rango” es una forma conveniente de construir vectores con elementos espaciados uniforme-
## mente. El rango esta definido por el valor inicial, incremento (opcional) y valor final separados
## por ‘:’. Si el incremento no está se asume 1.
## octave> a=1:0.5:3
## a =  1.0000 1.5000 2.0000 2.5000 3.0000
##octave> a=5:10
## a = 5 6 7 8 9 10
## fuente :https://cimec.org.ar/foswiki/pub/Main/Cimec/MetodosNumericosYSimulacion/metnums.pdf
## fuente : https://docs.bokeh.org/en/3.0.2/docs/user_guide/basic/axes.html 
  
## X(1:2, 1:2): Esta expresión selecciona una submatriz de XX que incluye las filas 1 y 2, y las columnas 1 y 2. 
##  En términos generales, X(i:j, k:l) selecciona las filas desde ii hasta jj 
## y las columnas desde kk hasta ll de la matriz XX.  
## fuente : https://chat.openai.com/c/1acd1a3c-9def-4fdc-adc7-1cdac79cf302
#  Imprimir en pantalla datos de x1
  disp('Datos dentro de x1:');
  disp(x1(1:2, 1:2));
  
#  Imprimir en pantalla  datos de x2
  disp('Datos demtro de x2:');
  disp(x2(1:2, 1:2)); 

  figure;
  scatter(x1(:), x2(:), 'filled');
  xlabel('x1');
  ylabel('x2');
  title('Visualización de x1 y x2 plamp bidimesional');

  figure;
  surf(x1, x2);
  xlabel('x1','FontSize', 14);
  ylabel('x2','FontSize', 14);
  zlabel('z','FontSize', 20);
  title('Visualizacion de x1 y x2');
  
  # ordenar los valores de x1 y x2 como una matriz 
  X = [x1(:) x2(:)]';
  disp('Valores de X:');
  disp(X(1:2, 1:2));  % Muestra las primeras filas y  columnas de X
  
  figure;
  surf(X);
  xlabel('x','FontSize', 20);
  ylabel('y','FontSize', 20);
  zlabel('z','FontSize', 20);
  title('Visualizacion de X');

## La función sum(), cuando se aplica a una matriz,
## devuelve un vector fila en la que cada elemento 
## es la suma de los elementos de la columna correspondiente
## de la matriz pasada como argumento.
## fuente : https://octaveintro.readthedocs.io/en/latest/matrices.html
## Para evaluar la funcion dada: ## f(x) = 1/2 x⊤ A x + b⊤x
# primero se hace el producto de A*X
# donde X contiene los valores de x1 y x2 en un arreglo matricial bidimesional
# y el termino A es la matriz cuadrada ingresada en el inicio


#disp('matriz2x2X');
#  disp(matriz2x2X(1:2, 1:2));
#siguiendo el orden se multiplica por la transpuesta de X

#disp('XTAX');
 # disp(XTAX(1:2, 1:2));
#siguiendo el orden se multiplica por 1/2


whos M22;
whos X;
whos V02;
m22x = M22* X;
whos m22x;
xm22x = X' * M22* X;
whos xm22x;
v02x = V02' * X;
whos v02x;
cuadra = (X' * M22* X).^2;
whos cuadra ;
sumatoria = sum((X' * M22* X).^2);
whos sumatoria;


##para medir distancias entre puntos  se suele utilizar
# la norma euclidiana, lo que por medio de elevar al cuadrado
# y sumar los resultados de elevar se ajustan los valores a que 
# sean dos positivos y dupicando los valores fuera de rango lo que 
# permite ubicarlos y descartarlos mas facilmente para este caso se
# uso el error cuadratico medio.

solu01 =0.5 * (X' * M22* X) + V02' * X;
whos solu01;

solu02 =0.5 * sum((X' * M22* X).^2) + V02' * X;
whos solu02;

# al aplicar el metodo de error cuadratico medio 
# se pasa de 
# Attr  Name        Size                     Bytes  Class
#  ==== ====        ====                     =====  =====
#       solu01   4489x4489               161208968  double
##### a
#   Attr Name        Size                     Bytes  Class
#   ==== ====        ====                     =====  =====
#        solu02      1x4489                   35912  double




##### Para el item 3 del apartado de gradientes   
# donde  ∇x​f(x)=Ax+b, 
# calculando para cuando ∇xf(x)=0
# tenemos que x=−2(AT)−1b
#tomado de: https://www.disfrutalasmatematicas.com/algebra/matriz-inversa.html
# para calcular el valor de x tenemos que`
# para el calculo de la inversa de A

solu02 = reshape(solu02, size(x1));
 figure;
    surf(x1, x2, solu02);
    xlabel('x1');
    ylabel('x2');
    zlabel('solu');
    title('Resultado Evaluar el gradiente de la función');
hold on


#Calcular el gradiente de la función
#Utilice ahora la función quiver para mostrar además el gradiente de la función paraboloide
#del punto 4.3. 
 # el siguiente codigo para calcular y graficar los minimos de la funcion
 # fueron consultados de: https://chat.openai.com/c/1acd1a3c-9def-4fdc-adc7-1cdac79cf302
####[gx, gy] = gradient(solu02);
# Agregar contornos para visualización adicional
####    hold on;
####    contour(x1, x2, solu02, 20, 'LineColor', 'k', 'LineWidth', 1.5);

    % Agregar los vectores de gradiente con quiver
####    quiver(x1, x2, -gx, -gy, 'Color', 'r', 'LineWidth', 1.5);

####hold off;


end
