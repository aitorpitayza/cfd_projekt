function [dT_dt] = temp(T, t, grid_preproc, v,cv, rho)

% Esta función representa la EDO ya discretizada con las matrices de los 
% términos ya calculadas.
%
% --- Inputs ---
%   
%       T : Vector temperaturas en los centroides de las celdas.
%       t : instante de tiempo (s)
%       grid_preproc : variable struct con la información de la malla necesaria.
%
% --- Outputs ---
%
%       dT_dt : Vector derivada temporal de la temperatura en cada celda.
%

% ------------- Términos convectivos -------------

N = grid_preproc.N; % Numero de celdas.
Vol = grid_preproc.volumes; % Matriz que almacena el volumen de cada celda.
Areas = grid_preproc.areas; % Matriz que almacena el area de cada celda.
Normalesy = grid_preproc.ny ; % Matriz y componente del vector normal.
Vecinos = grid_preproc.connectivity; % Matriz que contiene las celdas ...
BCtop = grid_preproc.BCtop ; % Vector que almacena las celdas superiores del dominio.
Rc = grid_preproc.centroid; %Matriz Nx2 con las coordenadas de los centroides.
% Falta la funcion de la velocidad v = speed(t) (Nx2 matrix)

[ C , C_BC_arriba] = convec( Vol, Areas,... 
    Normalesx,Normalesy, N, Vecinos,  BCtop, v, cv, rho)