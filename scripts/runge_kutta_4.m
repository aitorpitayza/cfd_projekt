function [ T_1] = runge_kutta_4( T, jacobiana_linealizada, t, dt)

% Esta función realiza el cálculo mediante el método de integración
% de Crank Nicolson (implícito de segundo orden). 

%   Entradas
%   ........
%
%   - T : vector temperaturas en el instante temporal actual
%   - F : función de la matriz jacobiana del sistema
%
%   Salidas
%   ......
%
%   - T_1 : vector temperaturas en el instante temporal siguiente

[A_1, b_1] = jacobiana_linealizada(t);
[A_2, b_2] = jacobiana_linealizada(t + dt / 2);
[A_3, b_3] = jacobiana_linealizada(t + dt);

F_1 = A_1 * T + b_1;

k1 = dt * F_1;

F_2 = A_2 * (T + k1 / 2) + b_2;

k2 = dt * F_2;

F_3 = A_2 * (T + k2 / 2) + b_2;

k3 = dt * F_3;

F_4 = A_3 * (T + k3) + b_3;

k4 = dt * F_4;


T_1 = T + 1/6*(k1 + 2 * k2 + 2 * k3 + k4);
end