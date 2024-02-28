Kp = 10;
Ki = 1.0;
Kd = 0.001;

simout = sim("Cascaded_PID_tuning");

figure;
hold on;
plot(simout.ref,"r");
plot(simout.y,"b");
legend("ref","y");
grid on;
hold off;