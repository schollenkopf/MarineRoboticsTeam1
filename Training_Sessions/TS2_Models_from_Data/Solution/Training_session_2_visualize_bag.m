close all
clear

% Load ROS bag file
BAG_FILENAME = '_2024-02-27-15-54-51.bag';
bagselect = rosbag(BAG_FILENAME);

% Select messages related to pose ground truth
bSel_gt = select(bagselect, 'Topic', '/bluerov2/pose_gt');
msgStructs_gt = readMessages(bSel_gt, 'DataFormat', 'struct');
time_gt = bSel_gt.MessageList.Time;

pos_x_gt = cellfun(@(m) double(m.Pose.Pose.Position.X), msgStructs_gt);
pos_y_gt = cellfun(@(m) double(m.Pose.Pose.Position.Y), msgStructs_gt);
pos_z_gt = cellfun(@(m) double(m.Pose.Pose.Position.Z), msgStructs_gt);

quat_x_gt = cellfun(@(m) double(m.Pose.Pose.Orientation.X), msgStructs_gt);
quat_y_gt = cellfun(@(m) double(m.Pose.Pose.Orientation.Y), msgStructs_gt);
quat_z_gt = cellfun(@(m) double(m.Pose.Pose.Orientation.Z), msgStructs_gt);
quat_w_gt = cellfun(@(m) double(m.Pose.Pose.Orientation.W), msgStructs_gt);

eul_gt = quat2eul([quat_w_gt quat_x_gt, quat_y_gt, quat_z_gt],"XYZ");
roll_gt = eul_gt(:,1);
pitch_gt = eul_gt(:,2);
yaw_gt = eul_gt(:,3);

vel_x_gt = cellfun(@(m) double(m.Twist.Twist.Linear.X), msgStructs_gt);
vel_y_gt = cellfun(@(m) double(m.Twist.Twist.Linear.Y), msgStructs_gt);
vel_z_gt = cellfun(@(m) double(m.Twist.Twist.Linear.Z), msgStructs_gt);
roll_rate_gt = cellfun(@(m) double(m.Twist.Twist.Angular.X), msgStructs_gt);
pitch_rate_gt = cellfun(@(m) double(m.Twist.Twist.Angular.Y), msgStructs_gt);
yaw_rate_gt = cellfun(@(m) double(m.Twist.Twist.Angular.Z), msgStructs_gt);

% Select messages related to pose reference
bSel_vel_ref = select(bagselect, 'Topic', '/bluerov2/cmd_vel');
msgStructs_vel_ref = readMessages(bSel_vel_ref, 'DataFormat', 'struct');
time_vel_ref = bSel_vel_ref.MessageList.Time;

vel_x_ref = cellfun(@(m) double(m.Linear.X), msgStructs_vel_ref);
vel_y_ref = cellfun(@(m) double(m.Linear.Y), msgStructs_vel_ref);
vel_z_ref = cellfun(@(m) double(m.Linear.Z), msgStructs_vel_ref);

roll_rate_ref = cellfun(@(m) double(m.Angular.X), msgStructs_vel_ref);
pitch_rate_ref = cellfun(@(m) double(m.Angular.Y), msgStructs_vel_ref);
yaw_rate_ref = cellfun(@(m) double(m.Angular.Z), msgStructs_vel_ref);

% Select messages related to thrust
[thrust0,time_thrust0] = thrust_parsing(bagselect,'/bluerov2/thrusters/0/thrust');
[thrust1,time_thrust1] = thrust_parsing(bagselect,'/bluerov2/thrusters/1/thrust');
[thrust2,time_thrust2] = thrust_parsing(bagselect,'/bluerov2/thrusters/2/thrust');
[thrust3,time_thrust3] = thrust_parsing(bagselect,'/bluerov2/thrusters/3/thrust');
[thrust4,time_thrust4] = thrust_parsing(bagselect,'/bluerov2/thrusters/4/thrust');
[thrust5,time_thrust5] = thrust_parsing(bagselect,'/bluerov2/thrusters/5/thrust');
% Plot 
figure;
plot(time_gt, vel_x_gt, 'b');
title('Velocity forward');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
grid on;
hold off;

figure

subplot(3, 2, 1)
plot(time_thrust0, thrust0)
xlabel('Time (seconds)')
ylabel('Motor Thrust (N)')
grid on;
title('Thrust vs Time (Motor 0)')

subplot(3, 2, 3)
plot(time_thrust1, thrust1)
xlabel('Time (seconds)')
ylabel('Motor Thrust (N)')
grid on;
title('Thrust vs Time (Motor 1)')

subplot(3, 2, 5)
plot(time_thrust2, thrust2)
xlabel('Time (seconds)')
ylabel('Motor Thrust (N)')
grid on;
title('Thrust vs Time (Motor 2)')

subplot(3, 2, 2)
plot(time_thrust3, thrust3)
xlabel('Time (seconds)')
ylabel('Motor Thrust (N)')
grid on;
title('Thrust vs Time (Motor 3)')

subplot(3, 2, 4)
plot(time_thrust4, thrust4)
xlabel('Time (seconds)')
ylabel('Motor Thrust (N)')
grid on;
title('Thrust vs Time (Motor 4)')

subplot(3, 2, 6)
plot(time_thrust5, thrust5)
xlabel('Time (seconds)')
ylabel('Motor Thrust (N)')
grid on;
title('Thrust vs Time (Motor 5)')

hold off;

d_X = 0.135;
d_Y = 0.115;
gamma = pi/4;
d_perp = d_X*sin(gamma)+d_Y*cos(gamma);

M = [cos(gamma) cos(gamma) -cos(gamma) -cos(gamma);
     sin(gamma) -sin(gamma) sin(gamma) -sin(gamma);
     d_perp     -d_perp     -d_perp    d_perp];

thrust03 = [thrust0, thrust1, thrust2, thrust3];
MF = M* thrust03';
Fx = MF(1,:);
Fy = MF(2,:);
Mz = MF(3,:);

M = [1 1;
     -d_Y d_Y];
thrust45 = [thrust4, thrust5];
MF = M* thrust45';
Fz = MF(1,:);
Mx = MF(2,:);

figure

subplot(3, 2, 1)
plot(time_thrust0, Fx)
xlabel('Time (seconds)')
ylabel('Fx (N)')
grid on;
title('Body Force-Fx')

subplot(3, 2, 3)
plot(time_thrust1, Fy)
xlabel('Time (seconds)')
ylabel('Fy (N)')
grid on;
title('Body Force-Fy')

subplot(3, 2, 5)
plot(time_thrust2, Fz)
xlabel('Time (seconds)')
ylabel('Fz (N)')
grid on;
title('Body Force-Fz')

subplot(3, 2, 2)
plot(time_thrust3, Mx)
xlabel('Time (seconds)')
ylabel('Mx (Nm)')
grid on;
title('Body Moment-Mx')

subplot(3, 2, 4)
plot(time_thrust5, Mz)
xlabel('Time (seconds)')
ylabel('Mz (Nm)')
grid on;
title('Body Moment-Mz')

