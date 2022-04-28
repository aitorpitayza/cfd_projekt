function [ T_ini ] = Matriz_T_inicial( Rc, N, T_ci )

% Esta función asigna un valor inicial de temperatura a través de la
% distribución definida dependiente del espacio.

%   Entradas
%   ........
%
%   - Rc: matriz que contiene las coordenadas del centroide de cada celda.
%   - N:  número de celdas.
%   - T_ci: distribución de temperaturas dependiente del espacio.

%   Salida
%   ......
%
%   - T_ini: vector de temperaturas iniciales.

T_ini = zeros(1,N);

for i =1:N
    
    T_ini(i) = T_ci(Rc(i,1),Rc(i,2));
    
end

end