function [ K, K_BC ] = conduc(grid, Tipo_CC)
    % conduc( Vol, Areas, Rc, Rn, Normalesx,Normalesy,...
    % N, Vecinos, kk )


% Esta función entrega la matriz de conducción del dominio, así como la 
% parte conductiva relativa a las condiciones de contorno.

%   Entradas
%   ........
%
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
%   - Tipo_CC : vector que contiene información sobre las CC en los laterales.
%
%   Salida
%   ......
%
%   - K: matriz de conducción del problema.
%   - K_BC: matriz que contiene la parte conductiva asociada a las
%           condiciones de contorno.

N = grid.N;
Vol = grid.volumes;
Areas = grid.areas;
Normalesx = grid.nx;
Normalesy = grid.ny;
Rc = grid.centroid;
Rn = grid.nodes;
Vecinos = grid.connectivity;

K = zeros(N,N);
K_BC = zeros(N,N);

for i = 1:N
    for j = 1:3

        k = Vecinos(i,j);  

        if ( k > 0 )
 
            % Normal exterior para la cara j de la celda i
            n = [Normalesx(i,j);Normalesy(i,j)]; %Normal a la cara j de la celda i       
            ri = [Rc(i,1); Rc(i,2)];
            rj = [Rc(k,1); Rc(k,2)];
            vect = ri - rj;
            dist = norm(vect);   
            dn = producto_escalar(vect,n);
            cond = -Areas(i,j)*dn/(Vol(i)*dist^2);
            
            K(i,k) = cond;
            K(i,i) = K(i,i) - cond;
        
        elseif (k == -1) % Left CC

            if (Tipo_CC(1) == 1) % Dirichlet

                % Normal exterior para la cara j de la celda i   
                n = [Normalesx(i,j);Normalesy(i,j)]; 
                ri = [Rc(i,1); Rc(i,2)];
                rj = [min(Rn(:,1)); Rc(i,2)];
                vect = ri - rj;
                dist = norm(vect);
                dn = producto_escalar(vect,n);
                cond1 = -Areas(i,j)*dn/(Vol(i)*dist^2); 
                K_BC(i,i) = K_BC(i,i) - cond1;

            elseif (Tipo_CC(1) == 2) % Neumann

                % No hacemos nada

            end

        elseif  (k == -2) % Right CC

            if (Tipo_CC(1) == 1) % Dirichlet

                % Normal exterior para la cara j de la celda i
                n = [Normalesx(i,j);Normalesy(i,j)];
                
                ri = [Rc(i,1); Rc(i,2)];
                rj = [max(Rn(:,1)); Rc(i,2)];
                vect = ri - rj;
                dist = norm(vect);
                dn = producto_escalar(vect,n);
                cond2 = -Areas(i,j)*dn/(Vol(i)*dist^2);
                K_BC(i,i) = K_BC(i,i) - cond2;

            elseif (Tipo_CC(1) == 2) % Neumann

                % No hacemos nada

            end

        end


    end
end

K = sparse(K);

K_BC = sparse(K_BC);

end
