% Cargar las librerias de control
pkg load control
pkg load signal
% Definir s como variable de la funcion de transferencia
s=tf("s")
% M_C: Modelo que describe el desplazamiento del carro de la grua
% M_A: Modelo que describe el Angulo en que se mueve el pendulo que tiene el carro de la grua


M_C = 0.05/(s^2+0.8*s)
M_A = (-0.4*(s+2))/(s^2+0.1*s+30)

zpk(M_C)
zpk(M_A)

% M_C: Modelo que describe el desplazamiento y angulo de la grua
C_ss=ss(M_C)
A_ss=ss(M_A)

C_ss
A_ss


% Matriz A combinada pasando de sus sistama SISO a uno SIMO
%A = [0 0 1 0; 0 0 0 1; 0 0 -0.8 0; 0 -30 0 -0.1 ]

% Matriz B combinada pasando de sus sistama SISO a uno SIMO
%B = [ 0; -0.4; 0.05; 0.76 ]

% Matriz C combinada pasando de sus sistama SISO a uno SIMO
%C = [ 1 0 0 0; 0 1 0 0 ]

% Funciones Canonicamento observables y controlables

% Definir una matriz de espacio de estado A, B, C, D
A = [1 2; 3 4];
B = [5; 6];
C = [7 8];
D = 9;

% Obtener la forma canónica de controllabilidad
% Crear matrices A_ctrl, B_ctrl, C_ctrl y D_ctrl
A_ctrl = [A zeros(size(A, 1), 1); C 0];
B_ctrl = [B; D];
C_ctrl = [eye(size(A, 1)) zeros(size(A, 1), 1)];
D_ctrl = zeros(1, size(A, 1) + 1);

% Mostrar las matrices de la forma canónica de controllabilidad
disp('Matrices de la forma canónica de controllabilidad:');
disp('A_ctrl:');
disp(A_ctrl);
disp('B_ctrl:');
disp(B_ctrl);
disp('C_ctrl:');
disp(C_ctrl);
disp('D_ctrl:');
disp(D_ctrl);

% Obtener la forma canónica de observabilidad
A_obs = [A; B];
B_obs = [C; D];
C_obs = [eye(n); 0];
D_obs = zeros(1, n);

% Mostrar las matrices de la forma canónica de observabilidad
disp('Matrices de la forma canónica de observabilidad:');
disp('A_obs:');
disp(A_obs);
disp('B_obs:');
disp(B_obs);
disp('C_obs:');
disp(C_obs);
disp('D_obs:');
disp(D_obs);