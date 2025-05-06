function [n_elem,n_elec]=create_mesh()

%% This matlab script plot the _res.dat results with the same unstructured grid as being used in the inversion
%% First part of the code creates the .geo file as input for gmsh and afterwards runs gmsh to create the .msh file
%% Second part of the code implements Judy Robinson's code to translate the .msh file to a .dat file as input for R2


[file folder]=uigetfile('','Select a .csv file with your topography') %x(position of the electrode) and y(topographic height of your electrode)'); 

cd(folder); %change the working directory to the folder with the topography file

%% create the grid, input is the mesh/grid size at the top, mes/gridsize at the bottom and the depth of the 'sensitive' zone (more detailed grid)

x = inputdlg({'Gridsize near the top of the sensitive zone/profile','Gridsize at the bottom of your sensitive zone','Depth of the sensitive zone'},'input', [1 100; 1 100; 1 100]); 

top=str2num(x{1,1});
bottom=str2num(x{2,1});
depth=str2num(x{3,1});

topo=load(strcat(folder,file));

%%%% create .geo file
top_s=num2str(top);

fid=fopen('topo.geo','a');
fprintf(fid,'%s\r\n',strcat('cl1=',top_s,';'));

n=0; %number of points
%% insert electrodes
for i=1:length(topo)
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(i),') = {',num2str(topo(i,1)),',',num2str(topo(i,2)),',0,cl1};'));
    n=n+1;
end

%%% outer points
Dx=abs(topo(1,1)-topo(2,1));

if topo(1,1)<topo(2,1) %% clockwise

    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(length(topo),1)+Dx),',',num2str(topo(length(topo),2)),',0,cl1};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(length(topo),1)+Dx),',',num2str(topo(length(topo),2)-depth),',0,',num2str(bottom),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(1,1)-Dx),',',num2str(topo(1,2)-depth),',0,',num2str(bottom),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(1,1)-Dx),',',num2str(topo(1,2),2),',0,cl1};'));
    n=n+1;

    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(length(topo),1)+200),',',num2str(topo(length(topo),2)),',0,',num2str(75),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(length(topo),1)+200),',',num2str(topo(length(topo),2)-200),',0,',num2str(75),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(1,1)-200),',',num2str(topo(1,2)-200),',0,',num2str(75),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(1,1)-200),',',num2str(topo(1,2)),',0,',num2str(75),'};'));
    n=n+1;
else %% counterclockwise
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(length(topo),1)-Dx),',',num2str(topo(length(topo),2)),',0,cl1};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(length(topo),1)-Dx),',',num2str(topo(length(topo),2)-depth),',0,',num2str(bottom),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(1,1)+Dx),',',num2str(topo(1,2)-depth),',0,',num2str(bottom),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(1,1)+Dx),',',num2str(topo(1,2),2),',0,cl1};'));
    n=n+1;

    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(length(topo),1)-200),',',num2str(topo(length(topo),2)),',0,',num2str(75),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(length(topo),1)-200),',',num2str(topo(length(topo),2)-200),',0,',num2str(75),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(1,1)+200),',',num2str(topo(1,2)-200),',0,',num2str(75),'};'));
    n=n+1;
    fprintf(fid,'%s\r\n',strcat('Point(',num2str(n+1),') = {',num2str(topo(1,1)+200),',',num2str(topo(1,2)),',0,',num2str(75),'};'));
    n=n+1;
end

m=0; %number of lines
% connecting the electrodes
for i=1:length(topo)
    fprintf(fid,'%s\r\n',strcat('Line(',num2str(i),') = {',num2str(i),',',num2str(i+1),'};'));
    m=m+1;
end

% connecting the outergridborders
fprintf(fid,'%s\r\n',strcat('Line(',num2str(m+1),') = {',num2str(length(topo)+1),',',num2str(length(topo)+2),'};'));
m=m+1;
fprintf(fid,'%s\r\n',strcat('Line(',num2str(m+1),') = {',num2str(length(topo)+2),',',num2str(length(topo)+3),'};'));
m=m+1;
fprintf(fid,'%s\r\n',strcat('Line(',num2str(m+1),') = {',num2str(length(topo)+3),',',num2str(length(topo)+4),'};'));
m=m+1;
fprintf(fid,'%s\r\n',strcat('Line(',num2str(m+1),') = {',num2str(length(topo)+4),',',num2str(1),'};'));
m=m+1;

fprintf(fid,'%s\r\n',strcat('Line(',num2str(m+1),') = {',num2str(length(topo)+1),',',num2str(length(topo)+5),'};'));
m=m+1;
fprintf(fid,'%s\r\n',strcat('Line(',num2str(m+1),') = {',num2str(length(topo)+5),',',num2str(length(topo)+6),'};'));
m=m+1;
fprintf(fid,'%s\r\n',strcat('Line(',num2str(m+1),') = {',num2str(length(topo)+6),',',num2str(length(topo)+7),'};'));
m=m+1;
fprintf(fid,'%s\r\n',strcat('Line(',num2str(m+1),') = {',num2str(length(topo)+7),',',num2str(length(topo)+8),'};'));
m=m+1;
fprintf(fid,'%s\r\n',strcat('Line(',num2str(m+1),') = {',num2str(length(topo)+8),',',num2str(length(topo)+4),'};'));
m=m+1;
%lines to surfaces
fprintf(fid,'%s',strcat('Line Loop(',num2str(m+1),') = {'));
for i=1:length(topo)+3
    fprintf(fid,'%s',strcat(num2str(i),','));
end
fprintf(fid,'%s\r\n',strcat(num2str(length(topo)+4),'};'));
m=m+1;
ll1=m;
fprintf(fid,'%s\r\n',strcat('Plane Surface(',num2str(m+1),') = {',num2str(ll1),'};'));
m=m+1;
fprintf(fid,'%s',strcat('Line Loop(',num2str(m+1),') = {'));
for i=length(topo)+5:length(topo)+9
    fprintf(fid,'%s',strcat(num2str(i),','));
end
fprintf(fid,'%s',strcat(num2str(-(length(topo)+3)),','));
fprintf(fid,'%s',strcat(num2str(-(length(topo)+2)),','));
fprintf(fid,'%s\r\n',strcat(num2str(-(length(topo)+1)),'};'));

m=m+1;
ll2=m;
fprintf(fid,'%s\r\n',strcat('Plane Surface(',num2str(m+1),') = {',num2str(ll2),'};'));
m=m+1;
%surfaces to physical surfaces, each surface gets an identifier based on the
%physical property of that surface (multiple surfaces with same physical
%properties can have the same identifier
fprintf(fid,'%s\r\n',strcat('Physical Surface(',num2str(m+1),') = {',num2str(ll1+1),'};'));
m=m+1;
fprintf(fid,'%s\r\n',strcat('Physical Surface(',num2str(m+1),') = {',num2str(ll2+1),'};'));


fclose(fid);
act=folder;
[gmshfile gmshfolder]=uigetfile('','Select the GMSH executable gmsh.exe');
cd(gmshfolder);
copyfile(gmshfile,act);
cd(act);
system('gmsh topo.geo -2 -o mesh.msh -format string msh')
%delete('gmsh.exe');  %file is 64 mb, don't need it after meshing

convert2d_msh_v2(act,'mesh.msh');

% delete('topo.geo');

n_elec=length(topo);

fid=fopen('mesh.dat');
s=textscan(fid,'%s','Delimiter','\n');
fclose(fid);
st=s{1,1}{1,1};
el=str2num(st);
n_elem=el(1);
delete('gmsh.exe');


%%%%%%% convert from mesh.msh to mesh.dat

function convert2d_msh_v2(pathname,fname)
        %read in .msh file and convert to mesh.dat format for R2
%file format of .msh file based on gmesh documentation ASCII format


fid = fopen([pathname fname],'r');  % Open text file

%%
%Read Mesh format lines $MeshFormat until $Nodes
% Read strings delimited by a carriage return
InputText=textscan(fid,'%s',4,'delimiter','\n'); 
Mesh_Format=InputText{1};

%read in number of nodes
InputText=textscan(fid,'%d',1,'delimiter','\n');
num_Nodes=InputText{1};

%node data
InputText=textscan(fid,'%f %f %f %f',num_Nodes,'delimiter','\n');
nodesid = InputText{1};
x_coord = InputText{2};
y_coord = InputText{3};
z_coord = InputText{4};
nodes=[nodesid x_coord y_coord z_coord];

%read in two lines $EndNodes and $Elements
%this is the format of .msh ascii 
InputText=textscan(fid,'%s',2,'delimiter','\n'); 
Format=InputText{1};

%read in number of elements
InputText=textscan(fid,'%d',1,'delimiter','\n');
num_Elements=InputText{1};

%element data - triangles only
InputText=textscan(fid,'%f %f %f %f %f %f %f %f',num_Elements,'delimiter','\n');
elm_num = InputText{1}; 
elm_type = InputText{2};
number_of_tags = InputText{3};
phys_entity = InputText{4};
elem_entity = InputText{5};
node1 = InputText{6};
node2 = InputText{7};
node3 = InputText{8};

triangles=[node1 node2 node3];
%%
%make sure in nodes in triangle are counterclockwise
%order - match node number with node to find coordinates
c_triangles=triangles;
num_counterclockwise=0;
clear x;
for cnt=1:length(triangles(:, 1))
    for num=1:3 %put all nodes/coordinates into matrix
        nodeid=triangles(cnt, num); 

        ind=nodes(nodeid, 1);
        x=nodes(ind, 2);
        y=nodes(ind,3);

        each_triangle(num, 1:3)=[nodeid x y];        
    end
    %see if triangle is counter-clockwise
    %if ccw <= 0 then signed area is neg and pts are clockwise
    if ccw(each_triangle) <= 0
        %exchange elements in rows 6 and 7 to change direction
        tmp=c_triangles(cnt, 1);
        c_triangles(cnt, 1)=c_triangles(cnt, 2);
        c_triangles(cnt, 2)=tmp;
    else
        num_counterclockwise=num_counterclockwise+1;
    end   
end
fclose(fid);
%%
%open mesh.dat for input
cd(pathname)

fid=fopen('mesh.dat', 'w');

%write to mesh.dat total num of elements and nodes
%fprintf(fid, '%i %i\n\n', length(c_triangles(:, 1)), length(nodes(:, 1)));
fprintf(fid, '%i %i\r\n', length(c_triangles(:, 1)), length(nodes(:, 1)));
%add zone
zone=ones(length(c_triangles(:, 1)), 1);

%add element number
elemnum=(1:1:length(c_triangles(:, 1)));

meshTriData=[elemnum' c_triangles elemnum' zone];

%write elements
fprintf(fid, '%i %i %i %i %i %i\r\n', meshTriData');

% write out node data
fprintf(fid, '\r\n\n');
nfile=[nodes(:,1) nodes(:, 2) nodes(:, 3)];
fprintf(fid, '%i %4.2f %4.2f\r\n', nfile');


fclose(fid);

function [ signed_area ] = ccw( tri_coords )

    x1=tri_coords(1,2);
    y1=tri_coords(1,3);

    x2=tri_coords(2,2);
    y2=tri_coords(2,3);

    x3=tri_coords(3,2);
    y3=tri_coords(3,3);

    a=((x2-x1)*(y3-y1))-((y2-y1)*(x3-x1));

    signed_area=((x2-x1)*(y3-y1))-((y2-y1)*(x3-x1));

end

end

end




