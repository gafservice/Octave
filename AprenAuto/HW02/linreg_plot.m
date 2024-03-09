function varargout = linreg_plot(p, X, z)
  % Este código es para regresión lineal simple con intercepción

  % Añadir una columna de unos para el término de intercepción
  X_with_intercept = [ones(size(X, 1), 1), X];

  % Calcular los coeficientes de regresión utilizando la pseudoinversa
  theta = pinv(X_with_intercept) * z(:);

  % Estimar las alturas rz para los puntos en p
  rz = [ones(size(p, 1), 1), p] * theta;

  % Graficar los resultados
  figure;

  % Gráfico 3D de los datos de soporte
  subplot(2, 1, 1);
  plot3(X(:, 1), X(:, 2), z', '.', 'MarkerSize', 10, 'DisplayName', 'Datos de Soporte');
  xlabel('X1');
  ylabel('X2');
  zlabel('Z');
  legend('Location', 'Best');
  title('Datos de Soporte');
  grid on;

  % Gráfico de barras para los parámetros theta
  subplot(2, 1, 2);
  bar(theta, 'DisplayName', 'Parámetros \theta');
  xlabel('Índice de Parámetro');
  ylabel('Valor');
  title('Parámetros de Regresión Lineal');
  grid on;

  % Mostrar la leyenda en el segundo gráfico
  legend('Location', 'Best');

  % El primer valor devuelto debe ser las alturas estimadas rz.
  varargout{1} = rz;

  if nargout > 1
    % Devolver los parámetros theta si es necesario
    varargout{2} = theta;
  end
end

% Ejemplo de uso:
% Definir datos de soporte (X y z)
X = rand(100, 2);  % Ejemplo: datos de entrada X de 100 filas y 2 columnas
z = 2*X(:, 1) + 3*X(:, 2) + 1 + 0.1*randn(100, 1);  % Ejemplo: valores de salida z

% Generar puntos para evaluar la regresión (p)
p = rand(20, 2);  % Ejemplo: puntos de evaluación p de 20 filas y 2 columnas

% Llamar a la función para realizar la regresión, graficar y marcar los resultados
linreg_plot(p, X, z);
