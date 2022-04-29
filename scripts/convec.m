function [ C , C_BC] = convec( grid, v, t)


% Esta función entrega la matriz de convección del dominio, así como la 
% parte convectiva relativa a las condiciones de contorno, utilizada
%para estimar la derivada temporal de T mediante volúmenes finitos.


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
%   - v : función velocidad en el dominio. v = f(x,y,t).
%   - t : tiempo (s)
%
%   Salida
%   ......
%
%   - C: matriz de convección del problema.
%   - C_BC: matriz que contiene la parte convectiva asociada a las
%           condiciones de contorno.

N = grid.N;
Vol = grid.volumes;
Areas = grid.areas;
Normalesx = grid.nx;
Normalesy = grid.ny;
Rc = grid.centroid;
Rn = grid.nodes;
Vecinos = grid.connectivity;

C = zeros(N, N);
C_BC = zeros(N, N);

 for i = 1:N

    velocidad = v(Rc(i,1), Rc(i,2), t);

     for j = 1:3

        k = Vecinos(i,j);
         
        if (k > 0)
             
            %índice de la celda vecina a la celda i en la cara j
                
            n = [Normalesx(i,j);Normalesy(i,j)]; %Normal a la cara j de la celda i       

            vn =  velocidad * n;
            
            if vn < 0 %celda vecina aguas arriba

                A = Areas(i,j);    
                conv =  -A*vn ;

                C(i,k) = conv / Vol(i) ; %Flujo de energía entrando en la celda i
                C(k,k) = C(k,k) - conv / Vol(k); %Flujo saliendo de la celda k
                     
            end

        elseif (k == -4) % Top CC

            C_BC( i,i ) = - Areas( i, j ) * norm(v(Rc(i,1), Rc(i,2), t))/ Vol(i);

        end

    end

end

C = sparse(C);

C_BC = sparse(C_BC);

end

