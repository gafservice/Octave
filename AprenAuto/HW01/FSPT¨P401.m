#######################

### Seccion Gradiente parte 4
#se su función para mostrar tres casos de paraboloides:
# 4.1. Matriz A igual a la matriz identidad escalada cI.


function FSPT_P401(M22, V02, Rangos,Const)


  disp(M22);
  disp(V02);
  disp(Rangos);
  disp(Const);
 

[x1, x2] = meshgrid(Rangos(1):0.3:Rangos(2), Rangos(1):0.3:Rangos(2)); 

whos x1 x2


  disp('Datos dentro de x1:');
  disp(x1(1:2, 1:2));
  
#  Imprimir en pantalla  datos de x2
  disp('Datos demtro de x2:');
  disp(x2(1:2, 1:2)); 


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




solu02 =0.5 * sum((X' * M22* X).^2) + V02' * X;
whos solu02;


solu02 = reshape(solu02, size(x1));
 figure;
    surf(x1, x2, solu02);
    xlabel('x1');
    ylabel('x2');
    zlabel('solu');
    title('Resultado Evaluar ecuacion ');
hold on
 
M22_inv = inv(M22);
# para el calculo del vextor x minimo 
x_min = -M22_inv * V02;
whos x_min;
#X = [x1(:) x2(:)]';

##############################################3
[min_val, min_idx] = min(solu02);
[min_x1, min_x2] = ind2sub(size(solu02), min_idx);

hold on;
  contour(x1, x2, solu02, 20, 'LineColor', 'k', 'LineWidth', 1.5);
##Demarcar el valor mínimo
    plot3(x1_range(min_x1), x2_range(min_x2), min_val, 'ro', 'MarkerSize', 10);
    hold off;


end
