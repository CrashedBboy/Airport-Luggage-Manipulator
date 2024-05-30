%Chess Game
%This file only shows the oppening move of a chess game. Only the
%end-effector will move (the other links are fixed)
%
%This file was created as a templete for MSE 429 Advanced Kinematics of
%Robotics Systems at SFU

%1. INITIALIZATION (NO CHANGES ARE NECESSARY except for section 1.3)
%clear variables and close figures
clc; clear all; close all;

%1.1. Define size of figure and create figure handle (DO NOT MODIFY)
set(0,'Units','pixels');
dim = get(0,'ScreenSize');
fig_handle = figure('doublebuffer','on','Position',[dim(3)/2,50,dim(3)/2,dim(4)/2],... %[50,50,dim(3)-200,dim(4)-200],...  % 
    'Name','3D Object','NumberTitle','off');
set(gcf,'color', [1 1 1]) %Background Colour

%1.2 Define the light in the figure (CHANGE POSITION VECTOR IF FIGURE IS TOO BRIGHT/DARK)
set(fig_handle,'Renderer','zbuffer','doublebuffer','off')
light('color',[.5,.5,.5],'position',[0,1,3],'Style','infinite')
lighting gouraud
daspect([1 1 1]);

%1.3 Axes (TO MODIFY Make sure your axes fit within the region) 
axis([-400 1000 -200 1200 -100 400]);  %To be changed to include workspace
view(40,30);                           %To be changed to view from other angle
zoom(0.8)                              %To be changed to zoom in/out 
axis off;


%2. LOAD PART FILES       %Load your manipultor links and external objects
%Load STL files of the chess pieces and the manipulator links



%% 2.1 CHESS PIECES 
%2.1 CHESS PIECES 
%ChessPieces has all thirty two black and white pieces, all of them are
%located with their base point coincident with the inertial reference frame
load chess_pieces

% The next few line store data in a more convenient way. 
% IMPORTANT: If you transfer a figure using stl2mat, the part will be called
% object, Using the line setappdata(0,'object_data',object) gives

for i=1:6
setappdata(0,'object_data',piece{i});
piece{i} = getappdata(0,'object_data');
end
piece{4}.V = piece{4}.V*50;  % Knight are indexed as the forth elements
                             % and should be scaled as its 3D is small

%Finding Origins of the chess parts
hold on;
for j=1:6
  index = find(piece{j}.V(:,3) < (min(piece{j}.V(:,3)) - min(piece{j}.V(:,3))*.001));
  origin{j} = mean(piece{j}.V(index,1:3));
  piece{j}.V(end+1,:) = origin{j};
%   plot3(piece{j}.V(end,1),piece{j}.V(end,2),piece{j}.V(end,3),'b*')
end

for j=1:6
piece{j}.V = piece{j}.V + repmat(-piece{j}.V(end,:),[length(piece{j}.V(:,1)) 1]);
end

%Whites
white{1}= piece{1};                     % king
white{2}= piece{2};                     % queen
white{3}= piece{3}; white{4}= piece{3}; % two rooks
white{5}= piece{4}; white{6}= piece{4}; % two knights
white{7}= piece{5}; white{8}= piece{5}; % two bishops

% White knights should be direted in the oposite (face inward)
white{5}.V = [-1 0 0; 0 -1 0; 0 0 1]*white{5}.V'; white{5}.V = white{5}.V';
white{6}.V = [-1 0 0; 0 -1 0; 0 0 1]*white{6}.V'; white{6}.V = white{6}.V';

for i=1:8
    white{8+i}=piece{6}; % eight pawns
end

White = white;

for i=1:16
    p(i) = patch('faces', White{i}.F, 'vertices', White{i}.V);
    set(p(i),'FaceColor', [1.0000    1.0000    0.9375]); % off-white color
    set(p(i),'EdgeColor','none');
end

White{1}.V = white{1}.V + repmat([450 50 0],[length(white{1}.V(:,1)) 1]);
White{2}.V = white{2}.V + repmat([350 50 0],[length(white{2}.V(:,1)) 1]);
White{3}.V = white{3}.V + repmat([550 50 0],[length(white{3}.V(:,1)) 1]);
White{4}.V = white{4}.V + repmat([250 50 0],[length(white{4}.V(:,1)) 1]);
White{5}.V = white{5}.V + repmat([650 50 0],[length(white{5}.V(:,1)) 1]);
White{6}.V = white{6}.V + repmat([150 50 0],[length(white{6}.V(:,1)) 1]);
White{7}.V = white{7}.V + repmat([750 50 0],[length(white{7}.V(:,1)) 1]);
White{8}.V = white{8}.V + repmat([50 50 0],[length(white{8}.V(:,1)) 1]);

for i=1:8
    White{8+i}.V = white{8+i}.V + repmat([50+(i-1)*100 150 0],[length(white{8+i}.V(:,1)) 1]); 
end

% Create a new set of parts ("White" are the pieces that move, whereas "white" are the
% pieces fixed at the global origin)
White = white;

% Create surfaces and change colour to white
for i=1:16
    p(i) = patch('faces', White{i}.F, 'vertices', White{i}.V);
    set(p(i),'FaceColor', [1.0000    1.0000    0.9375]); % off-white color
    set(p(i),'EdgeColor','none');
end

%Position pieces from global origin to their corresponding squares
White{1}.V = white{1}.V + repmat([450 50 0],[length(white{1}.V(:,1)) 1]);
White{2}.V = white{2}.V + repmat([350 50 0],[length(white{2}.V(:,1)) 1]);
White{3}.V = white{3}.V + repmat([550 50 0],[length(white{3}.V(:,1)) 1]);
White{4}.V = white{4}.V + repmat([250 50 0],[length(white{4}.V(:,1)) 1]);
White{5}.V = white{5}.V + repmat([650 50 0],[length(white{5}.V(:,1)) 1]);
White{6}.V = white{6}.V + repmat([150 50 0],[length(white{6}.V(:,1)) 1]);
White{7}.V = white{7}.V + repmat([750 50 0],[length(white{7}.V(:,1)) 1]);
White{8}.V = white{8}.V + repmat([50 50 0],[length(white{8}.V(:,1)) 1]);

for i=1:8 % Placement of eight white pawns
    White{8+i}.V = white{8+i}.V + repmat([50+(i-1)*100 150 0],[length(white{8+i}.V(:,1)) 1]); 
end

%blacks
black{1}= piece{1}; 
black{2}= piece{2}; 
black{3}= piece{3}; black{4}= piece{3}; 
black{5}= piece{4}; black{6}= piece{4}; 
black{7}= piece{5}; black{8}= piece{5};
for i=1:8 
    black{8+i}=piece{6}; 
end

Black = black;
for i=17:32
    p(i) = patch('faces', Black{i-16}.F, 'vertices', Black{i-16}.V);
    set(p(i),'FaceColor', [0.5430    0.2695    0.0742]); % dark brown color
    set(p(i),'EdgeColor','none');
end

%Position pieces from global origin to their corresponding squares
Black{1}.V = black{1}.V + repmat([450 750 0],[length(black{1}.V(:,1)) 1]);
Black{2}.V = black{2}.V + repmat([350 750 0],[length(black{2}.V(:,1)) 1]);
Black{3}.V = black{3}.V + repmat([550 750 0],[length(black{3}.V(:,1)) 1]);
Black{4}.V = black{4}.V + repmat([250 750 0],[length(black{4}.V(:,1)) 1]);
Black{5}.V = black{5}.V + repmat([650 750 0],[length(black{5}.V(:,1)) 1]);
Black{6}.V = black{6}.V + repmat([150 750 0],[length(black{6}.V(:,1)) 1]);
Black{7}.V = black{7}.V + repmat([750 750 0],[length(black{7}.V(:,1)) 1]);
Black{8}.V = black{8}.V + repmat([50 750 0],[length(black{8}.V(:,1)) 1]);

for i=1:8 % Placement of eight white pawns
    Black{8+i}.V = black{8+i}.V + repmat([50+(i-1)*100 650 0],[length(black{8+i}.V(:,1)) 1]); 
end

% Set the pieces on the Chessboard
for j=1:32
       if j<17; set(p(j),'Vertices',White{j}.V(:,1:3)); end
       if j>16; set(p(j),'Vertices',Black{j-16}.V(:,1:3)); end
end

%Cheesboard
line([0 0 800 800 0], [0 800 800 0 0],'Color',[0 0 0])
square.F=[1,2,3;1,3,4];
for k=1:2
    if k==1; offset=0; elseif k==2; offset=100; end
    for j=1:4
        for i=1:4
            square.V=[(j-1)*200+offset,(i-1)*200+offset,0;
                100+(j-1)*200+offset,(i-1)*200+offset,0;
                100+(j-1)*200+offset,100+(i-1)*200+offset,0;
                (j-1)*200+offset,100+(i-1)*200+offset,0];
            s = patch('faces',square.F, 'vertices', square.V);
        end
    end
end

%% 2.2 MANIPULATOR (LOAD THE PARTS IN YOUR MANIPULATOR)
%Load all the individual parts of the manipulator
% Note that in this template, only the end-effector is loaded. Make sure to
% load all the parts of your manipulator.


% Here, only the 2ed arm including the end effector is loaded. Note that
% this is named as "obj{3}". For example, if you have five members being
% loaded into code, you may name them "obj{1}", ..., "ojc{3}".
load Part2b 
setappdata(0,'object_data',object);
object = getappdata(0,'object_data');
obj{3}=object;

% Print all the parts of the manipulator. Note all moving parts are
% located at the global reference frame
% When all your parts loaded, the following "for loop" can be used to
% "patch" the pieces for later coloring. For example if you load five
% members above, then the counte i should be set to "i = 1:5"

for i=3 
    q(i) = patch('faces', obj{i}.F, 'vertices', obj{i}.V);
    set(q(i),'EdgeColor','none');
end

% Set colour to the componenets (assuming you have imported five members)
% set(q(1),'FaceColor', [1,0.242,0.293]);
% set(q(2),'FaceColor', [.4,0.6,0.6]);
set(q(3),'FaceColor', [.6,0.6,0.4]);          % This defines the end-effector color
% set(q(4),'FaceColor', [.9,0.9,0.9]);
% set(q(5),'FaceColor', [.9,0.9,0.9]);
%     
%Rename of all the vertices. This step is redundant obj{}.V will not longer be used
V3 = obj{3}.V'; V{3} = V3;

% According to your design, change the following dimensions
L2 = 600;
L3 = 600;
dee = min(V3(3,:));

set(fig_handle,'Renderer','zbuffer','doublebuffer','off')
light('color',[.99,.99,.99],'position',[0,0,2],'Style','infinite')
lighting gouraud
daspect([1 1 1]);
axis on


%% ANIMATION FUNCTIONS
% Animation (DO NOT CHANGE)
RGB=256;  %Resolution
fm = getframe; [img,map] = rgb2ind(fm.cdata,RGB,'nodither');

%ERASE THE NEXT TWO LINES OR COMMENT THEM
% disp('Note that all the chess pieces are placed in their correct position. Initially all of them were located at the global reference frame. All the links of the manipulator are located at the global reference frame, they will be translated using kinematics')
% pause


%% %3. PATH GENERATION (MODIFY)
%3.1 Single Pose (Project Phase II)
P_ee=[400
      400
      150];

%   Note your manipulators is up to 5-DOF, so its P_ee matrix should be
%   populated accordingly. For example, if use select a 4-DOF manipulater,
%   your P_ee will be of size 4x1



%3.2 Path Generation EXAMPLE 
% %Spatial Coordinates of the end-effector 
P_ee = [400 450 450 450 450 450 450
        400 150 150 150 350 350 350
        150 150  0	 150 150  0	 150];
%  
% %Spatial Coordinates of the pawn
P_pawn = [450	450	450	450	450	450	450
          150	150	150	150	350	350	350
          0	    0	0	150	150	0	0];
    

%% %4. INVERSE KINEMATICS OF THE SCARA MANIPULATOR
  
%4.1 Inverse Kinematics
  %Define the link dimensions (DH parameters)
    L2 = 600; 
    L3 = 600;
    dee=-160; %z axis points upwards, gripper points downwards

    %Inverse Kinematics
    %In this section the inverse kinematics of the manipulator is solved.
    %For this particular example solve for each position of the
    %end-effector the three joint displacements
    
    %theta3=
    %theta2=
    %d1 =
    %joints [d1;  theta2; theta3];
    
    %EXAMPLES FOR PARTS II and III   
    %4.2 Single pose (Part II project) ERASE
     joints = [ 300.0000 
                106.8745   
               -123.7490];
    
    %4.3 EXAMPLE for EE path generation (Part III project)
    %Store all displacements in a Matrix 
    %joints=[d1;theta2;theta3]; %Matrix stores motion of all three joints
    %ERASE NEXT LINE (this is the solution using the cubic_sheme)
    joints = [  300.0000  300.0000  150.0000  300.0000  300.0000  150.0000  300.0000
                106.8745   85.1512   85.1512   85.1512   99.5109   99.5109   99.5109
               -123.7490 -133.4325 -133.4325 -133.4325 -123.2718 -123.2718 -123.2718];      
                
%% 5. TRAJECTORY GENERATION

%5.1 Trajectory Generation
% Trajectory Parameters (CHANGE, YOUR DESIGN)
tf=1;  %Duration of each Segment (if segments have different durations enter it in a vector form)
dt=0.5;  %time steps

% Trajectory generation of all the joints
 n=length(joints(1,:));%number of points in the path
% for j=1:3; %three joints (SIX JOINTS FOR YOU)
%         dv=[]; %Initialize displacement vector (same with vel and acc)
%         for i=1:(n-1)
%             %WRITE YOUR TRAJECTORY GENERATION SCHEME THAT WILL PRODUCE A
%             %HISTORY OF DISPLACEMENT, VELOCITY, ACCELERATION AND TIME FOR EACH JOINT. 
%             %Enter configuration of joint_i or joints(j,i) and joint_i+1,
%             %tf(duration of the segment) and dt (time step)
%             d=0;% %Enter scheme
%             dv=[dv d]; %Store in vector the displacements of joint j  (same with vel and acc)
%         end
%         D(j,:)=dv;  %Store vectors in a matrix
% end
stepsize=.01; %delta t
%[D,V,A,time]=via_points_match_VA(joints, duration, stepsize, 'prescribed',[0,0]);

%EXAMPLES FOR PARTS II 
%5.2 Single Pose (Part II example)
D = [310; 106.8744942979449;-123.748988595889];

%5.3 Trajectory Generation (Part III example- uncomment)
D = [310,310,310,310,235,160,160,235,310,310,310,310,310,235,160,160,235,310;106.874494297944,96.0128556998806,85.1512171018169,85.1512171018169,85.1512171018169,85.1512171018169,85.1512171018169,85.1512171018169,85.1512171018169,85.1512171018169,92.3310457446244,99.5108743874319,99.5108743874319,99.5108743874319,99.5108743874319,99.5108743874319,99.5108743874319,99.5108743874319;-123.748988595889,-128.590762576839,-133.432536557790,-133.432536557790,-133.432536557790,-133.432536557790,-133.432536557790,-133.432536557790,-133.432536557790,-133.432536557790,-128.352159015229,-123.271781472667,-123.271781472667,-123.271781472667,-123.271781472667,-123.271781472667,-123.271781472667,-123.271781472667];

%EXAMPLES FOR III Trajectory of the pawn (Cartesian Scheme)
% n=length(P_pawn(1,:)); %number of points in the path
% for j=1:3; %x,y,z (motion along each axis is determine independently)
%         pp_pawn=[]; %Initialize displacement vector
%         for i=1:(n-1)
%           %WRITE YOUR TRAJECTORY GENERATION SCHEME THAT WILL PRODUCE A
%           %HISTORY OF DISP, VEL, ACC. AND TIME FOR EACH COORDINATE
%           %(x,y,z) OF THE PIECE THAT IS MOVING. 
%           %Enter configuration of P_pawn_i and P_pawn_i+1,
%           %tf(duration of the segment) and dt (time step)
%           d_pawn=0;% %Enter scheme
%            pp_pawn=[pp_pawn d_pawn]; %Store in vector the displacements along one axis
%         end
%         PP_pawn(j,:)=pp_pawn; %Store in vector the displacements along all three axes (x,y,z)
% end

%NUMERICAL EXAMPLE (ERASE)
PP_pawn = [450,450,450,450,450,450,450,450,450,450,450,450,450,450,450,450,450,450;150,150,150,150,150,150,150,150,150,150,250,350,350,350,350,350,350,350;0,0,0,0,0,0,0,75,150,150,150,150,150,75,0,0,0,0];


%% %ANIMATION (DO NOT CHANGE)
    mov(1:length(D(1,:))) = struct('cdata', [],'colormap', []);
    [a,b]=size(img); gifim=zeros(a,b,1,n-1,'uint8');  

    
%% 6. FORWARD KINEMATICS / DISPLACEMENT AND ROTATION OF HANDLE OBJECTS
%INPUTS
% Length of links (CHANGE, YOUR DESIGN)
L2 = 600;
L3 = 600;
dee=-160;

% Link Parameters of DH table (CHANGE, YOUR DESIGN)
alpha0 = 0; a0 = 0; theta1 = 0; %(d1 is variable)
alpha1 = 0; a1 = 0; d2 = 0;     %(theta2 is variable)
alpha2 = 0; a2 = L2; d3 = 0;    %(theta3 is variable)
alpha3 = 0; a3 = L3; thetaee = 0; %(dee was already defined)


for i=1:length(D(1,:))
     
     %DH parameters (CHANGE BASED ON THE JOINT VARIABLE, HERE IS d1, theta2 and theta3)
            T_01 = tmat(alpha0, a0, D(1,i),theta1);
            T_12 = tmat(alpha1, a1, d2, D(2,i));
            T_23 = tmat(alpha2, a2, d3, D(3,i));
            T_3ee = tmat(alpha3, a3, dee, thetaee);
     
    %Forward Kinematics
            T_02 = T_01*T_12;
            T_03 = T_02*T_23;
            T_0ee = T_03* T_3ee; %Homogeneous Tranforms
    
            %Position and rotation matrices of frame {3} (where link 3 is
            %located) and the end-effector 
            R_03 = T_03(1:3,1:3); 
            P_03 = T_03(1:3,4);
            R_0ee = T_0ee(1:3,1:3);
            P_0ee = T_0ee(1:3,4);
            
     %Move Links of Manipulator            
            %End-effector moves accordingly with T_03, other links will
            %move based on other T_0i. The following lines find the new
            %orientation and position of the vertices of the end-effector.
            newV{3} = R_03*V{3}; %Find new orientation of link 3
            newV{3} = newV{3} + repmat(P_03,[1 length(newV{3}(1,:))]); %Find new position of link 3
           
            for ii=3 %use for loop for all the parts of your manipulator
                set(q(ii),'Vertices',newV{ii}(1:3,:)'); %Set the new position in the handle (graphical link)
            end
            
    %UNCOMMENT IN PART III        
        %Move Pawn
%             pawn_m.V=pawn.V+repmat(PP_pawn(:,i)',[length(pawn.V(:,1)) 1]); %Find new position of pawn
%             set(p(13),'Vertices',pawn_m.V(:,1:3)); %Set the new position of the pawn p(13) is the handle for that pawn
%      
     %ANIMATION, saves frames (DO NOT MODIFY)       
     drawnow  %Draw objects to their new poisitons
     im= frame2im(getframe);
     gifim(:,:,:,i) = rgb2ind(im, map);
     mov(i)=getframe(gcf);
end

%ANIMATION, creates animated gif (DO NOT MODIFY)
imwrite(gifim,map,'Chess_Animation.gif','DelayTime',0)%,'LoopCount',inf)


