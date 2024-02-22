## Seccion Gradiente parte 4
## se su función para mostrar tres casos de paraboloides:
## Use su función para mostrar tres casos de paraboloides: (10 pts)
## 4.3. Matriz simétrica no diagonal, que debe ser positiva definida.
function  FSPT_P403(M22, V02, Rangos, Const)
#######################



  disp(M22);
  disp(V02);
  disp(Rangos);
  disp(Const);
  
[x1, x2] = meshgrid(Rangos(1):0.3:Rangos(2), Rangos(1):0.3:Rangos(2)); 

whos x1 x2



  # ordenar los valores de x1 y x2 como una matriz 
  X = [x1(:) x2(:)]';
  disp('Valores de X:');
  disp(X(1:2, 1:2));  % Muestra las primeras filas y  columnas de X
  



whos M22;
whos X;
whos V02;
m22x = M22 * X;
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
    title('Resultado Evaluar ecuacion con una Matriz simétrica no diagonal,  ');
hold on
 
M22_inv = inv(M22);
# para el calculo del vextor x minimo 
x_min = -M22_inv * V02;
whos x_min;
#X = [x1(:) x2(:)]';




end