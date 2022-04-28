clear all
close all
clc

tic

%%% Parámetros del problema a rellenar por el usuario %%%

    % Propiedades del fluido 
        
        cp = 1004.5 %[J/(kg*K)] Calor especifico a presión constante
        cv = 717.5; %[J/(kg*K)] Calor especifico a volumen constante
        rho = 1.225; % [kg/m3] Densidad
        kk = 0.025; %[W/mK] Conductividad termica
        
    % Campos de velocidad y temperatura iniciales
        
        % Campo de velocidad inicial
        campo_velocidad = @(x,y) [0,(0.005+(0.05-x)*2)*0.02];
        
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
            T_conv_cc = @(x,t) 500     %(3+0.02*t)*100 ; 
        
        % - Con respecto a la conducción, se establece esta condición de
            % contorno únicamente en las paredes laterales X=0, X=L. Se
            % desprecia por tanto la posibilidad de crear esta condición de
            % contorno en las paredes permeables ya que la contribución física
            % de estas sería mínima.

        
        
            % Condiciones de contorno de conduccion (Dirichlet) X=0, X=L
            T_cc_D_cond_left = @(y,t) 600      %(30*(0.1-y))*150 ; 
            T_cc_D_cond_right = @(y,t) 800     %(30*y)*150 ; 
            
            % Condiciones de contorno de conduccion (Neumann) X=0, X=L
            Grad_cc_N_izq = @(y,t) %1000*(300*y+0.06*t) ;
            Grad_cc_N_dcha = @(y,t) %1000*(300*y+0.06*t) ;
        
        % A continuacion seleccionaremos el tipo de condicion de contorno en 
        % conduccion:
        
        % Tipo = 1 ; si Dirichlet
        % Tipo = 2 ; si Neumann
        
        Tipo = 2;



filenames = ["../data/nodes_4.dat" ...
                "../data/cells_4.dat"...
                "../data/bc_1_4.dat"...
                "../data/bc_2_4.dat"...
                "../data/bc_3_4.dat"...
                "../data/bc_4_4.dat"];

[grid_data, bc_nodes] = grid_loader(filenames);

grid = mesher(grid_data);


toc
