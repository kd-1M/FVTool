function MS = createMeshTilted2D(Nx, Ny, p1, p2, p3, p4)
% MeshStructure = createMeshTilted2D(Nx, Ny, p1, p2, p3, p4)
% builds a uniform 2D tilted mesh:
% Nx is the number of cells in x (horizontal) direction
% Ny is the number of cells in y (vertical) direction
% p  is the coordinate of the domain corners
%    p2 -----------p3
%     |            |
%     |            |
%    p1 -----------p4
%
% SYNOPSIS:
%   MeshStructure = buildMesh2D(Nx, Ny, Lx, Ly)
%
% PARAMETERS:
%   Nx: number of cells in the x direction
%   Lx: domain length in x direction
%   Ny: number of cells in the y direction
%   Ly: domain length in y direction
%
% RETURNS:
%   MeshStructure.
%                 dimensions=2 (2D problem)
%                 numbering: shows the indexes of cellsn from left to right
%                 and top to bottom
%                 cellsize: x and y elements of the cell size =[Lx/Nx,
%                 Ly/Ny]
%                 cellcenters.x: location of each cell in the x direction
%                 cellcenters.y: location of each cell in the y direction
%                 facecenters.x: location of interface between cells in the
%                 x direction
%                 facecenters.y: location of interface between cells in the
%                 y direction
%                 numberofcells: [Nx, Ny]
%
%
% EXAMPLE:
%   Nx = 5;
%   Ny = 7;
%   Lx = 10;
%   Ly = 20;
%   m = buildMesh2D(Nx, Ny, Lx, Ly);
%   [X, Y] = ndgrid(m.cellcenters.x, m.cellcenters.y);
%   [Xf,Yf]=ndgrid(m.facecenters.x, m.facecenters.y);
%   plot(X, Y, 'or', ...
%        Xf, Yf, '-b', Xf', Yf', '-b');
%
% SEE ALSO:
%     buildMesh1D, buildMesh3D, buildMeshCylindrical1D, ...
%     buildMeshCylindrical2D, createCellVariable, createFaceVariable

% Copyright (c) 2012-2019 Ali Akbar Eftekhari
% See the license file

x_vertices_left = linspace(p1(1), p2(1), Ny+1);
x_vertices_right = linspace(p4(1), p3(1), Ny+1);
x_vertices_top = linspace(p2(1), p3(1), Nx+1);
x_vertices_bottom = linspace(p1(1), p4(1), Nx+1);

y_vertices_left = linspace(p1(2), p2(2), Ny+1);
y_vertices_right = linspace(p4(1), p3(2), Ny+1);
y_vertices_top = linspace(p2(2), p3(2), Nx+1);
y_vertices_bottom = linspace(p1(2), p4(2), Nx+1);


if nargin==4
  % uniform 1D mesh
  Nx=varargin{1};
  Ny=varargin{2};
  Width=varargin{3};
  Height=varargin{4};
  % cell size is dx
  dx = Width/Nx;
  dy = Height/Ny;
  G=reshape(1:(Nx+2)*(Ny+2), Nx+2, Ny+2);
  CellSize.x= dx*ones(Nx+2,1);
  CellSize.y= dy*ones(Ny+2,1);
  CellSize.z= [0.0];
  CellLocation.x= [1:Nx]'*dx-dx/2;
  CellLocation.y= [1:Ny]'*dy-dy/2;
  CellLocation.z= [0.0];
  FaceLocation.x= [0:Nx]'*dx;
  FaceLocation.y= [0:Ny]'*dy;
  FaceLocation.z= [0.0];
elseif nargin==2
  % nonuniform 1D mesh
  facelocationX=varargin{1};
  facelocationY=varargin{2};
  facelocationX=facelocationX(:);
  facelocationY=facelocationY(:);
  Nx = length(facelocationX)-1;
  Ny = length(facelocationY)-1;
  G=reshape(1:(Nx+2)*(Ny+2), Nx+2, Ny+2);
  CellSize.x= [facelocationX(2)-facelocationX(1); ...
    facelocationX(2:end)-facelocationX(1:end-1); ...
    facelocationX(end)-facelocationX(end-1)];
  CellSize.y= [facelocationY(2)-facelocationY(1); ...
    facelocationY(2:end)-facelocationY(1:end-1); ...
    facelocationY(end)-facelocationY(end-1)];
  CellSize.z= [0.0];
  CellLocation.x= 0.5*(facelocationX(2:end)+facelocationX(1:end-1));
  CellLocation.y= 0.5*(facelocationY(2:end)+facelocationY(1:end-1));
  CellLocation.z= [0.0];
  FaceLocation.x= facelocationX;
  FaceLocation.y= facelocationY;
  FaceLocation.z= [0.0];
end
c=G([1,end], [1,end]);
MS=MeshStructure(2, ...
  [Nx,Ny], ...
  CellSize, ...
  CellLocation, ...
  FaceLocation, ...
  c(:), ...
  [1]);
