function [ Matriz_Temp, vec_t_sol,dT] = integrador_temporal(campo_velocidad, T_ci,...
    Vecinos, t_max, T_conv_cc, BC_abajo, BC_arriba,N, Vol, Areas,...
     Normalesx,Normalesy, Rc,T_cc_D_cond_left, T_cc_D_cond_right, Rn, kk, rho,cv,...
    Tipo,Grad_cc_N_left, Grad_cc_N_right , integrador,Courant,dT1)

% Esta funcion permite obtener los valores de temperatura en cada instante
% mediante una discretizacion y los almacena en la matriz de temperaturas Matriz_Temp.

%   Entradas:
%   ........
%
%   - velocidad: distribución de velocidades dependiente del espacio.
%   - T_ci: distribución de temperaturas dependiente del espacio.
%   - Vecinos: matriz que contiene las celdas vecinas de cada elemento de 
%              la malla.
%   - t_max: tiempo máximo de la simulación.
%   - T_conv_cc: distribución de temperaturas en el contorno inferior.
%   - BC_abajo: vector que contiene las celdas situadas en el límite
%               inferior del dominio.
%   - BC_arriba: vector que contiene las celdas situadas en el límite
%            superior del dominio.
%   - N: número de celdas.
%   - Vol: vector que contiene las áreas de las celdas de la malla
%   - Area: matriz que contiene la longitud de cada lado de las celdas.
%   - Normalesx:matriz que contiene la componente x de los vectores normales de cada lado de
%       las celdas. Normalesx(i,j): componente x del vec. normal a
%   la cara j de la celda i.
%   - Normalesy: matriz que contiene la componente y de los vectores normales de cada lado de
%   las celdas. %
%   - Rc: matriz que contiene las coordenadas del centroide de cada celda.
%   - T_cc_D_cond_left: distribución de temperaturas en el límite izquierdo
%                       del dominio.
%   - T_cc_D_cond_right: distribución de temperaturas en el límite derecho
%                       del dominio.
%   - Rn: matriz que contiene las coordenadas de los nodos de la malla.
%   - kk: conductividad térmica [W/mK].
%   - rho: densidad del fluido [kg/m^3].
%   - cv: calor específico a volumen constante [J/kgK].
%   - Tipo: variable encargada de la selección de las condiciones de 
%           contorno.
%   - Grad_cc_N_left: distribución del gradiente de temperaturas en el 
%                     límite izquierdo del dominio.
%   - Grad_cc_N_right: distribución del gradiente en el límite derecho
%                       del dominio.
%   - integrador: variable encargada de la selección del método de 
%                 integración.  
%   - Courant: número de Courant.
%   - vsonido: velocidad del sonido.
%
%
%   Salida
%   ......
%
%   - Matriz_Temp: matriz de temperaturas para cada instante temporal.
%   - vec_t_sol: vector que almacena la secuencia de los instantes temporales.
%   - dT: paso temporal.


% A continuacion, en el siguiente bucle se realiza la integracion temporal
% para cada instante temporal y se va calculando el vector VectB de
% terminos independientes en cada uno de los instantes temporales.
[v] = Matriz_Veloc( Rc , N, campo_velocidad);

% Se calcula el dT mediante una aproximación debido a que es un caso bidimensional

dT = Courant*min(min(sqrt(Vol*2)))/(min(norm(v(1,:))));

if dT>dT1
    dT=dT1;
else
    dT=dT;
end

n_pasos = ceil(t_max/dT)+1; 
% Ceil redondea al entero. Se suma uno al número de pasos calculado como
% tiempo total/tamaño del paso porque para el último paso se necesita el 
% paso siguiente.

[T_ini] = cond_inicial(Rc,N,T_ci);

Matriz_Temp = T_ini';
t_sol = 0;
Num_contador=ceil(t_max/dT);
Contador=zeros(1,Num_contador);

for i=1:Num_contador
    
    tiempo=(i-1)*dT;
    tiempo_siguiente=i*dT;
    Tempi=Matriz_Temp(:,i);
    
    %% Matriz de difusion
    
    if i==1
        
     [ C , C_BC_arriba] = convec( Vol, Areas,... 
    Normalesx,Normalesy, N, Vecinos,  BCtop, v, cv, rho);

     [ C_bc ] = cdc_dirichlet_convec( T_conv_cc,...
    BCbottom, N, Vol, Areas, v, Normalesx,Normalesy, Rc, tiempo );


   
     [ K, K_BC ] = conduc( Vol, Areas, Rc, Rn, Normalesx,Normalesy,...
    N, Vecinos, kk );

       if Tipo == 1
     [ K_bc ] = cdc_dirichlet_conduc(T_cc_D_cond_left,...
    T_cc_D_cond_right, N, Normalesx, Normalesy, Rc, Areas, Vol, Rn, kk, tiempo);
   
    
        else
    
    [ K_bc ] = cdc_neumann_conduc( Grad_cc_N_izq, ...
    Grad_cc_N_dcha, N, Normalesx, Normalesy, Vol, Areas, Rc, kk, tiempo );
  
    
        end

    else
        
     % Matrices de convección del instante temporal actual.   
     
     C = C_siguiente;
     C_BC_arriba = C_BC_arriba_siguiente;
     C_bc = C_bc_siguiente;
     
     % Matrices de conducción del instante temporal actual.
     
     K = K_siguiente;
     K_BC = K_BC_siguiente;
     K_bc = K_bc_siguiente;

    end
     
    % Matrices de convección del siguiente instante temporal.
      
[C_siguiente,C_BC_arriba_siguiente] = convec( Vol, Areas,... 
    Normalesx,Normalesy, N, Vecinos,  BCtop, v, cv, rho);

[C_bc_siguiente] = cdc_dirichlet_convec( T_conv_cc,...
    BCbottom, N, Vol, Areas, v, Normalesx,Normalesy, Rc, tiempo_siguiente );
    
     
     % Matrices de conducción del siguiente instante temporal.
     
 [K_siguiente,K_BC_siguiente] = conduc( Vol, Areas, Rc, Rn, Normalesx,Normalesy,...
    N, Vecinos, kk );
    if Tipo == 1
    
    [K_bc_siguiente] = cdc_dirichlet_conduc(T_cc_D_cond_left,...
    T_cc_D_cond_right, N, Normalesx, Normalesy, Rc, Areas, Vol, Rn, kk, tiempo_siguiente);
    
    
    else
    
    [K_bc_siguiente] = cdc_neumann_conduc( Grad_cc_N_izq, ...
    Grad_cc_N_dcha, N, Normalesx, Normalesy, Vol, Areas, Rc, kk, tiempo_siguiente );
  
    
    end   
      

%% Matriz total
%Matriz del sistema en el instante temporal actual. 
Matriz_Principal = sparse(C+C_BC_arriba+K+K_BC);
%Matriz del sistema en el siguiente instante temporal.
Matriz_Principal_n1 =sparse(C_siguiente+C_BC_arriba_siguiente+K_siguiente+K_BC_siguiente);
%Vector de términos independientes del sistema en el instante
%temporal actual.     
Vect_indep = C_bc + K_bc;
%Vector de términos independientes del sistema en el siguiente instante
%temporal.     
Vect_indep_n1= C_bc_siguiente+K_bc_siguiente;
 

if integrador == 1

    [Matriz_Temp(:,i+1)]= euler_implicito( Matriz_Principal_n1, Vect_indep, dT, Tempi,N);

    
elseif integrador == 2
   

    Matriz_Temp(:,i+1)= crank_nicolson( Matriz_Principal, Matriz_Principal_n1, Vect_indep,...
      Vect_indep_n1, dT, Tempi,N);
        
    
end

end