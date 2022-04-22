function [ Temp] = crank_nicolson( MatA, MatA_n1, VectB,...
      VectB_n1, dT, Tempi,N)

% Esta funci�n realiza el c�lculo mediante el m�todo de integraci�n
% de Crank Nicolson (impl�cito de segundo orden). 

%   Entradas
%   ........
%
%   - MatA: Matriz del sistema en el instante temporal actual. 
%   - MatA_n1: Matriz del sistema en el siguiente instante temporal.
%   - MatI: matriz identidad.
%   - VectB: Vector de t�rminos independientes del sistema en el instante
%            temporal actual.
%   - VectB_n1: Vector de t�rminos independientes del sistema en el
%               siguiente instante temporal.   
%   - dT: paso temporal
%   - Tempi: Matriz de temperaturas en el instante de c�lculo. 

%   Salidas
%   ......
%
%   - Temp: Matriz de temperaturas soluci�n. 

MatI=eye(N);

    Temp = (MatI-0.5*dT*MatA_n1)\(Tempi+0.5*dT*MatA*Tempi +...
           0.5*dT*VectB' + 0.5*dT*VectB_n1');
end
