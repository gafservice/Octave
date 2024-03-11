## Copyright (C) 2022-2024 Pablo Alvarado
## EL5857 Aprendizaje automático
## Tarea 2

## -*- texinfo -*-
## @deftypefn {Function File} {@var{rz} =} linreg(@var{p},@var{X},@var{z})
## @deftypefnx {Function File} {[@var{rz},theta] =} linreg(@var{p},@var{X},@var{z})
## Linear regression with intercept
##
## Given a set of m training points in @var{X} with known 'z'-values
## stored in in the vector @var{z}, estimate the 'z'-values on the
## n data points @var{p}, which usually lie somewhere inbetween the
## points in @var{X}.  Optionally return the found parameters
## @var{theta}.
##
## @param @var{p}: matrix of size n x d, with n d-D positions on which
##                 the z value needs to be regressed
##
## @param @var{X}: support data (or training data) with all m known d-D
##                 positions
##
## @param @var{z}: support data with the corresponding m z values for
##                 each position in @var{X}
##
## @return @var{rz}: the n z-values for each data in @var{p}
##
## @return @var{theta}: estimated parameters
##
## The number of rows of @var{X} must be equal to the length of @var{z}.
##
## The function must generate the z position for all data points in @var{p}.
##
## Usage:
##
## rz=linreg(p,X,z)
##
## [rz,theta]=linreg(p,X,z)
## @end deftypefn
function varargout=linreg(p,X,z)
 

  ## This code is for simple linear regression
% Graficar la matriz p
% Visualizar las filas y columnas de p
  ## CHANGE THE FOLLOWING CODE
  ## You have to replace it for proper linear regression with intercept
  ##
  ## (The following two lines are copied from linreg_nointercept.m and
  ##  should be replaced with correct code)
  Pseudoinversa:

Calculemos ahora la pseudoinversa C+C+ utilizando la fórmula de la pseudoinversa de Moore-Penrose:


  theta=pinv(X)*z(:);
  rz=p*theta;

  ## The first returned value must be the estimated rz heights.
  varargout{1}=rz;

  if nargout>1
    ## The user also wants the parameters theta
    varargout{2}=theta;
  endif
 
  % Graficar los datos originales
 %scatter3(p(:,1), p(:,2), z, 'o', 'filled');
 %hold on;

% Graficar la línea de regresión
p_estimados = linspace(min(p(:,1)), max(p(:,1)), 100);
z_estimados = linspace(min(p(:,2)), max(p(:,2)), 100);
[P_estimados, Z_estimados] = meshgrid(p_estimados, z_estimados);
X_estimados = [P_estimados(:), Z_estimados(:)];
rz_estimados = X_estimados * theta;
rz_estimados = reshape(rz_estimados, size(P_estimados));
mesh(P_estimados, Z_estimados, rz_estimados, 'FaceAlpha', 0.5);


xlabel('Variable p1');

ylabel('Variable p2');

zlabel('Valor z');
title('Regresión Lineal con Intercepción');

% Mostrar la leyenda
##legend('Datos Origs','Línea de Reón');

hold off;


figure


% Crear una imagen de ejemplo

imagen = zeros(100, 100); % Puedes cargar tu propia imagen o generar una aquí
imagen = ones(100, 100, 3); 
% Valor que deseas mostrar como etiqueta
eti01= (['Valor de la casa', p(1,1)]);
format short
dato11 = p(1,1);
stre11 = num2str(dato11);
dato12 = p(1,2);
stre12 = num2str(dato12);

dato21 = rz(1);
stre21 = num2str(rz(1));



eti01 = ['las una casa de:  ', stre11, '  m2 con: ', stre12, ' dormitorios '];
% Coordenadas donde se ubicará la etiqueta en la imagen
x1 = 1;
y1 = 40;

eti02 = ['Puede llegar a costar:  ', stre21, '  dollares '];
x2= 1;
y2 = 60;
% Mostrar la imagen
imshow(imagen);

% Superponer el valor como una etiqueta en la imagen
text(x1, y1, num2str(eti01), 'color', 'blue', 'FontSize', 20, 'FontWeight', 'bold');

text(x2, y2, num2str(eti02), 'color', 'red', 'FontSize', 20, 'FontWeight', 'bold');

  por
    
endfunction







