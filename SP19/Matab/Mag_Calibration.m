% Magnetometer Calibration
% author: Wilson Ives, wives@hmc.edu
% last edited: 2/7/19
%
% Instructions:
% 1. Make sure Mag_Calibration_MPU9250.ino is running of the Teensy
%    and the serial monitor is closed.
% 2. Once this script is run, magnetometer data will be collected
%    for approximately 50 seconds. During this time the IMU should
%    be rotated and tilted into as many orientations as possible.
% 3. Once the script has run three graphs will appear. The graph in
%    figure 1 plots the raw data sent from the IMU. It should appear
%    spherical but is usually not centered on the origin. The graph
%    in figure 2 plots the data claibrated using elipsoidal fitting
%    and a transformation matrix. The graph in figure 3 plots the 
%    data calibraied using a simpler method that simply calculates
%    the extremities of the raw data.The plots in figure 2 and 3
%    should resemble unit spheres.
% 4. In additon a offset vector and transformation matrix will be 
%    printed to the Command Window for each calibration method. These 
%    can be copied into the code to calibrate raw magnetometer data in 
%    real time.

clear
clf

%% Setup
% number of samples [mx,my,mz] to request from Teensy
% Max of ~4000 (Teensy doesn't have enough memory to save more)
numSamples = 10; % 100 recommended
% number of times matlab requests additional data from the Teensy
numAquisitions = 20; % 50 is plenty
% initailize vectors to hold magnetometer data
mx = zeros(numSamples*numAquisitions,1);
my = zeros(numSamples*numAquisitions,1);
mz = zeros(numSamples*numAquisitions,1);
% three four-byte floats per sample
bytesPerSample = 12; 
disp("Rotate IMU into as many orientations as possible")
string = strcat("This should take ~",num2str(numAquisitions)," seconds");
disp(string)

%% Initialize Serial Port
% Modify first argument to match the Teensy port under Tools tab of Arduino IDE
% same baudrate as Teensy
s = serial('/dev/cu.usbmodem40133301','BaudRate',115200);
set(s,'InputBufferSize',bytesPerSample*numSamples);

%% Read Data from IMU
for aquisition = 1:numAquisitions
    fopen(s);
    % request data from Teensy
    fprintf(s,'%d',numSamples);
    dat = fread(s,3*numSamples,'float');
    % read numSamples*3 floats from teensy (each sample includes mx, my, and mz  
    % dat holds the magnetometer data in the form [mx1,my1,mz1,mx2,my2,mz2,...]
    fclose(s);
    % seperate dat into mx, my, and mz vectors
    for sample = 0:numSamples-1
        mx((aquisition-1)*numSamples + sample+1) = dat(3*sample+1);
        my((aquisition-1)*numSamples + sample+1) = dat(3*sample+2);
        mz((aquisition-1)*numSamples + sample+1) = dat(3*sample+3);
    end
end

%% Plot Raw Data
max_mx = max(mx); min_mx = min(mx);
max_my = max(my); min_my = min(my);
max_mz = max(mz); min_mz = min(mz);

figure(1)
scatter3(mx,my,mz,'b.');
ah = gca;
title('Raw Magnetometer Data');
xlabel('X Magnetic Flux [uT]');
ylabel('Y Magnetic Flux [uT]');
zlabel('Z Magnetic Flux [uT]');
set(ah,'FontSize',12);
set(ah,'TitleFontSizeMultiplier',1.2);
set(ah,'LineWidth',1);
axis equal
grid on

%% Method #1:
% Calculate Offsets and Soft Iron Matrix Using Elipsoidal Fitting
M = [mx,my,mz];
[U1,c1] = MgnCalibration(M);

% Calibrate data


%% Method #2:
% Perform Simple Calibration Technique
throwout_num = 3;
averaging_range = 10;
% sort raw magnetometer measurements for each axis
mx_sorted = sort(mx);
my_sorted = sort(my);
mz_sorted = sort(mz);
% calculate extremities
mx_pos = sum(mx_sorted(end-throwout_num-averaging_range+1:end-throwout_num))/averaging_range;
my_pos = sum(my_sorted(end-throwout_num-averaging_range+1:end-throwout_num))/averaging_range;
mz_pos = sum(mz_sorted(end-throwout_num-averaging_range+1:end-throwout_num))/averaging_range;
mx_neg = sum(mx_sorted(1+throwout_num:1+throwout_num+averaging_range-1))/averaging_range;
my_neg = sum(my_sorted(1+throwout_num:1+throwout_num+averaging_range-1))/averaging_range;
mz_neg = sum(mz_sorted(1+throwout_num:1+throwout_num+averaging_range-1))/averaging_range;
% calculate offsets and scalings
x_offest = 0.5*(mx_pos+mx_neg);
y_offest = 0.5*(my_pos+my_neg);
z_offest = 0.5*(mz_pos+mz_neg);
x_scaling = 2/(mx_pos-mx_neg);
y_scaling = 2/(my_pos-my_neg);
z_scaling = 2/(mz_pos-mz_neg);
c2 = [x_offest,y_offest,z_offest]';
U2 = [x_scaling,0,0;
      0,y_scaling,0;
      0,0,z_scaling];

%% Compute Calibrated Data from each method
% method 1
M_cal1=(U1*(M'-repmat(c1,1,numSamples*numAquisitions)))';
mx_cal1 = M_cal1(:,1)';
my_cal1 = M_cal1(:,2)';
mz_cal1 = M_cal1(:,3)';
% method 2
M_cal2=(U2*(M'-repmat(c2,1,numSamples*numAquisitions)))';
mx_cal2 = M_cal2(:,1)';
my_cal2 = M_cal2(:,2)';
mz_cal2 = M_cal2(:,3)';


%% Plot Calibrated Data
max_mx_cal1 = max(mx_cal1); min_mx_cal1 = min(mx_cal1);
max_my_cal1 = max(my_cal1); min_my_cal1 = min(my_cal1);
max_mz_cal1 = max(mz_cal1); min_mz_cal1 = min(mz_cal1);

max_mx_cal2 = max(mx_cal2); min_mx_cal2 = min(mx_cal2);
max_my_cal2 = max(my_cal2); min_my_cal2 = min(my_cal2);
max_mz_cal2 = max(mz_cal2); min_mz_cal2 = min(mz_cal2);

figure(2)
plot3([min_mx_cal1,max_mx_cal1],[0,0],[0,0],'r-','LineWidth',2);
hold on
plot3([0,0],[min_my_cal1,max_my_cal1],[0,0],'r-','LineWidth',2);
plot3([0,0],[0,0],[min_mz_cal1,max_mz_cal1],'r-','LineWidth',2);
sh1 = scatter3(mx_cal1,my_cal1,mz_cal1,'b.');
ah = gca;
title('Calibrated Magnetometer Data (Method #1)');
xlabel('X Magnetic Flux [Normalized]');
ylabel('Y Magnetic Flux [Normalized]');
zlabel('Z Magnetic Flux [Normalized]');
set(ah,'FontSize',12);
set(ah,'TitleFontSizeMultiplier',1.2);
set(ah,'LineWidth',1);
axis equal
grid on

figure(3)
plot3([min_mx_cal2,max_mx_cal2],[0,0],[0,0],'r-','LineWidth',2);
hold on
plot3([0,0],[min_my_cal2,max_my_cal2],[0,0],'r-','LineWidth',2);
plot3([0,0],[0,0],[min_mz_cal2,max_mz_cal2],'r-','LineWidth',2);
sh1 = scatter3(mx_cal2,my_cal2,mz_cal2,'b.');
ah = gca;
title('Calibrated Magnetometer Data (Method #2)');
xlabel('X Magnetic Flux [Normalized]');
ylabel('Y Magnetic Flux [Normalized]');
zlabel('Z Magnetic Flux [Normalized]');
set(ah,'FontSize',12);
set(ah,'TitleFontSizeMultiplier',1.2);
set(ah,'LineWidth',1);
axis equal
grid on


%% Display Offset Vectors and Soft Iron Compensation Matrices
disp("//////////////////////////////////////////////////////")
disp("Method #1: Eliptical Surface Fitting")
disp("//////////////////////////////////////////////////////")
disp('Offet Vector:')
disp(c1)
disp('Soft Iron Compensation Matrix:')
disp(U1);

disp("//////////////////////////////////////////////////////")
disp("Method #2: Simple Scaling")
disp("//////////////////////////////////////////////////////")
disp('Offet Vector:')
disp(c2)
disp('Soft Iron Compensation Matrix:')
disp(U2);


%% Helper Functions for Eliptical Surface Fitting

function [U,c] = MgnCalibration(X)
% performs magnetometer calibration from a set of data
% using Merayo technique with a non iterative algoritm
% J.Merayo et al. "Scalar calibration of vector magnemoters"
% Meas. Sci. Technol. 11 (2000) 120-132.
%
%   X      : a Nx3 (or 3xN) data matrix
%              each row (columns) contains x, y, z measurements
%              N must be such that the data set describes
%              as completely as possible the 3D space
%              In any case N > 10
%              
%    The calibration tries to find the best 3D ellipsoid that fits the data set
%    and returns the parameters of this ellipsoid
%
%    U     :  shape ellipsoid parameter, (3x3) upper triangular matrix
%    c      : ellipsoid center, (3x1) vector
%
%    Ellipsoid equation : (v-c)'*(U'*U)(v-c) = 1 
%    with v a rough triaxes magnetometer  measurement
%
%    calibrated measurement w = U*(v-c)
%
%   author : Alain Barraud, Suzanne Lesecq 2008
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[N,m] = size(X);
if m>3&&N==3,X = X';N = m;m = 3;end %check that X is not transposed
if N<=10,U = [];c = [];return;end %not enough data no calibration !!
% write  the ellipsoid equation as D*p=0
% the best parameter is the solution of min||D*p|| with ||p||=1;
% form D matrix from X measurements
x = X(:,1); y = X(:,2); z = X(:,3); 
D = [x.^2, y.^2, z.^2, x.*y, x.*z, y.*z, x, y, z, ones(N,1)];
D=triu(qr(D));%avoids to compute the svd of a large matrix
[U,S,V] = svd(D);%because usually N may be very large
p = V(:,end);if p(1)<0,p =-p;end
% the following matrix A(p) must be positive definite
% The optimization done by svd does not include such a constraint
% With "good" data the constraint is allways satisfied
% With too poor data A may fail to be positive definite
% In this case the calibration fails
%
A = [p(1) p(4)/2 p(5)/2;
       p(4)/2 p(2) p(6)/2; 
       p(5)/2 p(6)/2 p(3)];
[U,ok] = fchol(m,A);
if ~ok,U = [];c = [];return;end %calibration fails too poor data!!
b = [p(7);p(8);p(9)];
v = Utsolve(U,b/2,m);
d = p(10);
s = 1/sqrt(v*v'-d);
c =-Usolve(U,v,m)';%ellipsoid center
U = s*U;%shape ellipsoid parameter
end

function [A,ok] = fchol(n,A)
% performs Cholesky factoristation
A(1,1:n) = A(1,1:n)/sqrt(A(1,1));
A(2:n,1) = 0;
for j=2:n
  A(j,j:n) = A(j,j:n) - A(1:j-1,j)'*A(1:j-1,j:n);
  if A(j,j)<=0,ok=0;break;end%A is not positive definite
  A(j,j:n) = A(j,j:n)/sqrt(A(j,j));
  A(j+1:n,j) = 0;
end
ok=1;
end

function x=Utsolve(U,b,n)
% solves U'*x=b
x(1) = b(1)/U(1,1);
for k=2:n
    x(k) = (b(k)-x(1:k-1)*U(1:k-1,k))/U(k,k);
end
end

function x=Usolve(U,b,n)
% solves U*x=b
x(n) = b(n)/U(n,n);
for k=n-1:-1:1
    x(k) = (b(k)-U(k,k+1:n)*x(k+1:n)')/U(k,k);
end
end

   


