 function grafica( Temp, matriz_x, matriz_y, dT)
 
% Esta función se encarga de graficar las soluciones en diferentes
% tantes de tiempo.

%   Entradas
%   ........
%
%   - Temp: matriz de temperaturas para cada tante temporal.
%   - matriz_x: matriz que recoge las coordenadas x de cada nodo para cada
%               celda.
%   - matriz_y: matriz que recoge las coordenadas y de cada nodo para cada
%               celda.
%   - dT: paso temporal.


tamano = 12;

set(0,'DefaultAxesFontSize',tamano)
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(0,'defaultlinelinewidth',1.2)
set(0,'defaultTextInterpreter','latex');

% instantes para el graficado. Estan equiespaciados por defecto. Modificar
% a gusto de lo que se desee observar. Arriba esta preparado para
% modificacion manual.

[a,col]=size(Temp);

t1 = 1;
t2 = round(2*col/6);
t3 = round(3*col/6);
t4 = round(4*col/6);
t5 = round(5*col/6);
t6 = col;


Temp_1 = Temp(:,t1);
Temp_2 = Temp(:,t2);
Temp_3 = Temp(:,t3);
Temp_4 = Temp(:,t4);
Temp_5 = Temp(:,t5);
Temp_6 = Temp(:,t6);

T_max1 = max(Temp_1);
T_max2 = max(Temp_2);
T_max3 = max(Temp_3);
T_max4 = max(Temp_4);
T_max5 = max(Temp_5);
T_max6 = max(Temp_6);

T_min1 = min(Temp_1);
T_min2 = min(Temp_2);
T_min3 = min(Temp_3);
T_min4 = min(Temp_4);
T_min5 = min(Temp_5);
T_min6 = min(Temp_6);

T_maxvector = [T_max1,T_max2,T_max3,T_max4,T_max5,T_max6];
T_minvector = [T_min1,T_min2,T_min3,T_min4,T_min5,T_min6];
% T_maxvector = [T_max1,T_max2,T_max3,T_max6];
T_max = max(T_maxvector);
T_min = min(T_minvector);
colormap (flipud (hot))
figure (1)
subplot(1,6,1)
patch(matriz_x,matriz_y,Temp_1,'EdgeColor','none')
caxis manual
caxis([T_min T_max])
colorbar('TickLabelInterpreter','latex','FontSize',tamano)
title(['$t_1$ = ' num2str(fix(t1*dT)) ' s'],'Interpreter','Latex')

subplot(1,6,2)
patch(matriz_x,matriz_y,Temp_2,'EdgeColor','none')
caxis manual
caxis([T_min T_max])
colorbar('TickLabelInterpreter','latex','FontSize',tamano)
title(['$t_2$ = ' num2str(t2*dT) ' s'],'Interpreter','Latex')

subplot(1,6,3)
patch(matriz_x,matriz_y,Temp_3,'EdgeColor','none')
caxis manual
caxis([T_min T_max])
colorbar('TickLabelInterpreter','latex','FontSize',tamano)
title(['$t_3$ = ' num2str(t3*dT) ' s'],'Interpreter','Latex')

subplot(1,6,4)
patch(matriz_x,matriz_y,Temp_4,'EdgeColor','none')
caxis manual
caxis([T_min T_max])
colorbar('TickLabelInterpreter','latex','FontSize',tamano)
title(['$t_4$ = ' num2str(t4*dT) ' s'],'Interpreter','Latex')

subplot(1,6,5)
patch(matriz_x,matriz_y,Temp_5,'EdgeColor','none')
caxis manual
caxis([T_min T_max])
colorbar('TickLabelInterpreter','latex','FontSize',tamano)
title(['$t_5$ = ' num2str(t5*dT) ' s'],'Interpreter','Latex')

subplot(1,6,6)
patch(matriz_x,matriz_y,Temp_6,'EdgeColor','none')
caxis manual
caxis([T_min T_max])
colorbar('TickLabelInterpreter','latex','FontSize',tamano)
title(['$t_6$ = ' num2str(t6*dT) ' s'],'Interpreter','Latex')

figure (2)
colormap (flipud(hot))
patch(matriz_x,matriz_y,Temp_6,'EdgeColor','none')
caxis manual
caxis([T_min T_max])
colorbar('TickLabelInterpreter','latex','FontSize',tamano)
title(['$t_6$ = ' num2str(t6*dT) ' s'],'Interpreter','Latex')

 end
