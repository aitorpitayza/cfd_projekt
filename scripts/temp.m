function [dT_dt] = temp(T, t, grid_preproc, cv, rho)

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

grid_preproc.N = N; % Numero de celdas.
grid_preproc.volumes = Vol; % Matriz que almacena el volumen de cada celda.
grid_preproc.areas = Areas; % Matriz que almacena el area de cada celda.
grid_preproc.nx = Normalesx; % Matriz X componente del vector normal.
grid_preproc.ny = Normalesy; % Matriz y componente del vector normal.
grid_preproc.connectivity = Vecinos; % Matriz que contiene las celdas ...
% vecinas de cada elemento de la malla.

% Falta script para BCtop;

[ C , C_BC_arriba] = convec( Vol, Areas,... 
    Normalesx,Normalesy, N, Vecinos,  BCtop, v, cv, rho)