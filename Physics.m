clc;
clear all;


% Constants
g = 9.81; % Acceleration due to gravity (m/s^2)
m = 0.58; % Mass of basketball in kg
h_player = 198.6 / 100; % Player height in meters
h_hoop = 304.799 / 100; % Hoop height in meters

% User Input
distance = input('Enter the horizontal distance between player and hoop (in meters): ');

% Compute height difference
delta_h = h_hoop - h_player;

% Required angle (Optimization Problem)
theta_range = linspace(30, 60, 100); % Angle range in degrees
best_theta = 0;
best_v0 = inf;

for theta = theta_range
    % Convert angle to radians
    theta_rad = deg2rad(theta);
    
    % Solve for v0 (initial velocity) to reach the hoop
    v0 = sqrt((g * distance^2) / (2 * cos(theta_rad)^2 * (distance * tan(theta_rad) - delta_h)));
    
    % Ensure velocity is feasible
    if isreal(v0) && v0 < best_v0
        best_v0 = v0;
        best_theta = theta;
    end
end

% Force Calculation
force = m * best_v0 * g;

% Display Results
disp(['Optimal angle to throw: ', num2str(best_theta), ' degrees']);
disp(['Required initial velocity: ', num2str(best_v0), ' m/s']);
disp(['Force to apply: ', num2str(force), ' N']);

% Time of flight
theta_rad = deg2rad(best_theta);
t_flight = (2 * best_v0 * sin(theta_rad) + sqrt((2 * best_v0 * sin(theta_rad))^2 + 4 * g * delta_h)) / (2 * g);

% Time array
t = linspace(0, t_flight, 100);

% Compute trajectory
x = best_v0 * cos(theta_rad) * t; % Horizontal position
y = h_player + best_v0 * sin(theta_rad) * t - 0.5 * g * t.^2; % Vertical position

% Plot
figure;
plot(x, y, '-r', 'LineWidth', 2);
grid on;
xlabel('Horizontal Distance (m)');
ylabel('Vertical Height (m)');
title('Basketball Trajectory');
hold on;

% Maximum Height Calculation
t_max_height = best_v0 * sin(theta_rad) / g; % Time at max height
max_height = h_player + (best_v0 * sin(theta_rad) * t_max_height) - (0.5 * g * t_max_height^2); % Max height
x_max_height = best_v0 * cos(theta_rad) * t_max_height; % Horizontal distance to max height

% Display Results
disp(['Maximum Height of Basketball: ', num2str(max_height), ' meters']);
disp(['Horizontal Distance to Max Height: ', num2str(x_max_height), ' meters']);



% Plot player and hoop positions
plot(0, h_player, 'ob', 'MarkerSize', 8, 'DisplayName', 'Player Position');
plot(distance, h_hoop, 'ok', 'MarkerSize', 8, 'DisplayName', 'Hoop Position');
legend show;
hold off;
