function [grid_preproc] = mesher(grid_data)

%This script generates a mesh from data imported by grid_loader.m.

% INPUT: grid_data from grid_loader.m (cells and nodes).

%OUTPUT:

    % grid_preproc.nodes : nodes matrix. See grid_loader
    % grid_preproc.cells : cells matrix. See grid_loader
    % grid_preproc.N: cell quantity
    % grid_preproc.M: node quantity
    % grid_preproc.EX: X coord. of each node. (cell?)
    % grid_preproc.EY: Y coord. of each node. (cell?)
    % grid_preproc.centroid: centroid position (x, y) in every volume.
    % grid_preproc.meanpt: mean point (x,y) in every area of each cell.
    % grid_preproc.volumes: volume matrix of the domain, cell-volume. See
    % notes, 1.
    % grid_preproc.connectivity: connectivity matrix. See notes, 2.
    % grid_preproc.areas: area matrix of the domain, cell-area.
    % grid_preproc.nx, grid_preproc.ny: (x,y) component of the normal vect.

    %Notes: 
      
      % 1) Every (i,j) stands for (cell, area of each face).

      % 2) In that matrix, every row j corresponds to the 'cell j'. 
      % In ever row, each column shows which cell is in contact with that
      % 'cell j'. To assemble that matrix the script runs through every
      % cell node looking for neighbouring nodes in other cells. The
      % script always run through the cell nodes in order (from minor to
      % major values). E.g. If cell nodes are 56-4-2, the (j,1) element
      % is the neighbouring cell of the area 2-4, (j,2) corresponds to the
      % neighbouring cell of the area 4-56, and (j,3) to 56-2.
    
% Calculations:

% Data : 

grid_preproc.cells = grid_data.cells;
grid_preproc.nodes = grid_data.nodes;

grid_preproc.N = length(grid_data.cells); % Cell qty.
grid_preproc.M = length(grid_data.nodes); % Node qty.

% Cell coord. (EX,EY) from (nodes, cells) 
X = grid_data.nodes(:,1);
Y = grid_data.nodes(:,2);
elemX=zeros(1,4);
elemY=zeros(1,4);
grid_preproc.pmedio = struct();


for i=1:length(grid_data.cells(:,1))
    P1x=X(grid_data.cells(i,1));
    P1y=Y(grid_data.cells(i,1));
    P2x=X(grid_data.cells(i,2));
    P2y=Y(grid_data.cells(i,2));
    P3x=X(grid_data.cells(i,3));
    P3y=Y(grid_data.cells(i,3));
    
    elemX=[P1x P2x P3x P1x];
    elemY=[P1y P2y P3y P1y];
    

    % Mesh visualization
    % c = [1; 0.5; 0; 0.75]; %Colour of the fill, not relevant.
    % fill(elemX,elemY,c);
    % hold on;

    
    grid_preproc.EX(i,1:3)=elemX(1:3);
    grid_preproc.EY(i,1:3)=elemY(1:3);
    %Every row in E, contains X or Y coord of each element.
end



grid_preproc.centroid=zeros(grid_preproc.N,2); %Centroid matrix def.
grid_preproc.volumes=zeros(grid_preproc.N,1); %Volume matrix def.

grid_preproc.connectivity=zeros(grid_preproc.N,3); % Connectivity mat. def.
P1xe=grid_preproc.EX(:,1);
P1ye=grid_preproc.EY(:,1);
P2xe=grid_preproc.EX(:,2);
P2ye=grid_preproc.EY(:,2);
P3xe=grid_preproc.EX(:,3);
P3ye=grid_preproc.EY(:,3);


grid_preproc.areas=zeros(grid_preproc.N,3); %Areas matrix def.

grid_preproc.nx=zeros(grid_preproc.N,3); %Normal components matrix def.
grid_preproc.ny=zeros(grid_preproc.N,3); %Normal components matrix def.

for i=1:grid_preproc.N
    % Centroid position from node coordinates and node number.
    grid_preproc.centroid(i,1)=(grid_preproc.EX(i,1)+grid_preproc.EX(i,2)+grid_preproc.EX(i,3))/3;
    grid_preproc.centroid(i,2)=(grid_preproc.EY(i,1)+grid_preproc.EY(i,2)+grid_preproc.EY(i,3))/3;
    
    % Volume matrix from node coordinates and node number.
    v1=[grid_preproc.EX(i,1)-grid_preproc.EX(i,2) grid_preproc.EY(i,1)-grid_preproc.EY(i,2) 0];
    v2=[grid_preproc.EX(i,1)-grid_preproc.EX(i,3) grid_preproc.EY(i,1)-grid_preproc.EY(i,3) 0];
    grid_preproc.volumes(i)=0.5*norm(cross(v1,v2));
    
    %  Connectivity matrix from node coordinates and node number.
            % First face of the i element.
            P1xx=P1xe(i);
            P2xx=P2xe(i);
            P1yy=P1ye(i);
            P2yy=P2ye(i);

            [f1,~]=find(P1xx==grid_preproc.EX & P1yy==grid_preproc.EY);
            [f2,~]=find(P2xx==grid_preproc.EX & P2yy==grid_preproc.EY);

            for j=1:length(f1)
                for k=1:length(f2)
                    if f1(j)==f2(k) && f1(j)~=i
                        grid_preproc.connectivity(i,1)=f1(j);
                    end
                end
            end

            % Second face of the i element.
            P1xx=P2xe(i);
            P2xx=P3xe(i);
            P1yy=P2ye(i);
            P2yy=P3ye(i);

            [f1,~]=find(P1xx==grid_preproc.EX & P1yy==grid_preproc.EY);
            [f2,~]=find(P2xx==grid_preproc.EX & P2yy==grid_preproc.EY);

            for j=1:length(f1)
                for k=1:length(f2)
                    if f1(j)==f2(k)  && f1(j)~=i
                        grid_preproc.connectivity(i,2)=f1(j);
                    end
                end
            end

            % Third face of the i element.
            P1xx=P1xe(i);
            P2xx=P3xe(i);
            P1yy=P1ye(i);
            P2yy=P3ye(i);

            [f1,~]=find(P1xx==grid_preproc.EX & P1yy==grid_preproc.EY);
            [f2,~]=find(P2xx==grid_preproc.EX & P2yy==grid_preproc.EY);

            for j=1:length(f1)
                for k=1:length(f2)
                    if f1(j)==f2(k)  && f1(j)~=i
                        grid_preproc.connectivity(i,3)=f1(j);
                    end
                end
            end
    
    %  Volume matrix from node coordinates and node number.
    z1=[grid_preproc.EX(i,1)-grid_preproc.EX(i,2) grid_preproc.EY(i,1)-grid_preproc.EY(i,2) 0];
    z2=[grid_preproc.EX(i,2)-grid_preproc.EX(i,3) grid_preproc.EY(i,2)-grid_preproc.EY(i,3) 0];
    z3=[grid_preproc.EX(i,1)-grid_preproc.EX(i,3) grid_preproc.EY(i,1)-grid_preproc.EY(i,3) 0];
    grid_preproc.areas(i,1)=norm(z1);
    grid_preproc.areas(i,2)=norm(z2);
    grid_preproc.areas(i,3)=norm(z3);
    
    %  Normal vector components from node coordinates and node number.
    w1=[grid_preproc.EX(i,2)-grid_preproc.EX(i,1) grid_preproc.EY(i,2)-grid_preproc.EY(i,1)];
    n1=[w1(2) -w1(1)]/norm(w1);
    w2=[grid_preproc.EX(i,3)-grid_preproc.EX(i,2) grid_preproc.EY(i,3)-grid_preproc.EY(i,2)];
    n2=[w2(2) -w2(1)]/norm(w2);
    w3=[grid_preproc.EX(i,1)-grid_preproc.EX(i,3) grid_preproc.EY(i,1)-grid_preproc.EY(i,3)];
    n3=[w3(2) -w3(1)]/norm(w3);
    grid_preproc.nx(i,1)=n1(1);
    grid_preproc.nx(i,2)=n2(1);
    grid_preproc.nx(i,3)=n3(1);
    grid_preproc.ny(i,1)=n1(2);
    grid_preproc.ny(i,2)=n2(2);
    grid_preproc.ny(i,3)=n3(2);
end

    for i = 1:length(grid_data.cells)

        for j = 1:3

            x(j) = grid_data.nodes(grid_data.cells(i,j), 1);

            y(j) = grid_data.nodes(grid_data.cells(i,j), 2); 

        end

        % Mean points of each face. Medians are calculated. 2 medians are
        % enough to determine each centroid.

        %grid_preproc.cell1 stands for the (x,y) coord of each side's
        %meanpt in every cell.

        grid_preproc.meanpt.(['cell' num2str(i)]) = [(x(1)+x(2))/2 , (y(1)+y(2))/2; ...
            (x(2)+x(3))/2 , (y(2)+y(3))/2; ...
            (x(1)+x(3))/2 , (y(1)+y(3))/2;]; 
        

    end

end