function [ v ] = Matriz_Veloc( Rc, N, velocidad)
  

% Esta función asigna un valor de la distribución de velocidad al centroide 
% para cada celda de la malla.

%   Entradas
%   ........
%
%   - Rc: matriz que contiene las coordenadas del centroide de cada celda.
%   - N:  número de celdas.
%   - velocidad: distribución de velocidades dependiente del espacio.

%   Salida
%   ......
%
%   - v: matriz de dimensión N filas y dos columnas que contiene las 
%        componentes de la velocidad en m/s en los centroides de cada celda 
%        de la malla.



  v = zeros(N,2);

for i =1:N
    
    v(i,:) = velocidad(Rc(i,1),Rc(i,2));
    
end

end
