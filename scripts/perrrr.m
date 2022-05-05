
%% Plotter


%Comparación Euler/Crank
time = [];
datos_integracion.Courant = 0.1;



linS = {'-','--'};
mark = {'o','x','^'};
col = {'r', 'g', 'c'}


figure()


for w = 1:2
   disc = w;
   
   for q = 1:3
      
      datos_integracion.Tipo_integrador = q;
                
      for p = 1:3
                
         n_cel = [16, 64, 256];
         celdas = n_cel(p)
                
                   
         mainperrr
         mean_temp = mean(Matriz_Temp,1);
         v_dt(p) = dt_sol;
         time = [0:dt_sol:0.3+dt_sol];
         plot(time, mean_temp,'linestyle',linS{w},'marker',mark{q}...
         ,'MarkerIndices',1:100:length(time),'color',col{p},'LineWidth',1.5);
         % plot(time, mean_temp,'linestyle',linS{w},'color',col{p},'LineWidth',1.5);
         hold on

      end
              
   end

end
  
legend({'N=16, EI, UpW', 'N=64, EI, UpW', 'N=256, EI, UpW',...
        'N=16, CN, UpW', 'N=64, CN, UpW', 'N=256, CN, UpW',...
        'N=16, RK4, UpW', 'N=64, RK4, UpW', 'N=256, RK4, UpW',...
        'N=16, EI, CDS', 'N=64, EI, CDS', 'N=256, EI, CDS',...
        'N=16, CN, CDS', 'N=64, CN, CDS', 'N=256, CN, CDS',...
        'N=16, RK4, CDS', 'N=64, RK4, CDS', 'N=256, RK4, CDS'});
xlabel('Tiempo [s]')
ylabel('T_{media} [K]')
xlim([0 0.3])
ylim([300 510])