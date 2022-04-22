function [ Temp ] = euler_implicito( MatA_n1, VectB, dT, Tempi,N)

% Esta función realiza el cálculo mediante el método de integración
% de Euler implícito (implícito de primer orden). 

%   Entradas
%   ........
%
%   - MatA_n1: Matriz del sistema en el siguiente instante temporal. 
%   - VectB: Vector de términos independientes del sistema en el instante
%            temporal actual.
%   - dT: paso temporal
%   - Tempi: Matriz de temperaturas en el instante de cálculo. 
%   - N: numero de celdas.

%   Salidas
%   ......
%
%   - Temp: Matriz de temperaturas solución. 

MatI=eye(N);
M_sys= MatI-dT*MatA_n1;
M_sys= sparse(M_sys); 
    
Temp = M_sys\(Tempi + dT*VectB');


end