% Define the symbolic variables
syms th1 th2 d3

% Define the transformation matrix with symbolic variables
T = [cos(th1+th2), -sin(th1+th2), 0, 120*cos(th1)+120*cos(th1+th2);
     sin(th1+th2), cos(th1+th2), 0, 120*sin(th1)+120*sin(th1+th2);
     0, 0, 1, d3+250;
     0, 0, 0, 1];
resolution = 20;
% Define the ranges for the variables
th1_range = linspace(0, pi, resolution); 
th2_range = linspace(0, pi, resolution);
d3_range = linspace(0, -200, resolution);

% Initialize arrays to store the positions
x_positions = [];
y_positions = [];
z_positions = [];

% Iterate through all values of variables in the given ranges
for a_val = th1_range
    for b_val = th2_range
        for c_val = d3_range
            % Substitute the values into the transformation matrix
            T_numeric = double(subs(T, {th1, th2, d3}, {a_val, b_val, c_val}));
            
            % Extract the position from the transformation matrix
            pos = T_numeric(1:3, 4)';
            
            % Store the position
            x_positions(end+1) = pos(1);
            y_positions(end+1) = pos(2);
            z_positions(end+1) = pos(3);
        end
    end
end

% Plot the positions in 3D space
figure;
scatter3(x_positions, y_positions, z_positions, 'filled');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Positions of the Transformation');
grid on;