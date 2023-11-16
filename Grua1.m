% Cargar las librerías de control
pkg load control

% Definir s como variable de la función de transferencia
s = tf('s');

% Modelos SISO
M_C = 0.05 / (s^2 + 0.8 * s)
M_A = (-0.4 * (s + 2)) / (s^2 + 0.1 * s + 30)

% Modelos en espacio de estado
C_ss = ss(M_C);
A_ss = ss(M_A);

gruaSS = ss(C_ss)
% Invertir la matriz
A_invertida = inv(C_ss)

% Matrices de espacio de estado de los modelos SISO
A_C = C_ss.A;
B_C = C_ss.B;
C_C = C_ss.C;
D_C = C_ss.D;

A_A = A_ss.A;
B_A = A_ss.B;
C_A = A_ss.C;
D_A = A_ss.D;

% Verificar y ajustar las dimensiones
[n_C, m_C] = size(B_C);
[n_A, m_A] = size(B_A);

% Asegurar que ambas matrices tengan la misma cantidad de filas
if n_C < n_A
    B_C = [B_C; zeros(n_A - n_C, m_C)];
elseif n_A < n_C
    B_A = [B_A; zeros(n_C - n_A, m_A)];
end

% Matrices combinadas para el modelo SIMO
A_combined = [A_C, zeros(n_C, n_A); B_A * C_C, A_A];
B_combined = [B_C; B_A * D_C];
C_combined = [C_A, zeros(size(C_A, 1), n_A)];
D_combined = D_A + D_C * B_A;

% Mostrar las matrices A, B, C, D
disp('Matrices de espacio de estado combinadas:');
disp('A:');
disp(A_combined);
disp('B:');
disp(B_combined);
disp('C:');
disp(C_combined);
disp('D:');
disp(D_combined);