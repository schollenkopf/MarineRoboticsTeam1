%% Model identification of surge dynamics

clear all
close all
clc

% Load input-output data
% example file "data_merged_surge_relay.mat"
% the file contains 13 different experiments

load data_merged_surge_relay.mat

% Select one of the 13 experiments to identify the model of surge dynamics
% Good experiments: 3, 4, 6, 8, 12, 13
ExpNo_ID = 3; % ExpNo can take an integer value between 1 and 13
ExpData = getexp(data_merged_surge_relay,ExpNo_ID);

% Extract the input data, the output data, and the sampling time
% Input data: thrust force [N]
% Output data: surge speed [m/s]
% Sampling time: [s]

u = ExpData.InputData;
y = ExpData.OutputData;
Ts = ExpData.Ts;

% Point of operation
U0_ID = y(1); % point of operation of surge speed
X0_ID = u(1); % point of operation of forward thrust

% Remove point of operation
u = u-X0_ID;
y = y-U0_ID;

% Prepare the data for system identification
surge_data_ID = iddata(y,u,Ts);
figure; plot(surge_data_ID)

% Fit data to a 1st order linear surge model
na=1; nb=1; nk=1;
n=[na nb nk];
sys_surge = arx(surge_data_ID,n);

% Present the model
present(sys_surge)

figure
opt = compareOptions('InitialCondition','z'); % 'e': estimate, 'z': zero
compare(surge_data_ID,sys_surge,opt); drawnow;

% Validate the model on different dataset
ExpNo_VA = 13; % ExpNo can take an integer value between 1 and 13
ExpData = getexp(data_merged_surge_relay,ExpNo_VA);

u = ExpData.InputData;
y = ExpData.OutputData;
Ts = ExpData.Ts;

U0_VA = y(1); % point of operation of surge speed
X0_VA = u(1); % point of operation of forward thrust

% Remove point of operation
u = u-X0_VA;
y = y-U0_VA;

% Prepare the data for system identification
surge_data_VA = iddata(y,u,Ts);

figure
opt = compareOptions('InitialCondition','z'); % 'e': estimate, 'z': zero
compare(surge_data_VA,sys_surge,opt); drawnow;

% Convert the identified model from discrete time to continuous time
sysc = d2c(sys_surge); 

% Extract model parameters of the identified model
m = 7.0570; % rigid body mass
alpha = -sysc.a(2);
beta = sysc.b;
mu = 1/beta; % total mass (rigid body + added mass)
Xu = alpha/beta;
Xudot = m-mu; % added mass

fprintf('=== surge_relay ExpNo %d results ===\n',ExpNo_ID);
fprintf('Operating velocity: U0 = %0.2f m/s\n',U0_ID);
fprintf('Operating force: X0 = %0.2f N\n',X0_ID);
fprintf('Added mass: Xudot = %0.2f kg\n', Xudot);
fprintf('Linear drag: Xu = %0.2f N/(m/s)\n', Xu);
fprintf('===========================\n\n');