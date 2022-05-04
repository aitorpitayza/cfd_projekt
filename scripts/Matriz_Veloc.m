function [ v ] = Matriz_Veloc( Rc, N, velocidad)
  
% Esta funci�n asigna un valor de la distribuci�n de velocidad al centroide 
% para cada celda de la malla.

%   Entradas
%   ........
%
%   - Rc: matriz que contiene las coordenadas del centroide de cada celda.
%   - N:  n�mero de celdas.
%   - velocidad: distribuci�n de velocidades dependiente del espacio.

%   Salida
%   ......
%
%   - v: matriz de dimensi�n N filas y dos columnas que contiene las 
%        componentes de la velocidad en m/s en los centroides de cada celda 
%        de la malla.



  v = zeros(N,2);

for i =1:N
    
    v(i,:) = velocidad(Rc(i,1),Rc(i,2));
    
end

end
