function stl2mat(name)
% This program converts the 3D CAD data (as an ASCII STL) and converts it
% as a MAT file which can be employed in Matlab 
% 
% Example stl2mat('skid')

%Find Facets and Vertices
[F, V] =rndread(strcat(name, '.stl')); 

%Display
set(0,'Units','pixels'); dim = get(0,'ScreenSize');
fig_handle = figure('doublebuffer','on','Position',[0,35,dim(3),dim(4)-100],...
            'Name','CAD TO MATLAB','NumberTitle','off');

% Convert figure into Object        
object.V=V; object.F=F;
setappdata(0,'object_data',object);
object = getappdata(0,'object_data');

% Plot Figure
p = patch('faces', object.F, 'vertices', object.V);
set(p,'EdgeColor','none', 'FaceColor', [.95,.95,.95]);     
set(fig_handle,'Renderer','zbuffer','doublebuffer','on')
light('color',[.9,.9,.9],'position',[5,0,2],'Style','infinite')
lighting gouraud
daspect([1 1 1]); axis off   

% Reduce the number of Vertices
original_vertices=size(object.V) %#ok<NASGU,NOPRT>
% [b, m] = unique(object.V,'first','rows');
% m1=sort(m); b1=object.V(m1,:); m2=1:1:length(m);
% length(m1)
% 
% for i=1:length(m1)
%     p = findsubmat(object.V,b1(i,:));
%         for j=1:length(p)
%             [ind_i,ind_j]=find(p(j)==object.F);
%             object.F(ind_i,ind_j)=m2(i);
%         end;
% end;
% object.V=b1;

axis off; axis equal; view(3); zoom(2)
reduced_vertices=length(object.V) %#ok<NOPRT,NASGU>
save(name, 'object')
return
    
function [fout, vout, cout] = rndread(filename)
% Reads CAD STL ASCII files, which most CAD programs can export.
% Used to create Matlab patches of CAD 3D data.
% Returns a vertex list and face list, for Matlab patch command.

fid=fopen(filename, 'r'); %Open the file, assumes STL ASCII format.
if fid == -1 
    error('File could not be opened, check name or path.')
end

%Prellocation of vectors v and c
num_lines = 0;
while feof(fid) ==0;
    tline=fgetl(fid);
    fword = sscanf(tline, '%s ');
    if strncmpi(fword, 'v',1) == 1;
        num_lines = num_lines +1;
    end
end
fclose(fid);
% assign length as the number of lines to be read.
length = num_lines;
v = zeros(3,length); 
c = zeros(1,length);
fid=fopen(filename, 'r'); %Open the file, assumes STL ASCII format.

%Variable Initializion
vnum=0;       %Vertex number counter.
report_num=0; %Report the status as we go.
VColor = 0;

%
while feof(fid) == 0                    % test for end of file, if not then do stuff
    tline = fgetl(fid);                 % reads a line of data from file.
    fword = sscanf(tline, '%s ');       % make the line a character string
% Check for color
    if strncmpi(fword, 'c',1) == 1;    % Checking if a "C"olor line, as "C" is 1st char.
       VColor = sscanf(tline, '%*s %f %f %f'); % & if a C, get the RGB color data of the face.
    end                                % Keep this color, until the next color is used.
    if strncmpi(fword, 'v',1) == 1;    % Checking if a "V"ertex line, as "V" is 1st char.
       vnum = vnum + 1;                % If a V we count the # of V's
       report_num = report_num + 1;    % Report a counter, so long files show status
       if report_num > 249;
           disp(sprintf('Reading vertix num: %d of %d.', vnum, length));
           report_num = 0;
       end
       v(:,vnum) = sscanf(tline, '%*s %f %f %f'); % & if a V, get the XYZ data of it.
       c(:,vnum) = VColor;              % A color for each vertex, which will color the faces.
    end                                 % we "*s" skip the name "color" and get the data.                                          
end
%   Build face list; The vertices are in order, so just number them.
%
fnum = vnum/3;      %Number of faces, vnum is number of vertices.  STL is triangles.
flist = 1:vnum;     %Face list of vertices, all in order.
F = reshape(flist, 3,fnum); %Make a "3 by fnum" matrix of face list data.
%
%   Return the faces and vertexs.
%
fout = F';  %Orients the array for direct use in patch.
vout = v';  % "
cout = c';
%
fclose(fid);
