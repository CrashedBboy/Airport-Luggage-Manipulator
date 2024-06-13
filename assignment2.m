syms th1 th2 th3 L3

th = th1;
a = deg2rad(0);
d = 0;
aa = 0;
T01 = [cos(th) -sin(th) 0 aa;
    sin(th)*round(cos(a)) cos(th)*round(cos(a)) -sin(a) -sin(a)*d;
    sin(th)*sin(a) cos(th)*sin(a) round(cos(a)) cos(a)*d;
    0 0 0 1];
disp(T01);

th = th2;
a = deg2rad(90);
d = 0;
aa = 0;
T12 = [cos(th) -sin(th) 0 aa;
    sin(th)*round(cos(a)) cos(th)*round(cos(a)) -sin(a) -sin(a)*d;
    sin(th)*sin(a) cos(th)*sin(a) round(cos(a)) cos(a)*d;
    0 0 0 1];
disp(T12);

th = th3;
a = deg2rad(0);
d = 0;
aa = L3;
T23 = [cos(th) -sin(th) 0 aa;
    sin(th)*round(cos(a)) cos(th)*round(cos(a)) -sin(a) -sin(a)*d;
    sin(th)*sin(a) cos(th)*sin(a) round(cos(a)) cos(a)*d;
    0 0 0 1];
disp(T23);