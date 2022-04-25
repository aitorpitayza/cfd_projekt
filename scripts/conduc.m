function [ K, K_BC ] = conduc( Vol, Areas, Rc, Rn, Normalesx,Normalesy,...
    N, Vecinos, kk )


% Esta función entrega la matriz de conducción del dominio, así como la 
% parte conductiva relativa a las condiciones de contorno.

%   Entradas
%   ........
%
%   - N: número de celdas.
%   - Vol: vector que contiene las áreas de las celdas de la malla 
%   - Area: matriz que contiene la longitud de cada lado de las celdas.
%   - Normalesx:matriz que contiene la componente x de los vectores normales de cada lado de
%               las celdas. Normalesx(i,j): componente x del vec. normal a
%               la cara j de la celda i.
%  - Normalesy: matriz que contiene la componente y de los vectores normales de cada lado de
%               las celdas. % 
%   - Rc: matriz que contiene las coordenadas del centroide de cada celda.
%   - Rn: matriz que contiene las coordenadas de los nodos de la malla.
%   - Vecinos: matriz que contiene las celdas vecinas de cada elemento de 
%              la malla.
%   - t: instante temporal.
%   - kk: conductividad térmica [W/mK].
%
%   Salida
%   ......
%
%   - K: matriz de conducción del problema.
%   - K_BC: matriz que contiene la parte conductiva asociada a las
%           condiciones de contorno.

K = zeros(N,N);


% Porque j antes que i ??

for i = 1:N
    for j = 1:3
        if Vecinos(i,j)>0
        k = Vecinos(i,j);   
        % Normal exterior para la cara j de la celda i
        n = [Normalesx(i,j),Normalesy(i,j)]; %Normal a la cara j de la celda i       
        ri = [Rc(i,1) Rc(i,2)];
        rj = [Rc(k,1) Rc(k,2)];
        vect = ri - rj;
        dist = norm(vect);   
        dn = producto_escalar(vect,n);
        cond = -Areas(i,j)*dn/(Vol(i)*dist^2);
        
        K(i,k) = cond;
        K(i,i) = K(i,i) - cond;
        
        end
    end
end


K = K*kk;
K = sparse(K);

% En el caso de temperatura constante.

K_BC = zeros(N,N);
for i = 1:N
    for j = 1:3
  
        k = Vecinos(i,j);
        if k == -1 % Izquierda
        % Normal exterior para la cara j de la celda i   
        n = [Normalesx(i,j),Normalesy(i,j)]; %Normal a la cara j de la celda i 
        ri = [Rc(i,1) Rc(i,2)];
        rj = [min(Rn(:,1)) Rc(i,2)];
        vect = ri - rj;
        dist = norm(vect);
        dn = producto_escalar(vect,n);
        cond1 = -Areas(i,j)*dn/(Vol(i)*dist^2); 
        K_BC(i,i) = K_BC(i,i) - cond1;
        
        elseif  k == -2 % Derecha
        % Normal exterior para la cara j de la celda i
        n = [Normalesx(i,j),Normalesy(i,j)]; %Normal a la cara j de la celda i 
        
        ri = [Rc(i,1) Rc(i,2)];
        rj = [max(Rn(:,1)) Rc(i,2)];
        vect = ri - rj;
        dist = norm(vect);
        dn = producto_escalar(vect,n);
        cond2 = -Areas(i,j)*dn/(Vol(i)*dist^2);
        K_BC(i,i) = K_BC(i,i) - cond2;
            
        end
    end
end

K_BC = K_BC*kk;
K_BC = sparse(K_BC);
end
