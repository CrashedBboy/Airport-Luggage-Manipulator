clc
%% Problem 3
% syms theta1 theta2 L1 L2
% 
% T01 = tmat2(0, 0, 0, theta1);
% T12 = tmat2(0.5*pi, L1, 0, theta2);
% T23 = tmat2(0, L2, 0, 0);
% 
% disp(T01);
% disp(T12);
% T12 = [
%     cos(theta2) -sin(theta2) 0 L1;
%     0 0 -1 0;
%     sin(theta2) cos(theta2) 0 0;
%     0 0 0 1;
%     ];
% disp(T23);
% 
% disp(simplify(T01*T12*T23));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem 6
syms theta1 theta2 theta3 theta4 K

T01 = tmat2(0, 0, 0, theta1);
T12 = tmat2(-0.5*pi, 1, 1, theta2);
T23 = tmat2(0.25*pi, 0, 1, theta3);
T34 = tmat2(0, 1, 0, 0);

disp(T01);

T12 = [
    cos(theta2) -sin(theta2) 0 1;
    0 0 1 0;
    -sin(theta2) -cos(theta2) 0 0;
    0 0 0 1;
    ];
disp(T12);
disp(T23);
disp(T34);

digits(3);
disp(vpa(T01*T12*T23*T34));