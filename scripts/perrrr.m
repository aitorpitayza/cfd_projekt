
%% Plotter


%Comparación Euler/Crank
time = [];
datos_integracion.Courant = 5;


for w = 1:2
    disc = w;
        for q = 1:2
           datos_integracion.Tipo_integrador = q;
                for p = 1:6
                
                   n_cel = [4, 16, 64, 256, 1024, 4096];
                   celdas = n_cel(p)
                
                   
                   mainperrr
                   time(p) = toc
                end
           figure(4)
           
           plot(n_cel, time)
%            set(gca,'XScale','log')
           set(gca,'YScale','log')
%            xticks([4, 16, 64, 256, 1024, 4096])
%            xticklabels({'4', '16', '64', '256', '1024', '4096'})

           xlabel('Elementos de malla')
           ylabel('Tiempo [s]')
           hold on
           legend('Euler implícito upwind', 'Crank Nicolson upwind', 'Euler implícito GDS', 'Crank Nicolson GDS')
           title('Tiempo de cálculo según esquema temporal y espacial')
           
        end
end
    
    
    