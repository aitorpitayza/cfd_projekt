function [cells_bottom] = cells_bottom(nodes, cells)

    % Esta funcion encuentra y almacena las celdas (su id) que se encuentran en
    % la parte inferior del dominio. Para ello, primero busca los nodos que 
    % estan más abajo (en este caso todos estan a la misma altura) y, una vez 
    % encontrados y almacenados, busca las celdas las que los poseen para 
    % almacenarlas en cells_bottom (sus ids).
    % 
    % --- Inputs ---
    %
    %       nodes : matriz que almacena las coordenadas "x" e "y" de cada uno
    %               de los nodos en una fila. Ver función "grid_loader".
    %       cells : matriz que almacena los ids de los nodos de cada celda. Ver
    %               función "grid_loader".
    %
    % --- Outputs ---
    %
    %       cells_bottom : vector que almacena los ids de las celdas que están 
    %               en el contorno inferior del domino ('y' min).
    %               cells_bottom = [cellk_id, cellk+1_id, ...]

    y_min = 10000;
    lower_nodes = [];

    for ii=1:length(nodes(:,1))

        y = nodes(ii,2);

        if y < y_min 

            y_min = y;

        end

    end

    for ii=1:length(nodes(:,1))

        y = nodes(ii,2);

        if y <= y_min 

            lower_nodes = [lower_nodes, ii];

        end


    end

    lower_cells = [];

    for ii=1:length(lower_nodes)

        for jj=1:length(cells(1,:))

            for kk=1:length(cells(:,1))

                if lower_nodes(ii) == cells(kk,jj)

                    lower_cells = [lower_cells, kk];

                end

            end

        end

    end

    cells_bottom = unique(lower_cells);
    

end