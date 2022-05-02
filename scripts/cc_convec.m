function [ c_bc ] = cc_convec(cc_inlet, grid, v, t)

% Esta función impone el valor de la temperatura en el contorno de la base
% de la malla (Método de Dirichlet).

%   Entradas
%   ........
%
%   - cc_inlet: distribución de temperaturas en el contorno inferior.
%   - grid : variable struct que contiene los siguientes datos
%
%   -> N: número de celdas.
%   -> Vol: vector que contiene las áreas de las celdas de la malla 
%   -> Area: matriz que contiene la longitud de cada lado de las celdas.
%   -> Normalesx: matriz que contiene la componente x de los vectores normales 
%                 de cada lado de las celdas. Normalesx(i,j): componente x del 
%                 vec. normal a la cara j de la celda i.
%   -> Normalesy: matriz que contiene la componente y de los vectores normales 
%                 de cada lado de las celdas. 
%   -> Rc: matriz que contiene las coordenadas del centroide de cada celda.
%   -> Rn: matriz que contiene las coordenadas de los nodos de la malla.
%   -> Vecinos: matriz que contiene las celdas vecinas de cada elemento de 
%              la malla.
%
%   - v : función velocidad en el dominio. v = f(x,y,t).
%   - t : tiempo (s)
%
%
%   Salida
%   ------
%
%   - c_bc: parte convectiva de los términos independientes asociada 
%                 al instante temporal.

N = grid.N;
Vol = grid.volumes;
Areas = grid.areas;
Normalesx = grid.nx;
Normalesy = grid.ny;
Rc = grid.centroid;
Rn = grid.nodes;
Vecinos = grid.connectivity;

T_conv_cc = cc_inlet;

c_bc = zeros( N, 1 );

for i = 1:N

    for j = 1:3 %Recorre los 3 lados

        k = Vecinos(i, j);

        if (k == -3) % Bottom CC
           
            c_bc( i ) = c_bc( i ) + 1 / Vol( i ) * Areas( i, j ) * ...
                norm(v(Rc(i,1), Rc(i,2), t)) * T_conv_cc(Rc(i,1),t);
            
        end

    end

end

% C_bc = sparse(C_bc);

end