% Definir la función de transferencia en términos de tf
pkg load control

format short; % Ajustar la configuración de pantalla
s = tf('s');
M_A_tf = 0.05 / (s^2 + 0.8 * s)
sys_ss_octave = ss(M_A_tf)
disp(sys_ss_octave);