function [ Matriz_Temp,dt] = integrador_temporal(grid, datos_integracion, ...
    datos, campo_velocidad, T_ci, cc_left,cc_right, cc_inlet, Tipo_CC)

% Esta funcion permite obtener los valores de temperatura en cada instante
% mediante una discretizacion y los almacena en la matriz de temperaturas Matriz_Temp.
%
%   Entradas:
%   ........
%
%   - grid : variable struct que almacena todos los datos de la malla
%   - datos_integracion : var. struct que almacena parámetros de integración
%   - datos : var. struct que almacena constantes físicas del problema
%   - campo_velocidad: función velocidad [vx;vy] = f(x,y,t)
%   - T_ci: vector de condiciones iniciales
%   - t_max: tiempo máximo de la simulación.
%   - cc_left : función que representa la cc en el límite izquierdo
%   - cc_right : función que representa la cc en el límite derecho
%   - cc_inlet : función que representa la cc en el límite inferior
%   - Tipo_CC : vector que almacena el tipo de cc en cada lateral. Ver main.
%
%   Salida
%   ......
%
%   - Matriz_Temp: matriz de temperaturas para cada instante temporal.
%   - vec_t_sol: vector que almacena la secuencia de los instantes temporales.
%   - dT: paso temporal final.


% Datos de integración

Courant = datos_integracion.Courant;
dt1 = datos_integracion.dt1;
t_max = datos_integracion.t_max;
Tipo_integrador = datos_integracion.Tipo_integrador;

% Datos de la malla

Rc = grid.centroid;
N = grid.N;
Vol = grid.volumes;

% Matriz velocidad en el instante inicial para el calculo del dt.

[v] = Matriz_Veloc(Rc , N, campo_velocidad); 

% Se calcula el dT mediante una aproximación debido a que es un caso bidimensional

dt = Courant*min(min(sqrt(Vol*2)))/(min(norm(v(1,:))));

if dt>dt1
    dt=dt1;
else
    dt=dt;
end

% Se calculan el num. de pasos temporales a dar.

n_pasos = ceil(t_max/dt)+1; 

% Se inicializa el vector de temperaturas iniciales.

[T_ini] = Matriz_T_inicial(Rc,N,T_ci);

Matriz_Temp = T_ini';
t_sol = 0;
Num_contador=ceil(t_max/dt);

for i=1:Num_contador
    
    tiempo=(i-1)*dt;
    tiempo_siguiente=i*dt;
    Tempi=Matriz_Temp(:,i);
    
    % Se calcula la jacobiana del campo de temperaturas. Como es lineal, se 
    % separa en una matriz A y un vector b tal que: dT/dt = A * T + b;
    
    if (i==1)

        % Instante inicial
    
        [A,b] = temp(tiempo, grid, campo_velocidad, datos, Tipo_CC, ...
                                                cc_inlet, cc_left, cc_right);
    
    else
        
        % Para ahorro de cálculo se almacenan la matriz y vector del instante
        % anterior como los del actual.
     
        A = A_1;
        b = b_1;
     
    end
          
    [A_1, b_1]  = temp(tiempo_siguiente, grid, campo_velocidad, datos, ...
                                        Tipo_CC, cc_inlet, cc_left, cc_right);

    % Se elige el propagador

    if (Tipo_integrador == 1)

        [Matriz_Temp(:,i+1)]= euler_implicito( A_1, b_1, dt, Tempi,N);

        
    elseif (Tipo_integrador == 2)

        Matriz_Temp(:,i+1)= crank_nicolson( A, A_1, b, b_1, dt, Tempi,N);
            
        
    end

end