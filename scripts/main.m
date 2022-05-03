clear all
close all
clc

tic

%%% Parámetros del problema a rellenar por el usuario %%%
    
    celdas = 4096; %Número de celdas de la malla
    
    % Archivos de datos
        filenames = ["../data/nodes_"+num2str(celdas)+".dat" ...
        "../data/cells_"+num2str(celdas)+".dat"...
        "../data/bc_1_"+num2str(celdas)+".dat"...
        "../data/bc_2_"+num2str(celdas)+".dat"...
        "../data/bc_3_"+num2str(celdas)+".dat"...
        "../data/bc_4_"+num2str(celdas)+".dat"];

        [grid_data, bc_nodes] = grid_loader(filenames);

    % Inicialización de la malla y cálculos previos 

        grid = mesher(grid_data);

    % Propiedades del fluido 
        
        datos.cp = 1004.5; %[J/(kg*K)] Calor especifico a presión constante
        datos.cv = 717.5; %[J/(kg*K)] Calor especifico a volumen constante
        datos.rho = 1.225; % [kg/m3] Densidad
        datos.kk = 0.025e-10; %[W/mK] Conductividad termica
        
        
    % Campos de velocidad y temperatura iniciales
        
        % Campo de velocidad inicial
        campo_velocidad = @(x,y,t) [0; 0.1]; %[0;(0.005+(0.05-x)*2)*0.02];
        
        % Distribución de temperatura inicial
        T_ci = @(x,y) 400; %(y)*4000;

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
            cc_inlet = @(x,t) 200;   %(3+0.02*t)*100 ; 
        
        % - Con respecto a la conducción, se establece esta condición de
            % contorno únicamente en las paredes laterales X=0, X=L. Se
            % desprecia por tanto la posibilidad de crear esta condición de
            % contorno en las paredes permeables ya que la contribución física
            % de estas sería mínima.

            % Condiciones de contorno de conduccion (Dirichlet) X=0, X=L
            cc_left = @(y,t) 400;    %(30*(0.1-y))*150 ; 
            cc_right = @(y,t) 400;   %(30*y)*150 ; 
            
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

       %% Datos integrador
       datos_integracion.Courant = 5; %Valor del número de Courant
       datos_integracion.dt1 = 0.01; %Paso temporal (s)
       datos_integracion.t_max = 1; %Tiempo máximo de resolución (s)
       datos_integracion.Tipo_integrador = 1; % Tipo de integrador
                                              % 1 = Euler implicito
                                              % 2 = Crank Nicolson


%%% Simulador

    [ Matriz_Temp, dt_sol] = integrador_temporal(grid, datos_integracion, ...
    datos, campo_velocidad, T_ci, cc_left,cc_right, cc_inlet, Tipo_CC);

%%% Representación gráfica

              
    % Dentro de esta funcion se puede seleccionar los instantes en los que se
    % desea que se realice el graficado. Estas puestos unos en concreto por
    % defecto, pero deben cambiarse en funcion de lo que desee observar.
        
        matriz_x = zeros(3,grid.N);
        matriz_y = zeros(3,grid.N);
                
        for i = 1:grid.N
        for j = 1:3
        matriz_x(j,i) = grid.nodes(grid.cells(i,j),1);
        matriz_y(j,i) = grid.nodes(grid.cells(i,j),2);
        end
        end 
        
        % grafica(Matriz_Temp,matriz_x,matriz_y,dt_sol)

        


toc
