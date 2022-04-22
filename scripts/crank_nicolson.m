function [ Temp] = crank_nicolson( MatA, MatA_n1, VectB,...
      VectB_n1, dT, Tempi,N)

% Esta función realiza el cálculo mediante el método de integración
% de Crank Nicolson (implícito de segundo orden). 

%   Entradas
%   ........
%
%   - MatA: Matriz del sistema en el instante temporal actual. 
%   - MatA_n1: Matriz del sistema en el siguiente instante temporal.
%   - MatI: matriz identidad.
%   - VectB: Vector de términos independientes del sistema en el instante
%            temporal actual.
%   - VectB_n1: Vector de términos independientes del sistema en el
%               siguiente instante temporal.   
%   - dT: paso temporal
%   - Tempi: Matriz de temperaturas en el instante de cálculo. 

%   Salidas
%   ......
%
%   - Temp: Matriz de temperaturas solución. 

MatI=eye(N);

    Temp = (MatI-0.5*dT*MatA_n1)\(Tempi+0.5*dT*MatA*Tempi +...
           0.5*dT*VectB' + 0.5*dT*VectB_n1');
end
