%% 0. INITIALIZATION
%clear variables and close figures
clc; clear all; close all;

% Load STL files of the chess pieces and the manipulator links
% stl2mat('link_0_1');
% stl2mat('link_1_2');
% stl2mat('link_2_3');
% stl2mat('link_3_4');
% stl2mat('suitcase');
close all

% constants of DH-parameter
D1 = 250; L1 = 120; L2 = 120; D4 = 0;

UNIT_METER = 1/100;
FPS = 25;

set(gcf,'Renderer','zbuffer','doublebuffer','on')% Renders your figures
light('color',[.99,.99,.99],'position',[5,0,2],'Style','infinite') %Light Position
lighting flat % Type lightintining
daspect([1 1 1]); %Axis Ratio
%axis off; % Do not show axis
grid on;
hold on;

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

load suitcase
setappdata(0,'object_data',object);
p(5) = patch('faces',object.F, 'vertices',object.V); %Create its surfaces
set(p(5),'FaceColor', [0.8 0.4 0.65]); %Color of surfaces
set(p(5),'EdgeColor','none'); %Do not show Edge line of triangular surfaces
V5 = object.V'; V{5} = V5;
% init luggage's location
TH1 = 15; TH2 = 30; D3 = -200; TH4 = -45;
alpha0 = 0; a0 = 0; theta1 = TH1; d1 = D1* UNIT_METER;
alpha1 = 0; a1 = L1 * UNIT_METER; theta2 = TH2; d2 = 0;
alpha2 = 0; a2 = L2* UNIT_METER; theta3 = 0; d3 = D3* UNIT_METER;
alpha3 = -180; a3 = 0; theta4 = TH4; d4 = D4* UNIT_METER;
T01 = tmat(alpha0, a0, d1, theta1);
T12 = tmat(alpha1, a1, d2, theta2);
T23 = tmat(alpha2, a2, d3, theta3);
T34 = tmat(alpha3, a3, d4, theta4);
T04 = T01*T12*T23*T34;
R04 = T04(1:3,1:3); P04 = T04(1:3,4);
newV{5} = R04*V{5};
newV{5} = newV{5} + repmat(P04,[1 length(newV{5}(1,:))]);
set(p(5),'Vertices',newV{5}(1:3,:)');

% Setup viewport
view(45,30);
xlim([-3.5 3.5]);
ylim([-3.5 3.5]);
zlim([0 5]);
set(gcf,'Position',[0 0 1920 1080]);


%% 1. INPUT: WAYPOINTS & TIME INTERVAL
% WAYPOINT format: [x, y, z, phi(angle)]
waypoint = [
    240         0       200     0;
    240         0       150     0;
    240         0       250     0;
    60          103.92  200       0;
    -103.92     60     200       0;
    200.76      115.91  50     0;
    -028.94     219.83  150     0; %
    -28.94     219.83  150     90; %
    -103.92     -60    50     90; %
    84.85      204.85  200       0;
    ];

% Grab or release the luggage
grab = [0;0;0;0;0;0;1;1;1;0;];

% Time interval (in seconds)
tf = 2;

n_samples = 1 + size(waypoint, 1)*tf*FPS;
j_pos = zeros([n_samples, 4]); j_pos(1,:) = [0,0,0,0];
j_vel = zeros([n_samples, 4]); j_vel(1,:) = [0,0,0,0];
j_acc = zeros([n_samples, 4]); j_acc(1,:) = [0,0,0,0];
grabbing = zeros([n_samples, 1]); grabbing(1,:) = [0];
real_time = zeros([1, n_samples]);

%% 2. Inverse Kinematic & Trajectory Generation

% Iterate each segment/waypoint
init_j_pos = j_pos(1,:);
for i = 1:size(waypoint, 1)
    X = waypoint(i, 1); Y = waypoint(i, 2); Z = waypoint(i, 3); % Position
    PHI = waypoint(i, 4); % Orientation
    
    % Inverse kinematics

    D3 = Z - D1; %%%%
    c2 = (X^2 + Y^2 -L1^2 - L2^2)/(2*L1*L2);
    s2 = sqrt(1-c2^2); % Here, we pick the positive one
    TH2 = rad2deg(atan2(s2, c2)); %%%%
    k1 = L1 + L2*c2; k2 = L2*s2;
    TH1 = rad2deg(atan2(Y,X)-atan2(k2, k1)); %%%%
    TH4 = (PHI-TH1-TH2); %%%%

    target_j_pos = [TH1 TH2 D3 TH4];
    
    % for each joint
    for j = 1:size(target_j_pos, 2)
        % calculate polynomial coefficient
        pos_0 = init_j_pos(1,j);
        pos_f = target_j_pos(1,j);
        a0 = pos_0;
        a1 = 0;
        a2 = 0;
        a3 = (20*pos_f-20*pos_0)/(2*tf^3);
        a4 = (30*pos_0-30*pos_f)/(2*tf^4);
        a5 = (12*pos_f-12*pos_0)/(2*tf^5);
        % for each sample
        for k = 1:FPS*tf
            % calculate pos, vel, acc, attached
            t = k*(1/FPS);
            global_idx = 1+(i-1)*(FPS*tf)+k;
            pos = a0+a1*t+a2*t^2+a3*t^3+a4*t^4+a5*t^5;
            vel = a1+2*a2*t+3*a3*t^2+4*a4*t^3+5*a5*t^4;
            acc = 2*a2+6*a3*t+12*a4*t^2+20*a5*t^3;
            j_pos(global_idx,j) = pos;
            j_vel(global_idx,j) = vel;
            j_acc(global_idx,j) = acc;
        end            
    end
    for k = 1:FPS*tf
        global_idx = 1+(i-1)*(FPS*tf)+k;
        grabbing(global_idx,1) = grab(i,1);
        rt = (i-1)*tf + k*(1/FPS);
        real_time(1,global_idx) = rt;
    end

    init_j_pos = target_j_pos;
end

%% 4. FORWARD KINEMATIC
ee_pos = zeros([n_samples, 3]);
for s = 1:n_samples
    TH1 = j_pos(s,1); TH2 = j_pos(s,2); D3 = j_pos(s,3); TH4 = j_pos(s,4);

    alpha0 = 0; a0 = 0; theta1 = TH1; d1 = D1* UNIT_METER;
    alpha1 = 0; a1 = L1 * UNIT_METER; theta2 = TH2; d2 = 0;
    alpha2 = 0; a2 = L2* UNIT_METER; theta3 = 0; d3 = D3* UNIT_METER;
    alpha3 = -180; a3 = 0; theta4 = TH4; d4 = D4* UNIT_METER;

    T01 = tmat(alpha0, a0, d1, theta1);
    T12 = tmat(alpha1, a1, d2, theta2);
    T23 = tmat(alpha2, a2, d3, theta3);
    T34 = tmat(alpha3, a3, d4, theta4);
    
    T02 = T01*T12;
    T03 = T02*T23;
    T04 = T03*T34;
    
    R01 = T01(1:3,1:3); R02 = T02(1:3,1:3); R03 = T03(1:3,1:3); R04 = T04(1:3,1:3);
    P01 = T01(1:3,4); P02 = T02(1:3,4); P03 = T03(1:3,4); P04 = T04(1:3,4);

    ee_pos(s,1) = T04(1,4); ee_pos(s,2) = T04(2,4); ee_pos(s,3) = T04(3,4);

    newV{2} = R01*V{2};
    newV{2} = newV{2} + repmat(P01,[1 length(newV{2}(1,:))]);
    newV{3} = R02*V{3};
    newV{3} = newV{3} + repmat(P02,[1 length(newV{3}(1,:))]);
    newV{4} = R03*V{4};
    newV{4} = newV{4} + repmat(P03,[1 length(newV{4}(1,:))]);
    
    set(p(2),'Vertices',newV{2}(1:3,:)');
    set(p(3),'Vertices',newV{3}(1:3,:)');
    set(p(4),'Vertices',newV{4}(1:3,:)');

    if grabbing(s,1) == 1
        newV{5} = R04*V{5};
        newV{5} = newV{5} + repmat(P04,[1 length(newV{5}(1,:))]);
        set(p(5),'Vertices',newV{5}(1:3,:)');
    end
    drawnow

    % Capture the plot as an image
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    
    % Write to the GIF File
    if s == 1
        imwrite(imind, cm, 'luggage_manipulator.gif', 'gif', 'Loopcount', inf, 'DelayTime', 1/FPS);
    else
        imwrite(imind, cm, 'luggage_manipulator.gif', 'gif', 'WriteMode', 'append', 'DelayTime', 1/FPS);
    end
    hold on;
end

hold off;
clf; % clear the figure

%% 5. Joint Profile Visualization

for j = 1:size(j_pos,2)
    % position
    x = real_time;
    y = j_pos(:,j);
    plot(x, y, 'r', 'LineWidth', 2);
    xlabel('Real Time');
    ylabel('Joint Position');
    filename = sprintf('Joint_%d_Position.png', j);
    saveas(gcf, filename);
    clf;
    % velocity
    x = real_time;
    y = j_vel(:,j);
    plot(x, y, 'b', 'LineWidth', 2);
    xlabel('Real Time');
    ylabel('Joint Velocity');
    filename = sprintf('Joint_%d_Velocity.png', j);
    saveas(gcf, filename);
    clf;
    % acceleration
    x = real_time;
    y = j_acc(:,j);
    plot(x, y, 'k', 'LineWidth', 2);
    xlabel('Real Time');
    ylabel('Joint Acceleration');
    filename = sprintf('Joint_%d_Acceleration.png', j);
    saveas(gcf, filename);
    clf;
end

% End Effector: Comet3
x = ee_pos(:,1); y = ee_pos(:,2); z = ee_pos(:,3); 
grid on;
set(gcf,'Position',[0 0 1920/2 1080/2]);
comet3(x,y,z, 0.5);
