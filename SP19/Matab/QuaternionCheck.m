%% global variables/start up
    close all 
    numSamples = 1;


% constant +90deg rotation around y to get to human body frame
%     yaw = 0; 
%     pitch = pi; 
%     roll = 0;
    % q_I0_B = angle2quat(yaw, pitch, roll);
    theta = pi;
    q_I0_B = [cos(theta/2) 0 sin(theta/2) 0];
% %     q_I0_B = [1/sqrt(2) 0 1/sqrt(2) 0];

%% input 

%IMU0 current orientation 
%IMU0 is on the back and defines the body frame
yaw_I0 = 0; 
pitch_I0 = -pi/2; 
roll_I0 = 0;
q_G_I0 = angle2quat(yaw_I0, pitch_I0, roll_I0,'ZYX');
%will be input quaternion from IMU
% q_G_I0 = ones(4,numSamples) %large input vector 

%applying constant offset to rotate IMUO(body') to body frame
%qGB = qG_I0*(q_IO_B)^1 
q_G_B = quatmultiply(q_G_I0,quatinv(q_I0_B));
[yaw_B, pitch_B, roll_B] = quat2angle(q_G_B,'ZYX');


%define default base vectors 
%padded with zero on top to multiply by quat
global_xyz = [ 0 0 0; 
               1 0 0;
               0 1 0;
               0 0 1];
           
% imu_xyz = [ 0 0 0;
%            1 0 0;
%            0 1 0;
%                0 0 1];
        
vb = ones(4,3);


%apply transform 
%vb = q_G_B * v_IMU0 * (q_G_B)^-1
for i = 1:3
    basesxyz_IMU0(:,i) = quatmultiply(quatmultiply(q_G_I0,global_xyz(:,i)'),quatinv(q_G_I0));
    vb(:,i) = quatmultiply(quatmultiply(q_G_B,basesxyz_IMU0(:,i)'),quatinv(q_G_B));
    
end

%set quaternion to identity for testing
% q_G_B = [1 0 0 0];
%% visualize transformation
%need to draw each axis by itself

%first for loop only draws global axis 
global_pt = [ 0 0 0];
for i=1:3 
    global_h = quiver3(global_pt(1),global_pt(2),global_pt(3),global_xyz(2,i),global_xyz(3,i),global_xyz(4,i));

    if(i == 1)
        global_h.Color = 'red';
    end
    if(i == 2)
        global_h.Color = 'blue';
    end
    if(i == 3)
        global_h.Color = 'green';
    end

    global_h.LineWidth = 2;
    drawnow
    hold on

end

%%%%%%%
pause
%%%%%%

%draws the raw input from IMU1 --UNTRANSFORMED
imu_pt = [0.5 0.5 0.5];
for j = 1:numSamples

    for i = 1:3

        h = quiver3(imu_pt(1),imu_pt(2),imu_pt(3),basesxyz_IMU0(2,i),basesxyz_IMU0(3,i),basesxyz_IMU0(4,i));

        %color the lines     
        if(i == 1)
            h.Color = 'red';
        end
        if(i == 2)
            h.Color = 'blue';
        end
        if(i == 3)
            h.Color = 'green';
        end
        h.LineWidth = 2;

        drawnow
        hold on 
    end
end



%%%%%%%
pause
%%%%%%

%draw the transformed axis 
trans_pt = [0.25 0.25 0.25];
imu_pt = [0.5 0.5 0.5];
for j = 1:numSamples
    for i=1:3 
        h2 = quiver3(trans_pt(1),trans_pt(2),trans_pt(3),vb(2,i),vb(3,i),vb(4,i));
        h2.LineStyle = '-.';
        if(i == 1)
            h2.Color = 'red';
        end
        if(i == 2)
            h2.Color = 'blue';
        end
        if(i == 3)
            h2.Color = 'green';
        end
        h2.LineWidth = 2;

        drawnow
        hold on 
    end
end

legend('global_X','global_Y','global_Z','raw_imu_X','raw_imu_Y','raw_imu_Z','tran_imu_X','tran_imu_Y','tran_imu_Z');
hold off

%% transforming IMU data with reference to body frame

%transform q_GI to qBI
%IMU1 current orientation
yaw_I1 = -pi/2; 
pitch_I1 = 0; 
roll_I1 = 0;
q_G_I1  = angle2quat(yaw_I1, pitch_I1, roll_I1,'ZYX');
q_B_I1 = quatmultiply(quatinv(q_G_B),q_G_I1);

%apply transform 
%xyz base vectors to describe IMU1 current orienation
%vI1_G = q_G_I1 * global_xyz * (q_G_I1)^-1
for i = 1:3
    basexyz_I1(:,i) = quatmultiply(quatmultiply(q_G_I1,global_xyz(:,i)'),quatinv(q_G_I1));
    basexyz_I1_test(:,i) =quatmultiply(quatmultiply(q_B_I1,(quatmultiply(quatmultiply(q_G_B,global_xyz(:,i)'),quatinv(q_G_B)))),quatinv(q_B_I1));
end




