function [ C_bc ] = cdc_dirichlet_convec( T_conv_cc,...
    BCbottom, N, Vol, Areas, v, Normalesx,Normalesy, Rc, t )

% Esta función impone el valor de la temperatura en el contorno de la base
% de la malla (Método de Dirichlet).

%   Entradas
%   ........
%
%   - T_conv_cc: distribución de temperaturas en el contorno inferior.
%   - BCbottom: matriz que asocia las celdas que se encuentran en el límite
%               inferior de la malla.
%   - N: número de celdas.
%   - Vol: vector que contiene las áreas de las celdas de la malla.
%   - Areas: matriz que contiene la longitud de cada lado de las celdas.
%   - v: matriz de dimensión N filas y dos columnas que contiene las 
%        componentes de la velocidad en m/s en los centroides de cada celda 
%        de la malla.
%   - Normales: matriz que contiene los vectores normales de cada lado de
%               las celdas y la celda vecina a cada vector normal.
%   - Rc: matriz que contiene las coordenadas del centroide de cada celda.
%   - t: instante temporal.
%
%
%   Salida
%   ------
%
%   - C_bc: parte convectiva de los términos independientes asociada 
%                 al instante temporal.


C_bc = zeros( 1, N );

for i = 1:length( BCbottom )
    k = BCbottom( i ); %índices de las celdas en el límite inferior
    for j = 1:3 %Recorre los 3 lados
        if Normalesx(k,j)==0 %La normal a esa cara es vertical
           
            C_bc( k ) = 1 / Vol( k ) * Areas( k, j ) *...
                v(k,2) * T_conv_cc(Rc(k,1),t);
            
        end
    end
end
C_bc = sparse(C_bc);
end