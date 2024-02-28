Kp = 0.1;
Ki = 0.01;
Kd = 0.05;

simout = sim("PID_tuning");

figure;
hold on;
plot(simout.ref,"r");
plot(simout.y,"b");
legend("ref","y");
grid on;
hold off;