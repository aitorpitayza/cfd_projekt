clear all
close all
clc

tic

filenames = ["../data/nodes_4.dat" ...
                "../data/cells_4.dat"];

grid_data = grid_loader(filenames);

grid = mesher(grid_data);

bc_top(grid.nodes, grid.cells)

toc
