stl2mat('link_0_1');

close all
load link_0_1 %Name of your Solid Works piece
setappdata(0,'object_data',object);
p = patch('faces',object.F, 'vertices',object.V); %Create its surfaces
set(p,'FaceColor', [0.5430 0.2695 0.0742]); %Color of surfaces
set(p,'EdgeColor','none'); %Do not show Edge line of triangular surfaces
drawnow
set(gcf,'Renderer','zbuffer','doublebuffer','on')% Renders your figures
light('color',[.99,.99,.99],'position',[5,0,2],'Style','infinite') %Light Position
lighting flat % Type lightintining
daspect([1 1 1]); %Axis Ratio
%axis off; % Do not show axis
grid on;
hold all;
plot3(0,0,0,'b*') %Plot origin of global reference frame


