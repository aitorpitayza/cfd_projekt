function [condicion] = max_iter(n, N_max)

    % Función para detectar si se han superado las iteraciones máximas.
    % Inputs : 
    %   n, número de iteraciones actuales. 
    %   N_max, número de iteraciones máximas.
    %
    % Output : 
    %   condicion : variable booleana, true -> parar y false -> continuar.
    %

    if n >= N_max

        condicion = false;

    else

        condicion = true;

    end

end