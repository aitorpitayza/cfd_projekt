function [grid_data] = grid_loader(filenames)
    % load_grid : Creates a variable with all the grid data based on the 
    % inserted files.
    %  
    % --- Inputs ---
    %    filenames : 2x1 text array with the names of the files.
    %                filenames = [ "node_file.dat" "cell_file.dat"]
    %
    % --- Outputs ---
    %     grid_data : struct variable which contains the grid data.
    %                 grid_data.nodes =    x   y
    %                           node 1  [ ... ... ]
    %                                       ...
    %
    %                 grid_data.cells =  node1  node2   node3 
    %                          cell 1  [ nodeid nodeid nodeid ]
    %                                             ...
    %        
    %                 grid_data.connectivity = ¿?
    %                 grid_data.outer_normal_face_vectors = ¿?
    %                 grid_data.centroid = ¿?

    % Node file loading

    node_data = readtable(filenames(1),'VariableNamingRule','preserve');
    grid_data.nodes(:,:) = table2array(node_data);
    
    % Cell file loading

    cell_data = readtable(filenames(2),'VariableNamingRule','preserve');
    grid_data.cells(:,:) = table2array(cell_data);

    end