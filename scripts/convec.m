function [ C , C_BC_arriba] = convec( Vol, Areas,...
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    Normales, N, Vecinos,  BCtop, v, cv, rho)
=======
    Normalesx,Normalesy, N, Vecinos,  BCtop, v, cv, rho)
>>>>>>> Stashed changes

% Esta función entrega la matriz de convección del dominio, así como la 
% parte convectiva relativa a las condiciones de contorno.
=======
   
    Normalesx,Normalesy, N, Vecinos,  BCtop, v, cv, rho)


% Esta función entrega la matriz de convección del dominio, así como la 
% parte convectiva relativa a las condiciones de contorno, utilizada
%para estimar la derivada temporal de T mediante volúmenes finitos.
>>>>>>> Stashed changes

%   Entradas
%   ........
%
%   - N: número de celdas.
%   - Vol: vector que contiene las áreas de las celdas de la malla 
%   - Area: matriz que contiene la longitud de cada lado de las celdas.
%   - Normales: matriz que contiene los vectores normales de cada lado de
%               las celdas y la celda vecina a cada vector normal. 
<<<<<<< Updated upstream
%   - Rn: matriz que contiene las coordenadas de los nodos de la malla.
%   - Vecinos: matriz que contiene las celdas vecinas de cada elemento de 
%              la malla.
%   - t: instante temporal.
=======
%   
%   - Vecinos: matriz que contiene las celdas vecinas de cada elemento de 
%              la malla.
%   
>>>>>>> Stashed changes
%   - rho: densidad del fluido [kg/m^3].
%   - cv: calor específico a volumen constante [J/kgK].
%   - v: matriz de dimensión N filas y dos columnas que contiene las 
%        componentes de la velocidad en m/s en los centroides de cada celda 
%        de la malla.
<<<<<<< Updated upstream
%
=======
 %  -BCtop:vector que contiene las celdas situadas en el límite
%            superior del dominio.
>>>>>>> Stashed changes
%
%   Salida
%   ......
%
%   - C: matriz de convección del problema.
%   - C_BC_arriba: matriz que contiene la parte convectiva asociada a las
%           condiciones de contorno en el límite superior.

<<<<<<< Updated upstream
 Vecinos=;
<<<<<<< Updated upstream
 Normales=; 
=======
  
>>>>>>> Stashed changes
 %%Preguntar como está montado la matriz conectividad para ajustar a
 %%vecinos
=======


 
>>>>>>> Stashed changes
 C = zeros(N, N);
 for i = 1:N
     for j = 1:3
         
         if Vecinos(i,j)>0
             k = Vecinos(i,j); %índice de la celda vecina a la celda i en la cara j
     
<<<<<<< Updated upstream
<<<<<<< Updated upstream
             n = Normales(i,j); %Normal a la cara j de la celda i
=======
             n = [Normalesx(i,j),Normalesy(i,j)]; %Normal a la cara j de la celda i
>>>>>>> Stashed changes
=======

             n = Normales(i,j); %Normal a la cara j de la celda i

             n = [Normalesx(i,j),Normalesy(i,j)]; %Normal a la cara j de la celda i

>>>>>>> Stashed changes
             vn = dot(v(i,:),n);
             
             if vn < 0 %celda vecina aguas arriba
             A = Areas(i,j);    
             conv =  -A*vn*rho*cv ;

 
                     C(i,k) = conv / Vol(i) ; %Flujo de energía entrando en la celda i
                     C(k,k) = C(k,k) - conv / Vol(k); %Flujo saliendo de la celda k
                     
            end
         end
     end
 end
<<<<<<< Updated upstream
% C = sparse(C);
% 
% % Concicion de contorno de flujo saliente (arriba)
% C_BC_arriba = zeros( N, N );
% 
% for i = 1:length( BCtop )
%     k = BCtop( i );
%     
%     for j = 1:3
%         if Normales(k,3*j-2)==0
%             
%             C_BC_arriba( k,k ) = - Longitud( k, 2*j-1 ) * v(k,2)/ Area(k);
%             
%         end
%     end
% end
% 
% C_BC_arriba = sparse(C_BC_arriba);
% C_BC_arriba = sparse(C_BC_arriba);
% 
% end
=======
C = sparse(C);

% Concicion de contorno de flujo saliente (arriba)
C_BC_arriba = zeros( N, N );

for i = 1:length( BCtop )
    k = BCtop( i );
    
    for j = 1:3
        if Normales(k,3*j-2)==0
            
            C_BC_arriba( k,k ) = - Areas( k, 2*j-1 ) * v(k,2)/ Vol(k);
            
        end
    end
end

C_BC_arriba = sparse(C_BC_arriba);


end
>>>>>>> Stashed changes
