function [BCtop] = bc_top(nodes, cells)

    % Esta funcion encuentra y almacena las celdas (su id) que se encuentran en
    % la parte superior del dominio. Para ello, primero busca los nodos que 
    % estan más arriba (en este caso todos estan a la misma altura) y, una vez 
    % encontrados y almacenados, busca las celdas las que los poseen para 
    % almacenarlas en BCtop (sus ids).
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
    %       BCtop : vector que almacena los ids de las celdas que están en el   
    %               contorno superior del domino ('y' máxima).
    %               BCtop = [cellk_id, cellk+1_id, ...]

    y_max = 0;
    higher_nodes = [];

    for ii=1:length(nodes(:,1))

        y = nodes(ii,2);

        if y > y_max 

            y_max = y;

        end

    end

    for ii=1:length(nodes(:,1))

        y = nodes(ii,2);

        if y >= y_max 

            higher_nodes = [higher_nodes, ii];

        end


    end

    BCtop = higher_nodes;
    

end