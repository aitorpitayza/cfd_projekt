function [A, b] = temp(t, grid, v, datos, Tipo_CC, cc_inlet, cc_left, cc_right, disc)

% Esta función representa la EDO ya discretizada con las matrices de los 
% términos ya calculadas.
%
%   Entradas
%   ........
%   
%       T : Vector temperaturas en los centroides de las celdas.
%       t : instante de tiempo (s)
%       grid : variable struct con la información de la malla necesaria.
%       v : función velocidad en función de (x,y) y del tiempo. v = f(x,y,t).
%       datos : cv, cp, rho y kk.
%       Tipo_CC : Vector que almacena el tipo de CC a izqda Tipo_CC(1) y  a 
%                 derecha Tipo_CC(2). 1 : Dirichlet, 2 : Neumann
%       cc_inlet : función de la posición "x" y del tiempo que determina la 
%                  temperatura a la entrada del dominio.
%       cc_left : función de la posición "y" y del tiempo que determina la cc en
%                 el lado izquierdo del dominio.
%       cc_right : función de la posición "y" y del tiempo que determina la ccen
%                 el lado derecho del dominio.
%       
%   Salida 
%   ......
%
%       Si la matriz jacobiana del problema es dT/dt, esta cumple: 
%
%               dT/dt = A * T + b                                       (1)
%
%       A : matriz A de la ec. (1)
%       b : vector de términos independientes, ec.(1)
%
% Para ello : 

% ------------- Términos convectivos -------------

% Matrices
if (disc == 1)
[C, C_BC] = convec( grid, v, t);
elseif (disc == 2)
[C, C_BC] = convec_gds( grid, v, t);
end

% Término independiente
c_bc = cc_convec( cc_inlet, grid, v, t);

% ------------- Términos conductivos -------------

% Conductividad térmica :
kk = datos.kk;
rho = datos.rho;
cv = datos.cv;

% Matrices
[K, K_BC ] = conduc(grid, Tipo_CC);

% Término independiente
k_bc = cc_conduc(cc_left, cc_right, grid, t, Tipo_CC);

% Suma de todos los términos
A = K * kk / (rho *  cv) + K_BC * kk / (rho *  cv) + ...
        C + C_BC;

b = k_bc * kk / (rho *  cv) + c_bc;
