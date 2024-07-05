%% 0. INITIALIZATION
%clear variables and close figures
clc; clear all; close all;

UNIT_METER = 1/100;
%% 1. Set Your Desired Wrist Position Here :)
X = 200.76;
Y = 115.91;
Z = 50;

%% 2. LOAD MANIPULATOR PART FILES
%Load STL files of the chess pieces and the manipulator links
stl2mat('link_0_1');
stl2mat('link_1_2');
stl2mat('link_2_3');
stl2mat('link_3_4');
close all

set(gcf,'Renderer','zbuffer','doublebuffer','on')% Renders your figures
light('color',[.99,.99,.99],'position',[5,0,2],'Style','infinite') %Light Position
lighting flat % Type lightintining
daspect([1 1 1]); %Axis Ratio
%axis off; % Do not show axis
grid on;
hold all;

load link_0_1 %Name of your Solid Works piece
setappdata(0,'object_data',object);
p(1) = patch('faces',object.F, 'vertices',object.V); %Create its surfaces
set(p(1),'FaceColor', [0.3 0.3 0.3]); %Color of surfaces
set(p(1),'EdgeColor','none'); %Do not show Edge line of triangular surfaces
plot3(0,0,0,'b*') %Plot origin of global reference frame
V1 = object.V'; V{1} = V1;

load link_1_2
setappdata(0,'object_data',object);
p(2) = patch('faces',object.F, 'vertices',object.V); %Create its surfaces
set(p(2),'FaceColor', [0.7 0.3 0.3]); %Color of surfaces
set(p(2),'EdgeColor','none'); %Do not show Edge line of triangular surfaces
V2 = object.V'; V{2} = V2;

load link_2_3
setappdata(0,'object_data',object);
p(3) = patch('faces',object.F, 'vertices',object.V); %Create its surfaces
set(p(3),'FaceColor', [0.9 0.3 0.3]); %Color of surfaces
set(p(3),'EdgeColor','none'); %Do not show Edge line of triangular surfaces
V3 = object.V'; V{3} = V3;

load link_3_4
setappdata(0,'object_data',object);
p(4) = patch('faces',object.F, 'vertices',object.V); %Create its surfaces
set(p(4),'FaceColor', [0.99 0.6 0.65]); %Color of surfaces
set(p(4),'EdgeColor','none'); %Do not show Edge line of triangular surfaces
V4 = object.V'; V{4} = V4;

%% 3. INVERSE KINEMATIC
D1 = 250;
L1 = 120;
L2 = 120;

TH1 = 30; TH2 = 45; D3 = -100;

D3 = Z - D1;
c2 = (X^2 + Y^2 -L1^2 - L2^2)/(2*L1*L2);
s2 = sqrt(1-c2^2); % Here we pick positive one
TH2 = rad2deg(atan2(s2, c2));

k1 = L1 + L2*c2; k2 = L2*s2;
TH1 = rad2deg(atan2(Y,X)-atan2(k2, k1));

%% 4. FORWARD KINEMATIC

% Inputs
% TH1 = 60; TH2 = 120; D3 = -150;

alpha0 = 0; a0 = 0; theta1 = TH1; d1 = D1* UNIT_METER;
alpha1 = 0; a1 = L1 * UNIT_METER; theta2 = TH2; d2 = 0;
alpha2 = 0; a2 = L2* UNIT_METER; theta3 = 0; d3 = D3* UNIT_METER;

T01 = tmat(alpha0, a0, d1, theta1);
T12 = tmat(alpha1, a1, d2, theta2);
T23 = tmat(alpha2, a2, d3, theta3);

T02 = T01*T12;
T03 = T02*T23;

R01 = T01(1:3,1:3); R02 = T02(1:3,1:3); R03 = T03(1:3,1:3);
P01 = T01(1:3,4); P02 = T02(1:3,4); P03 = T03(1:3,4);
disp(P03);
newV{2} = R01*V{2};
newV{2} = newV{2} + repmat(P01,[1 length(newV{2}(1,:))]);
newV{3} = R02*V{3};
newV{3} = newV{3} + repmat(P02,[1 length(newV{3}(1,:))]);
newV{4} = R03*V{4};
newV{4} = newV{4} + repmat(P03,[1 length(newV{4}(1,:))]);

set(p(2),'Vertices',newV{2}(1:3,:)');
set(p(3),'Vertices',newV{3}(1:3,:)');
set(p(4),'Vertices',newV{4}(1:3,:)');


drawnow

