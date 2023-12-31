%% Random Walk Model
%% Parallel Computing Commands
delete(gcp('nocreate'));
poolobj = parpool;
fprintf('Number of workers: %g\n', poolobj.NumWorkers);
index = index; % Index is for the random collagen packing geometry (e.g. 1 to 10 random geometries of AF = 0.3)
data_no = index;
%% Physical Parameters
input_data_name = sprintf('input_data_AF_0_3_filev2_%d.mat',data_no);
load(input_data_name); % Load Collagen Geometry
N_a = 600; % Number of Antigens to simulate
file_name = sprintf('Results_AF_0_3_filev2_%d',data_no);
mkdir(file_name) % Initialize a folder to store individual trajectories
%% Main Random Walk Loop
parfor j = 1:N_a        % parfor loop for the number of antigens
    in_collagen = 1; out_conduit = 1; nn_temp = 0; c_index = []; Point = [];
    no_collagen = size(collagen,1); % number of collagen fibres
    antigen_r_v = flip([1E-09 2E-09 4E-09 8E-09 12E-09 20E-09]); % antigen sizes studied
    antigen_r = antigen_r_v(ceil(j/100));
    Diff=(kb*T)/(6*pi*mu*antigen_r); % [m^2/s] Antigen diffusivity: Stokes-Einstein diffusivity
    dt = 1E-08; % [s] time-step. Implement adaptive time-stepping?
    % dt_v = [5E-08+zeros(1,N/4) 5E-08+zeros(1,N/4) 5E-08+zeros(1,N/4) 5E-08+zeros(1,N/4)];
    t_end = sum(dt*(N+1));
    r = sqrt(Diff*6*dt); % [m] displacement for 3d random walk calculated by Stokes-Einstein
    r_copy = []; r_copy2 = []; % [] 2D distances
    peter = 0;  peter5 = 0; peter6 = 0; % debugging counters
    flag = 1; % flag alerts the occurance of invalid numbers
    p1 = 0; p3 = 0; p4 = 0; p5 = 0; p6 = 0; p7 = 0; p8 = 0; p9 = 0; % counters
    [antigen,N2] = simulate_antigen_initial(antigen_r,1,D,x0,y0,collagen,N_f,D_f+D_e,L_conduit,plot_yes); % Simulate initial antigens
    % set the velocity to be dependent on the current time step (as dt
    % changes over the simulation).
    vel_x = (r/sqrt(3)).*randn([1,N]); % [m] random velocities in x,y,z - normally distributed random number generator
    vel_y = (r/sqrt(3)).*randn([1,N]);
    vel_z = (r/sqrt(3)).*randn([1,N]);
    vel_x(vel_x>=(10*(r/sqrt(3)))) = (10*(r/sqrt(3))); % set a simulated distance threshold for extreme values (10 standard deviations - extremely unlikely anyways)
    vel_y(vel_y>=(10*(r/sqrt(3)))) = (10*(r/sqrt(3)));
    vel_z(vel_z>=(10*(r/sqrt(3)))) = (10*(r/sqrt(3)));
    X_V = zeros(1,size_1); X_V2 = zeros(1,size_2); X_V3 = zeros(1,size_3);
    Y_V = zeros(1,size_1); Y_V2 = zeros(1,size_2); Y_V3 = zeros(1,size_3);
    Z_V = zeros(1,size_1); Z_V2 = zeros(1,size_2); Z_V3 = zeros(1,size_3);
    X_V(1,1) = antigen(1,1);  % Set 1st X_V, Y_V, Z_V to initial position of antigen simulated
    Y_V(1,1) = antigen(1,2);
    Z_V(1,1) = antigen(1,3);
    for i = 2:N+1 %% Main Time Stepping Loop
        V = [vel_x(1,i-1) vel_y(1,i-1) vel_z(1,i-1)];
        antigen_prev = antigen(1,:); antigen_prev2 = antigen(1,:); % antigen_prev2 stores the previous position of the molecule (i-1 position)
        antigen(1,:) = antigen(1,:) + V(1,:); % update position of antigen
        x_temp = antigen(1,1);
        y_temp = antigen(1,2);
        z_temp = antigen(1,3);
        xy_r = sqrt(x_temp^2+y_temp^2);
        Point = antigen_prev2(1,1:2);
        while (in_collagen == 1) || (out_conduit == 1) % Check if (A) molecule position is in collagen fibres OR (B) molecule position is exiting conduit border
            % Conduit Collisions
            if (xy_r)>((D/2)-(antigen_r))
                [x_temp, y_temp, v_temp, Point] = conduit_collision(antigen(1,1),antigen(1,2),antigen_prev(1),antigen_prev(2),D,antigen_r,norm(V(1,1:2)),V(1,1:2));
                antigen(1,1) = x_temp;
                antigen(1,2) = y_temp;
                antigen_prev(1,1:2) = Point;
                V(1,1:2) = v_temp;
                out_conduit = 0; % in_collagen = 1;
            else
                out_conduit = 0;
            end
            % Collagen Collisions
            nn= zeros(1,N_f);nn2 = zeros(1,N_f); % antigen_array = zeros(N_f,2)+antigen(1,1:2);
            k = 1:N_f;
            while (in_collagen == 1)
                nn(k) = sqrt(((antigen(1,1) - collagen(k,1)).^2)+((antigen(1,2) - collagen(k,2)).^2));
                for k2=1:N_f % locate collagen index in collision
                    if nn(1,k2) < (((D_f+D_e)/2)+antigen_r)
                        p5 = p5+1;
                        c_index(p5) = k2;
                        [nn_temp nn_ind] = min(nn(c_index));
                        nn_temp = c_index(nn_ind);
                    end
                end
                r_copy = norm(V(1,1:2));
                while (flag ~= 0)&&(p5 ~=0) % (A) Check for no NaN and (B) p5 is non-zero if molecule is colliding with collagen fibres
                    % execute molecule-collagen collision function
                    [x_temp2, y_temp2, flag, r_copy2, Point] = collagen_collision(antigen(1,1),antigen(1,2),antigen_prev,collagen(nn_temp,:),D_f+D_e,antigen_r,r_copy);
                    if flag == 1 % if NaN is encountered (only occurs with extremely packed collagen geometries)
                        antigen_prev(1,1) = x_temp2;
                        antigen_prev(1,2) = y_temp2;
                        V(1,1:2) = (r_copy/sqrt(3)).*randn([1,2]); % Re-simulate XY velocity of particle
                        antigen(1,1:2) = antigen_prev(1:2) + V(1,1:2); % Re-update antigen position
                        p1 = p1+1;
                    else
                        antigen_prev(1,1:2) = Point; % Store molecule position at the collision point
                        p7 = p7+1;
                        antigen(1,1:2) = [x_temp2 y_temp2]; % update position of molecule
                        V(1,1:3) = antigen-antigen_prev;
                        r_copy = r_copy2; % r_copy2 stores the reflected distance (distance travelled by molecule post-collision)
                        flag = 0;
                    end
                end
                p3 = p3+1; in_collagen=1; collagen_sum = collagen_sum+in_collagen;
                nn(k) = sqrt(((antigen(1,1)-collagen(k,1)).^2)+((antigen(1,2)-collagen(k,2)).^2));
                if sum(nn(1,:)<((((D_f+D_e)/2)+antigen_r)) == 0) % check again if the molecule has collided with collagen fibres
                    in_collagen = 0;
                    peter5 = peter5+1;
                else
                    in_collagen = 1;
                    peter6 = peter6+1;
                end
                p5 = 0; c_index = 0; flag = 1; nn_temp = 0;
            end
            xy_r = sqrt(antigen(1,1)^2+antigen(1,2)^2);
            if (xy_r)>((D/2)-(antigen_r)) % re-check if the molecule is leaving the conduit border
                out_conduit = 1;
            end
        end

        if isnan(x_temp) || isnan(y_temp)
            antigen(1,1) = antigen_prev2(1); antigen(1,2) = antigen_prev2(2);
            x_temp = antigen_prev2(1); y_temp = antigen_prev2(2);
            p6 = p6+1;
        end

        if ((sqrt((antigen(1,1) - antigen_prev2(1,1))^2+(antigen(1,2) - antigen_prev2(1,2))^2))>(3*sqrt(vel_x(1,i-1)^2+vel_y(1,i-1)^2)))
            antigen(1,1) = antigen_prev2(1); antigen(1,2) = antigen_prev2(2);
            x_temp = antigen_prev2(1); y_temp = antigen_prev2(2);
            p4 = p4+1; vel_x(1,i-1) = (r/sqrt(3)).*randn([1,1]); vel_y(1,i-1) = (r/sqrt(3)).*randn([1,1]);
        end

        %% Save particle positions. X_V array stores particle position from time scale of 0 to 0.002s. X_V2 array stores particle position from time scale of 0.02s to 0.22s X_V3 array stores particle position from time scale of 0.22s to 2s
        if i <= size_1
            X_V(1,i) = antigen(1,1);
            Y_V(1,i) = antigen(1,2);
            Z_V(1,i) = antigen(1,3);
        elseif (i>size_1)&&(i<=(10*size_2+size_1))&&(rem(i,10)==0)
            p8 = p8+1;
            X_V2(1,p8) = antigen(1,1);
            Y_V2(1,p8) = antigen(1,2);
            Z_V2(1,p8) = antigen(1,3);
        elseif (i>(10*size_2+size_1))&&(i<=((100*size_3+10*size_2+size_1)))&&(rem(i,100)==0)
            p9 = p9+1;
            X_V3(1,p9) = antigen(1,1);
            Y_V3(1,p9) = antigen(1,2);
            Z_V3(1,p9) = antigen(1,3);
        end

        if rem(i,1E+06) ==0
            t = (i)*dt;
            disp(t)
        end
        in_collagen = 1; second_check = 0; flag = 1; out_conduit = 1;
    end % loop for number of random walks
    str = string(antigen_r*10^(9))
    str2 = strrep(str,'.','_')
    peter_save_string = sprintf('./%s/RW_CollR_40_AF_0_3_MR_%snm_no_%d_col_no%d.mat',file_name,str2,j,index)
    parsave(peter_save_string, X_V,Y_V,Z_V,X_V2,Y_V2,Z_V2,X_V3,Y_V3,Z_V3,dt,N,antigen_r,p4,p6,peter6,collagen,D,D_f);
    X_V = zeros(1,size_1); X_V2 = zeros(1,size_2); X_V3 = zeros(1,size_3);
    Y_V = zeros(1,size_1); Y_V2 = zeros(1,size_2); Y_V3 = zeros(1,size_3);
    Z_V = zeros(1,size_1); Z_V2 = zeros(1,size_2); Z_V3 = zeros(1,size_3);
    vel_x = zeros(1,size_1);
    vel_y = zeros(1,size_1);
    vel_z = zeros(1,size_1);
    log_msg = sprintf('Simulation for antigen %d is complete',j);
    disp(log_msg)
end  % loop for number antigens


