# Created by Octave 6.4.0, Wed Nov 15 23:27:23 2023 CST <ingtaller@ingtaller>
pkg load control
pkg load signal
s=tf("s")
#G = 10 / (0.1*s+1)
#[T, t] = step(G)
#data =[t,T]
# step(G,"--g")
# hold
# ramp(G)
# hold
# impulse(G)



E = 1/(s^2+s)
t = 0.5
n = 5
[num,den] = padecoef (t, n)
F = tf(num,den)/(s^2+s)
G = E - F
impulse(G)
