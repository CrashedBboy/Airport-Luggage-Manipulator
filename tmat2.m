function T = tmat2(alpha, a, d, theta)
%         tmat(alpha, a, d, theta) (T-Matrix used in Robotics)
%         The homogeneous transformation called the "T-MATRIX"
%         as used in the Kinematic Equations for robotic type
%         systems (or equivalent).
%
%         This is equation 3.6 in Craig's "Introduction to Robotics."
%         alpha, a, d, theta are the Denavit-Hartenberg parameters.
%
%         (NOTE: ALL ANGLES MUST BE IN DEGREES.)
%
c = cos(theta);
s = sin(theta);
ca = cos(alpha);
sa = sin(alpha);
T = [c -s 0 a;
    s*ca c*ca -sa -sa*d;
    s*sa c*sa ca ca*d;
    0 0 0 1];
end