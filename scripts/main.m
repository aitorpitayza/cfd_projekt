clear all
close all
clc

tic

%%% Parámetros del problema a rellenar por el usuario %%%

    % Archivos de datos

        filenames = ["../data/nodes_4.dat" ...
                        "../data/cells_4.dat"...
                        "../data/bc_1_4.dat"...
                        "../data/bc_2_4.dat"...
                        "../data/bc_3_4.dat"...
                        "../data/bc_4_4.dat"];

        [grid_data, bc_nodes] = grid_loader(filenames);

    % Inicialización de la malla y cálculos previos 

        grid = mesher(grid_data);

    % Propiedades del fluido 
        
        datos.cp = 1004.5; %[J/(kg*K)] Calor especifico a presión constante
        datos.cv = 717.5; %[J/(kg*K)] Calor especifico a volumen constante
        datos.rho = 1.225; % [kg/m3] Densidad
        datos.kk = 0.025; %[W/mK] Conductividad termica
        
        
    % Campos de velocidad y temperatura iniciales
        
        % Campo de velocidad inicial
        campo_velocidad = @(x,y,t) [0;(0.005+(0.05-x)*2)*0.02];
        
        % Distribución de temperatura inicial
        T_ci = @(x,y) (y)*4000;

    % Condiciones de contorno, dónde se toman las siguientes
    % suponsiciones a la hora de crearlas:

        % - Con respecto a la convección, se imponen únicamente esta...
            % condición en las paredes permeables, al despreciar la ...
            % contribución de esta con las paredes (condición wall).
            % Asumiendo que el flujo va en dirección Y, y que con el
            % alcance de este proyecto no se plantea imponer una condición
            % a la salida del flujo debido a la complejidad que esto
            % traería

            % Condicion de contorno de conveccion Y=0
            cc_inlet = @(x,t) 500;   %(3+0.02*t)*100 ; 
        
        % - Con respecto a la conducción, se establece esta condición de
            % contorno únicamente en las paredes laterales X=0, X=L. Se
            % desprecia por tanto la posibilidad de crear esta condición de
            % contorno en las paredes permeables ya que la contribución física
            % de estas sería mínima.

            % Condiciones de contorno de conduccion (Dirichlet) X=0, X=L
            cc_left = @(y,t) 600;    %(30*(0.1-y))*150 ; 
            cc_right = @(y,t) 800;   %(30*y)*150 ; 
            
            % Condiciones de contorno de conduccion (Neumann) X=0, X=L
            % cc_left = @(y,t) 1000*(300*y+0.06*t) ;
            % cc_right = @(y,t) 1000*(300*y+0.06*t) ;
        
        % A continuacion seleccionaremos el tipo de condicion de contorno en 
        % conduccion:
        
        % Tipo = 1 ; si Dirichlet
        % Tipo = 2 ; si Neumann
        
        % Primer elemento, tipo de condición en izqda y segundo elemento, tipo  
        % de condición a la derecha. Ser consecuente en las CC!!!!!
        Tipo_CC = [1, 1];

    % Stopping condition : Variable booleana (True (seguir) or false (parar)) 
        %   - Número de iteraciones máximas : n
        %   - Convergencia mínima entre pasos temporales : convergencia

        N_max = 100;

        stopping_condition = @(n, new_w, w) max_iter(n, N_max);

    % Intervalo de tiempo : Variable escalar dependiente del tiempo
        %   - Constante : dt
        %   - Variable : Más pequeño al principio para definir mejor los cambios
        %                bruscos y mas grande al final ya que el sistema se 
        %                estabiliza.

        dt_calculator = constant_dt(1e-3);

    % Propagador : Esquema de propagación temporal

        propagator = @euler_implicito;
        % propagator = @crank_nicolson;

    % Problem : Definición física del problema

        % problem=@(w,t) temp(w, t, grid, @campo_velocidad, datos, Tipo_CC, cc_inlet, cc_left, cc_right);

    % Inicialización : T_0

        T_0 = ones(grid.N, 1);

    temp(T_0, 0 , grid, campo_velocidad, datos, Tipo_CC, cc_inlet, cc_left, cc_right)



toc
