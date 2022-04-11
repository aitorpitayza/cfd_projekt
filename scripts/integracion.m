<<<<<<< Updated upstream
<<<<<<< Updated upstream
%[ C , C_BC_arriba] = convec( grid_preproc.volumes, grid_preproc.areas,Normales, N, Vecinos(adaptar),  BCtop?, v, cv, rho)
=======
%[ C , C_BC_arriba] = convec( grid_preproc.volumes, grid_preproc.areas,grid_preproc.nx,grid_preproc.ny, N, Vecinos(adaptar),  BCtop?, v, cv, rho)
>>>>>>> Stashed changes
%He añadido la llamada a convec que se hará desde este script de
%integración temporal, cuando esté adaptado se descomentará.
=======

%   - BC_arriba: vector que contiene las celdas situadas en el límite
%            superior del dominio.

[ C , C_BC_arriba] = convec( grid_preproc.volumes, grid_preproc.areas,grid_preproc.nx,grid_preproc.ny, N, grid_preproc.connectivity,  BC_arriba, v, cv, rho)

%He añadido la llamada a convec que se hará desde este script de
%integración temporal.
>>>>>>> Stashed changes
