% function [ C , C_BC_arriba] = convec( V, Area,...
%     Normales, N, Vecinos,  BCtop, v, cv, rho)
% 
% % Esta función entrega la matriz de convección del dominio, así como la 
% % parte convectiva relativa a las condiciones de contorno.
% 
% %   Entradas
% %   ........
% %
% %   - N: número de celdas.
% %   - V: vector que contiene las áreas de las celdas de la malla 
% %   - Area: matriz que contiene la longitud de cada lado de las celdas.
% %   - Normales: matriz que contiene los vectores normales de cada lado de
% %               las celdas y la celda vecina a cada vector normal.
% %   - Rc: matriz que contiene las coordenadas del centroide de cada celda.
% %   - Rn: matriz que contiene las coordenadas de los nodos de la malla.
% %   - Vecinos: matriz que contiene las celdas vecinas de cada elemento de 
% %              la malla.
% %   - t: instante temporal.
% %   - kk: conductividad térmica [W/mK].
% %   - rho: densidad del fluido [kg/m^3].
% %   - cv: calor específico a volumen constante [J/kgK].
% %   - v: matriz de dimensión N filas y dos columnas que contiene las 
% %        componentes de la velocidad en m/s en los centroides de cada celda 
% %        de la malla.
% %
% %
% %   Salida
% %   ......
% %
% %   - C: matriz de convección del problema.
% %   - C_BC_arriba: matriz que contiene la parte convectiva asociada a las
% %           condiciones de contorno en el límite superior.
% 
 Vecinos=;
 Normales=; 
 Rc = grid_preproc.centroid; %%%Llamar a la input Rc, pero lanzar desde fuera con grid_preproc,etc, para que sirva la documentacion
 Areas = grid_preproc.areas; %%%ídem
 V =;%%%ídem
 %%Preguntar como está montado la matriz conectividad para ajustar a
 %%vecinos
 C = zeros(N, N);
 for i = 1:N
     for j = 1:3
         
         if Vecinos(i,j)>0
             k = Vecinos(i,j); %índice de la celda vecina a la celda i en la cara j
     
             n = Normales(i,j); %Normal a la cara j de la celda i
             vn = dot(v(i,:),n);
             
             if vn < 0 %celda vecina aguas arriba
             A = Areas(i,j);    
             conv =  -A*vn*rho*cv ;

 
                     C(i,k) = conv / V(i) ; %Flujo de energía entrando en la celda i
                     C(k,k) = C(k,k) - conv / V(k); %Flujo saliendo de la celda k
                     
            end
         end
     end
 end
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
