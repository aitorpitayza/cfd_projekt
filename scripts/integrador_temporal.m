function [ Matriz_Temp,dt] = integrador_temporal(grid, datos_integracion, ...
    datos, campo_velocidad, T_ci, cc_left,cc_right, cc_inlet, Tipo_CC)

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

%% Aquí se define la velocidad en los centroides v(x,y). Ya veremos como hacerla dependiente del tiempo v(x,y,t). 

Courant = datos_integracion.Courant;
dt1 = datos_integracion.dt1;
t_max = datos_integracion.t_max;
Tipo_integrador = datos_integracion.Tipo_integrador;

Rc = grid.centroid;
N = grid.N;
Vol = grid.volumes;

[v] = Matriz_Veloc(Rc , N, campo_velocidad); % Esto está anulado porque en
%la función temp necesita una función.

% Se calcula el dT mediante una aproximación debido a que es un caso bidimensional

dt = Courant*min(min(sqrt(Vol*2)))/(min(norm(v(1,:))));

if dt>dt1
    dt=dt1;
else
    dt=dt;
end

n_pasos = ceil(t_max/dt)+1; 
% Ceil redondea al entero. Se suma uno al número de pasos calculado como
% tiempo total/tamaño del paso porque para el último paso se necesita el 
% paso siguiente.

[T_ini] = Matriz_T_inicial(Rc,N,T_ci);

Matriz_Temp = T_ini';
t_sol = 0;
Num_contador=ceil(t_max/dt);
Contador=zeros(1,Num_contador);

for i=1:Num_contador
    
    tiempo=(i-1)*dt;
    tiempo_siguiente=i*dt;
    Tempi=Matriz_Temp(:,i);
    
    %% Matriz de difusion
    
    if i==1
    
    [A,b] = temp(tiempo, grid, campo_velocidad, datos, Tipo_CC, cc_inlet, cc_left, cc_right);
    
    else
     
     A = A_1;
     b = b_1;
     
    end
          
    [A_1, b_1]  = temp(tiempo_siguiente, grid, campo_velocidad, datos, Tipo_CC, cc_inlet, cc_left, cc_right);

if Tipo_integrador == 1
    %Dudas si aqui se le pasa b o b_1
    [Matriz_Temp(:,i+1)]= euler_implicito( A_1, b, dt, Tempi,N);

    
elseif Tipo_integrador == 2

      Matriz_Temp(:,i+1)= crank_nicolson( A, A_1, b,...
      b_1, dt, Tempi,N);
        
    
end

end