syms th1 th2 d3
T01 = [
    cos(th1) -sin(th1) 0 0;
    sin(th1) cos(th1) 0 0;
    0 0 1 250;
    0 0 0 1;];

T12 = [
    cos(th2) -sin(th2) 0 120;
    sin(th2) cos(th2) 0 0;
    0 0 1 0;
    0 0 0 1;];

T23 = [
    1 0 0 120;
    0 1 0 0;
    0 0 1 d3;
    0 0 0 1;];

%disp(T01*T12*T23);

T03 = T01*T12*T23;

T_numeric = double(subs(T03, {th1, th2, d3}, {deg2rad(30), deg2rad(45), -100}));

% Extract the position from the transformation matrix
pos = T_numeric(1:3, 4);
disp(pos);

disp(rad2deg(atan2(0.707132, 0.7070808)));
disp(rad2deg(atan2(-0.707132, 0.7070808)));

disp(rad2deg(atan2(84.85, 204.84)));
disp(rad2deg(atan2(-84.85, 204.84)));

disp(rad2deg(atan2(175.91, 134.98)));