function [ producto ] = producto_escalar( v1, v2 )

% Esta funcion realiza el producto escalar entre dos vectores.

%   Entradas
%   ........
%
%   - v1 y v2: vectores a multiplicar.
%
%   Salidas
%   ......
%
%   - producto: resultado del producto escalar.

producto = v1'*v2;
end