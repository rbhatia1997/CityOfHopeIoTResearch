clear
clf
M_matlab = load('IMU0_raw_data.mat');
M_arduino = xlsread('IMU0_raw_mag.xlsx');
M_matlab = M_matlab.M;

figure(1)
scatter3(M_matlab(:,1),M_matlab(:,2),M_matlab(:,3),'b.');
hold on
scatter3(M_arduino(:,1),M_arduino(:,2),M_arduino(:,3),'r.');
ah = gca;
title('Raw Magnetometer Data');
xlabel('X Magnetic Flux [uT]');
ylabel('Y Magnetic Flux [uT]');
zlabel('Z Magnetic Flux [uT]');
set(ah,'FontSize',12);
set(ah,'TitleFontSizeMultiplier',1.2);
set(ah,'LineWidth',1);
axis equal
legend("Matlab","Arduino")
grid on
