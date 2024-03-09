% Datos de ejemplo
X = [1; 2; 3; 4; 5];   % Variable predictora
z = [3; 6; 8; 11; 13];  % Variable de respuesta

% Construir la matriz de diseño con el término de intercepción
X_with_intercept = [ones(size(X)), X];

% Calcular los coeficientes de regresión utilizando la pseudoinversa
theta = pinv(X_with_intercept) * z;

% Imprimir los coeficientes estimados
disp('Coeficientes estimados:');
disp(theta);

% Graficar los datos y la regresión lineal
scatter(X, z, 'o', 'DisplayName', 'Datos');
hold on;

% Calcular la línea de regresión
x_values = linspace(min(X), max(X), 100);
y_values = [ones(100, 1), x_values'] * theta;

plot(x_values, y_values, 'r', 'DisplayName', 'Regresión Lineal');
xlabel('Variable Predictora');
ylabel('Variable de Respuesta');
legend('Location', 'northeast');  % Explicitly set the legend location
title('Regresión Lineal con Pseudoinversa');
grid on;
hold off;
