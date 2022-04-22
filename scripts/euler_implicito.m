function [ Temp ] = euler_implicito( MatA_n1, VectB, dT, Tempi,N)

% Esta funci�n realiza el c�lculo mediante el m�todo de integraci�n
% de Euler impl�cito (impl�cito de primer orden). 

%   Entradas
%   ........
%
%   - MatA_n1: Matriz del sistema en el siguiente instante temporal. 
%   - VectB: Vector de t�rminos independientes del sistema en el instante
%            temporal actual.
%   - dT: paso temporal
%   - Tempi: Matriz de temperaturas en el instante de c�lculo. 
%   - N: numero de celdas.

%   Salidas
%   ......
%
%   - Temp: Matriz de temperaturas soluci�n. 

MatI=eye(N);
M_sys= MatI-dT*MatA_n1;
M_sys= sparse(M_sys); 
    
Temp = M_sys\(Tempi + dT*VectB');


end