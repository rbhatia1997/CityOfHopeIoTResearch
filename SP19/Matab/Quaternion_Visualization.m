clear
clf

%% Quaternion Visualization

% imu0 (this would be supplied by Mahony filter)
yaw_body = pi/3;
q1 = create_quaternion(yaw_body,[0,0,1]);
q2 = create_quaternion(pi/2,[0,-1,0]);
q_g_imu0 = multiply(q1,q2);

% imu1 (this would be supplied by Mahony filter)
yaw_imu1 = yaw_body-pi/2;
pitch_imu1 = pi/4;
q1 = create_quaternion(yaw_imu1,[0,0,1]);
q2 = create_quaternion(pitch_imu1,[0,1,0]);
q_g_imu1 = multiply(q1,q2);

% imu0 to body (we set this)
angle = pi/2;
q_imu0_b = create_quaternion(angle,[0,1,0]);
% global to body
q_g_b = multiply(q_g_imu0,q_imu0_b);

% body to imu1
q_b_imu1 = multiply(q_g_imu1,inverse(q_g_b));

% Vectors to Plot
% global unit axes
x_g = [1,0,0];
y_g = [0,1,0];
z_g = [0,0,1];
% imu0 unit axes
x_imu0 = rotate(q_g_imu0,x_g);
y_imu0 = rotate(q_g_imu0,y_g);
z_imu0 = rotate(q_g_imu0,z_g);
% imu1 unit axes
x_imu1 = rotate(q_g_imu1,x_g);
y_imu1 = rotate(q_g_imu1,y_g);
z_imu1 = rotate(q_g_imu1,z_g);
% body unit axes
x_b = rotate(q_g_b,x_g);
y_b = rotate(q_g_b,y_g);
z_b = rotate(q_g_b,z_g);
% imu1 unit axes from body
x_imu1_b = rotate(q_b_imu1,x_b);
y_imu1_b = rotate(q_b_imu1,y_b);
z_imu1_b = rotate(q_b_imu1,z_b);

g_offset = 0;
imu0_offset = 0.5;
body_offset = 1;
imu1_offset = 1.5;
imu1_b_offset = 2;



figure(1)
% Plot global frame
quiver3(g_offset,g_offset,g_offset,x_g(1),x_g(2),x_g(3),'r','LineWidth',3)
hold on
quiver3(g_offset,g_offset,g_offset,y_g(1),y_g(2),y_g(3),'g','LineWidth',3)
quiver3(g_offset,g_offset,g_offset,z_g(1),z_g(2),z_g(3),'b','LineWidth',3)
% Plot IMU0 frame
quiver3(imu0_offset,imu0_offset,imu0_offset,x_imu0(1),x_imu0(2),x_imu0(3),'r--','LineWidth',3)
quiver3(imu0_offset,imu0_offset,imu0_offset,y_imu0(1),y_imu0(2),y_imu0(3),'g--','LineWidth',3)
quiver3(imu0_offset,imu0_offset,imu0_offset,z_imu0(1),z_imu0(2),z_imu0(3),'b--','LineWidth',3)
% Plot IMU1 frame
quiver3(imu1_offset,imu1_offset,imu1_offset,x_imu1(1),x_imu1(2),x_imu1(3),'r--','LineWidth',3)
quiver3(imu1_offset,imu1_offset,imu1_offset,y_imu1(1),y_imu1(2),y_imu1(3),'g--','LineWidth',3)
quiver3(imu1_offset,imu1_offset,imu1_offset,z_imu1(1),z_imu1(2),z_imu1(3),'b--','LineWidth',3)
% Plot body frame
quiver3(body_offset,body_offset,body_offset,x_b(1),x_b(2),x_b(3),'r:','LineWidth',3)
quiver3(body_offset,body_offset,body_offset,y_b(1),y_b(2),y_b(3),'g:','LineWidth',3)
quiver3(body_offset,body_offset,body_offset,z_b(1),z_b(2),z_b(3),'b:','LineWidth',3)
% Plot IMU1 frame relative to body
quiver3(imu1_b_offset,imu1_b_offset,imu1_b_offset,x_imu1_b(1),x_imu1_b(2),x_imu1_b(3),'r--','LineWidth',3)
quiver3(imu1_b_offset,imu1_b_offset,imu1_b_offset,y_imu1_b(1),y_imu1_b(2),y_imu1_b(3),'g--','LineWidth',3)
quiver3(imu1_b_offset,imu1_b_offset,imu1_b_offset,z_imu1_b(1),z_imu1_b(2),z_imu1_b(3),'b--','LineWidth',3)
hold off

ah = gca;
title('Plot Title');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal
set(ah,'XLim',[-1,3.5]);
set(ah,'YLim',[-1,3.5]);
set(ah,'ZLim',[-0.5,3.5]);
set(ah,'FontSize',14);
set(ah,'TitleFontSizeMultiplier',1.2);
set(ah,'LineWidth',2);
%legend('Curve 1','Curve 2');

grid on


%% Quaternion Helper Functions

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




