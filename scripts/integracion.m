<<<<<<< Updated upstream
%[ C , C_BC_arriba] = convec( grid_preproc.volumes, grid_preproc.areas,Normales, N, Vecinos(adaptar),  BCtop?, v, cv, rho)
=======
%[ C , C_BC_arriba] = convec( grid_preproc.volumes, grid_preproc.areas,grid_preproc.nx,grid_preproc.ny, N, Vecinos(adaptar),  BCtop?, v, cv, rho)
>>>>>>> Stashed changes
%He añadido la llamada a convec que se hará desde este script de
%integración temporal, cuando esté adaptado se descomentará.