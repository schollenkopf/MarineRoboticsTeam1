Kp = 0.3;
Ki = 10.1;
Kd = 0.0;

simout = sim("PID_tuning");

figure;
hold on;
plot(simout.ref,"r");
plot(simout.y,"b");
legend("ref","y");
grid on;
hold off;