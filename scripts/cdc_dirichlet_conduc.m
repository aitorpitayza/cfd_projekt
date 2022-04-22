function [ K_bc ] = cdc_dirichlet_conduc(T_cc_D_cond_left,...
    T_cc_D_cond_right, N, Normalesx, Normalesy, Rc, Areas, Vol, Rn, kk, t)


% Esta función impone el valor de la temperatura en los contornos laterales
% del dominio (Método de Dirichlet).

%   Entradas
%   ........
%
%   - T_cc_D_cond_left: distribución de temperaturas en el límite izquierdo
%                       del dominio.
%   - T_cc_D_cond_right: distribución de temperaturas en el límite derecho
%                       del dominio.
%   - N: número de celdas.
%   - Areas: matriz que contiene la longitud de cada lado de las celdas.
%   - Vol: vector que contiene las áreas de las celdas de la malla 
%   - Normalesx:matriz que contiene la componente x de los vectores normales de cada lado de
%               las celdas. Normalesx(i,j): componente x del vec. normal a
%               la cara j de la celda i.
%  - Normalesy: matriz que contiene la componente y de los vectores normales de cada lado de
%               las celdas. % 
%   - Rn: matriz que contiene las coordenadas de los nodos de la malla.
%   - t: instante temporal.
%   - kk: conductividad térmica [W/mK].

%   Salida
%   ......
%
%   - K_bc: parte conductiva de los términos independientes asociada al 
%           instante temporal.            

% HEMOS QUITADO n' A LA HORA DE HACER EL PRODUCTO ESCALAR


K_bc = zeros( 1, N );

for i = 1:N
    for j = 1:3
        k = [Normalesx(i,j),Normalesy(i,j)];
        if k == -1 
            
        n = [Normalesx(i,j),Normalesy(i,j)]; 
        
        ri = [Rc(i,1) Rc(i,2)];
        rj = [0 Rc(i,2)];
        vect = ri - rj;
        dist = norm(vect);
        
        dn = producto_escalar(vect,n);
      
        K_bc(i) = -Areas(i,j)*dn/Vol(i)/dist^2*...
            T_cc_D_cond_left(Rc(i,2),t);
        
        elseif  k == -2
        
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

K_bc = K_bc*kk;
K_bc = sparse(K_bc);
end