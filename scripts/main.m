clear all
close all
clc

filenames = ["../data/nodes_4.dat" ...
                "../data/cells_4.dat"];

grid_data = grid_loader(filenames);

grid = mesher(grid_data);

