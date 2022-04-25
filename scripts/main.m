clear all
close all
clc

tic

filenames = ["../data/nodes_4.dat" ...
                "../data/cells_4.dat"...
                "../data/bc_1_4.dat"...
                "../data/bc_2_4.dat"...
                "../data/bc_3_4.dat"...
                "../data/bc_4_4.dat"];

[grid_data, bc_nodes] = grid_loader(filenames);

grid = mesher(grid_data);


toc
