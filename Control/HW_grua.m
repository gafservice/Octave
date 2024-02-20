% Cargar las librerias de control
pkg load control
pkg load signal

s = tf("s")




disp('*************************  CARRITO **********************************');
% *************************  CARRITO *********************************

posicion=tf([0.23381],[1 9.667 0]) %carrito
disp('Matrices de variables de espacios de estado del esplazamiento del carritoo:');
carritoss=ss([0,1; 0 -9.667],[0; 0.23381],[1 0],0)

carritoss
disp('*************************  PENDULO **********************************');


% *************************  PENDULO **********************************
angulo=tf([0.3269 0.6612],[1 0.1162 35.37]) %pendulo
disp('Matrices de variables de espacios de estado del esplazamiento del pendulo:');
penduloss=ss([0 1; -35.37 -0.1162], [0 ;1],[0.6613 0.3269],0);

penduloss
disp('*********************************************************');
disp('*********************************************************');

% *************************  MATRICES AUMENTADAS **********************************



A00 = 0;
A01 = 0;
A02 = penduloss.a(1, 2)
A03 =0;
A10 =0;
A11 =0;
A12 =0;
A13 =0;
A20 =0;
A21 =0;
A22 = carritoss.a(2, 2)
A23 =0;
A30 =0;
A31 = penduloss.a(1, 2)
A32 =0;
A33 = penduloss.a(2, 2)

B00 =0;
B10 = penduloss.c(1, 1)*-1
B20 =0;
B30 = penduloss.c(1, 2)*-1

C00 = penduloss.a(1, 2)
C01 =0;
C02 =0;
C03 =0;
C10 =0;
C11 = carritoss.a(1, 2)
C12 =0;
C13 =0;


D00 =0;
D01 =0;
D02 =0;
D03 =0;
D10 =0;
D11 =0;
D12 =0;
D13 =0;
D20 =0;
D21 =0;
D22 =0;
D23 =0;
D30 =0;
D31 =0;
D32 =0;
D33 =0;



A=[A00 A01 A02 A03; A10 A11 A12 A13; A20 A21 A22 A23; A30 A31 A32 A33 ]
B=[B00 ; B10 ; B20 ; B30 ]
C=[C00 C01 C02 C03; C10 C11 C12 C13]
D=[D00 D01 D02 D03; D10 D11 D12 D13; D20 D21 D22 D23; D30 D31 D32 D33 ]

n = size(A, 1);
[A_obs, B_obs, C_obs, D_obs] = obsvf(A, B, C);

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

n = size(A, 1);
[A_ctrl, B_ctrl, C_ctrl, D_ctrl] = ctrbf(A_obs, B_obs, C_obs);

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

As = [A, zeros(4,1); -C, 0];

