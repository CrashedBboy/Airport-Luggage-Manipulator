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

disp(T01*T12*T23);