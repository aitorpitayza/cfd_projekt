function [ K_bc ] = cdc_dirichlet_conduc( cc_left, cc_right, grid, t )

% Esta función impone el valor de la temperatura en los contornos laterales
% del dominio (Método de Dirichlet).

%   Entradas
%   ........
%
%   - cc_left : función de temperaturas en el límite izquierdo del dominio.
%   - cc_right : función de temperaturas en el límite derecho del dominio.
%
%   - grid : variable struct con datos de la malla. Esta contiene : 
%
%   -> N: número de celdas.
%   -> Areas: matriz que contiene la longitud de cada lado de las celdas.
%   -> Vol: vector que contiene las áreas de las celdas de la malla 
%   -> Normalesx:matriz que contiene la componente x de los vectores normales de
%                cada lado de las celdas. Normalesx(i,j): componente x del vec.
%                normal a la cara j de la celda i.
%   -> Normalesy: matriz que contiene la componente y de los vectores normales
%                 de cada lado de las celdas. 
%   -> Rc: matriz que contiene las coordenadas del centroide de cada celda.
%   -> Vecinos : matriz de conectividad de las celdas.
%
%   - t: instante temporal.

%   Salida
%   ......
%
%   - K_bc: parte conductiva de los términos independientes asociada al 
%           instante temporal.            

% HEMOS QUITADO n' A LA HORA DE HACER EL PRODUCTO ESCALAR


K_bc = zeros( 1, N );


N = grid.N;
Vol = grid.volumes;
Areas = grid.areas;
Normalesx = grid.nx;
Normalesy = grid.ny;
Rc = grid.centroid;
Vecinos = grid.connectivity;

T_cc_D_cond_left = @cc_left;
T_cc_D_cond_right = @cc_right;

for i = 1:N
    for j = 1:3

        k =  Vecinos(i,j);

        if (k == -1) % CC Left 
            
            n = [Normalesx(i,j),Normalesy(i,j)]; 
        
            ri = [Rc(i,1) Rc(i,2)];
            rj = [0 Rc(i,2)];
            vect = ri - rj;
            dist = norm(vect);
            
            dn = producto_escalar(vect,n);
        
            K_bc(i) = -Areas(i,j)*dn/Vol(i)/dist^2*...
                T_cc_D_cond_left(Rc(i,2),t);
        
        elseif  (k == -2) % CC Right
        
            n= [Normalesx(i,j),Normalesy(i,j)]; 
            
            ri = [Rc(i,1) Rc(i,2)];
            rj = [max(Rn(:,1)) Rc(i,2)];
            vect = ri - rj;
            dist = norm(vect);
            
            dn = producto_escalar(vect,n);
                
            K_bc(i) = -Areas(i,2*j-1)*dn/Vol(i)/dist^2*...
                T_cc_D_cond_right(Rc(i,2),t);
            
        end
    end
end

% K_bc = sparse(K_bc);

end