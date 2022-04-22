function [ K_bc ] = cdc_neumann_conduc( Grad_cc_N_izq, ...
    Grad_cc_N_dcha, N, Normalesx, Normalesy, Vol, Areas, Rc, kk, t )

% Esta función impone el valor de la temperatura en los contornos laterales
% del dominio (Método de Dirichlet).

%   Entradas
%   ........
%
%   - Grad_cc_N_izq: distribución del gradiente de temperaturas en el 
%                     límite izquierdo del dominio.
%   - Grad_cc_N_dcha: distribución del gradiente en el límite derecho
%                       del dominio.
%   - N: número de celdas.
%   - Areas: matriz que contiene la longitud de cada lado de las celdas.
%   - Vol: vector que contiene las áreas de las celdas de la malla 
%   - Normalesx:matriz que contiene la componente x de los vectores normales de cada lado de
%               las celdas. Normalesx(i,j): componente x del vec. normal a
%               la cara j de la celda i.
%  - Normalesy: matriz que contiene la componente y de los vectores normales de cada lado de
%               las celdas. % 
%   - Rc: matriz que contiene las coordenadas del centroide de cada celda.
%   - t: instante temporal.
%   - kk: conductividad térmica [W/mK].

%
%   Salida
%   ......
%
%   - K_bc: parte conductiva de los términos independientes asociada al 
%           instante temporal.

K_bc = zeros( 1, N );

for i = 1:N
    for j = 1:3
        k =  [Normalesx(i,j),Normalesy(i,j)];
        if k == -1 
      
        K_bc(i) = 1/Vol(i)*Areas(i,2*j-1)*Grad_cc_N_izq(Rc(i,2),t);
        
        elseif  k == -2
        
        K_bc(i) = 1/Vol(i)*Areas(i,2*j-1)*Grad_cc_N_dcha(Rc(i,2),t);
            
        end
    end
end

K_bc = K_bc*kk;
K_bc = sparse(K_bc);

end
