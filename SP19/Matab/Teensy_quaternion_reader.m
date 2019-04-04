clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ DATA FROM TEENSY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup
% number of samples [q0,q1,q2,q3] to request from Teensy
% Max of ~3000 (Teensy doesn't have enough memory to save more)
numSamples = 3000; % 100 recommended
% number of times matlab requests additional data from the Teensy
numAquisitions = 1; % 50 is plenty
% initailize matrix to hold quaternion data
%load('Q.mat');
Q = zeros(numSamples*numAquisitions,4);
% four four-byte floats per sample
bytesPerSample = 16;

disp("Capturing IMU Motion... ");

%% Initialize Serial Port
% Modify first argument to match the Teensy port under Tools tab of Arduino IDE
% same baudrate as Teensy
s = serial('/dev/cu.usbmodem40133301','BaudRate',115200);
s.Timeout = 60;
set(s,'InputBufferSize',bytesPerSample*numSamples);

%% Read Data from IMU

for aquisition = 1:numAquisitions
    fopen(s);
    % send a dummy byte to tell the teeny it should start recording data
    fprintf(s,'%d',0);
    dat = fread(s,4*numSamples,'float');
    % read numSamples*4 floats from teensy (each sample includes q0, q1, q2 and q3  
    % dat holds the quaternion data in the form [q01,q11,q21,q32,q02,q12,q22,...]
    fclose(s);
    % format dat into Q
    % NEED TO EDIT
    for sample = 0:numSamples-1
        Q(((aquisition-1)*numSamples + sample+1),:) = dat(4*sample+1:4*sample+4);
    end
end
disp("Done");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT DATA AND SAVE TO VIDEO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Vectors to Plot
% global unit axes
x_g = [1,0,0];
y_g = [0,1,0];
z_g = [0,0,1];
% imu0 unit axes
X_imu0 = zeros(numSamples,3);
Y_imu0 = zeros(numSamples,3);
Z_imu0 = zeros(numSamples,3);
for t = 1:numSamples
    X_imu0(t,:) = rotate(Q(t,:),x_g);
    Y_imu0(t,:) = rotate(Q(t,:),y_g);
    Z_imu0(t,:) = rotate(Q(t,:),z_g);
end

g_offset = 0;
imu0_offset = 1;
sample_frequency = 100;
division = 5;

for t = 1:numSamples/division
    i = t*division;
    
    figure(1)
    hold on
    quiver3(g_offset,g_offset,g_offset,x_g(1),x_g(2),x_g(3),'r','LineWidth',3)
    quiver3(g_offset,g_offset,g_offset,y_g(1),y_g(2),y_g(3),'g','LineWidth',3)
    quiver3(g_offset,g_offset,g_offset,z_g(1),z_g(2),z_g(3),'b','LineWidth',3)
    quiver3(imu0_offset,imu0_offset,imu0_offset,...
        X_imu0(i,1),X_imu0(i,2),X_imu0(i,3),'r--','LineWidth',3)
    quiver3(imu0_offset,imu0_offset,imu0_offset,...
        Y_imu0(i,1),Y_imu0(i,2),Y_imu0(i,3),'g--','LineWidth',3)
    quiver3(imu0_offset,imu0_offset,imu0_offset,...
        Z_imu0(i,1),Z_imu0(i,2),Z_imu0(i,3),'b--','LineWidth',3)
    hold off
    
    ah = gca;
    title('Quaternion Visualizer');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal
    set(ah,'XLim',[-0.5,2]);
    set(ah,'YLim',[-0.5,2]);
    set(ah,'ZLim',[-0.5,2]);
    set(ah,'FontSize',14);
    set(ah,'TitleFontSizeMultiplier',1.2);
    set(ah,'LineWidth',2);
    grid on
    view(-70,20)
    
    Frame_Array(t) = getframe(gcf);
    drawnow
    clf
end

% create the video writer with 1 fps
writerObj = VideoWriter('quaternion_visualizer.avi');
writerObj.FrameRate = sample_frequency/division;
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:numSamples/division
    % convert the image to a frame
    frame = Frame_Array(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quaternion Helper Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function q_out = create_quaternion(theta,euler_axis)
% creates a quaternion from an angle of rotation and a euler axis
% normalize the euler axis
euler_axis = euler_axis/sqrt(sum(euler_axis.^2));
% initialize new quaternion
q_out = zeros(1,4);
% populate new quaternion
q_out(1) = cos(0.5*theta);
q_out(2) = sin(0.5*theta)*euler_axis(1);
q_out(3) = sin(0.5*theta)*euler_axis(2);
q_out(4) = sin(0.5*theta)*euler_axis(3);
end

function q_out = multiply(q1,q2)
% multiplies two quaternions *
q_out = zeros(1,4);
q_out(1) = q1(1)*q2(1) - q1(2)*q2(2) - q1(3)*q2(3) - q1(4)*q2(4);
q_out(2) = q1(1)*q2(2) + q1(2)*q2(1) + q1(3)*q2(4) - q1(4)*q2(3);
q_out(3) = q1(1)*q2(3) - q1(2)*q2(4) + q1(3)*q2(1) + q1(4)*q2(2);
q_out(4) = q1(1)*q2(4) + q1(2)*q2(3) - q1(3)*q2(2) + q1(4)*q2(1);
end

function q_out = conjugate(q_in)
% computes the conjugate of a quaternion *
q_out = [q_in(1),-q_in(2),-q_in(3),-q_in(4)];
end

function n = norm(q_in)
% computes the norm of the input quaternion *
n = sqrt(q_in(1)^2+q_in(2)^2+q_in(3)^2+q_in(4)^2);
end

function q_out = normalize(q_in)
% normailizes the input quaternion
q_out = q_in/norm(q_in);
end

function q_out = inverse(q_in)
% computes the inverse of the input quaternion
q_out = conjugate(q_in)/(norm(q_in))^2;
end

function theta = get_theta(q_in)
% computes the angle of rotation described by the input quaternion *
theta = 2*atan2(sqrt(q_in(2)^2+q_in(3)^2+q_in(4)^2),q_in(1));
end

function euler_axis = get_euler_axis(q_in)
% computes the euler axis described by the input quaternion *
euler_axis = q_in(2:4)/sqrt(q_in(2)^2+q_in(3)^2+q_in(4)^2);
end

function rotated_vector = rotate(q,vector)
% rotates a vector using the input quaternion
vector = [0,vector];
rotated_vector = multiply(multiply(q,vector),inverse(q));
rotated_vector = rotated_vector(2:4);
end




