%% Plot stuff
clear all; close all; clc

tic
N = 2E+06;
mean_x1_squared = zeros(1,2000000-1);
mean_y1_squared = zeros(1,2000000-1);
mean_z1_squared = zeros(1,2000000-1);
mean_x2_squared = zeros(1,2000000-2);
mean_y2_squared = zeros(1,2000000-2);
mean_z2_squared = zeros(1,2000000-2);
mean_x3_squared = zeros(1,1780000-2);
mean_y3_squared = zeros(1,1780000-2);
mean_z3_squared = zeros(1,1780000-2);
mean_x = zeros(1,2000000);
mean_y = zeros(1,2000000);
mean_z = zeros(1,2000000);
mean_r = zeros(1,2000000);
mean_x1 = zeros(1,2000000);
mean_y1 = zeros(1,2000000);
mean_z1 = zeros(1,2000000);

file_no_l = [301 302 303 304 305 307 308 309 311 312 313 314 315 316 328 329 330 331 332 333 334 335 336 337 339 341 344 356 357 359 360 362 363 364 365 367 368 369];
n_array = [file_no_l];
k = 0;
for j = 1:length(n_array)
    peter_text = sprintf('RW_CollR_40_AF_0_4_MR_8nm_no_%d_col_no1.mat',n_array(j));
    load(peter_text)

    for i = 2:size(X_V,2)
        mean_x_squared1(i-1) = mean((X_V(1,i)-(X_V(1,1))).^2,'omitnan');
        mean_y_squared1(i-1) = mean((Y_V(1,i)-(Y_V(1,1))).^2,'omitnan');
        mean_r_squared1(i-1) = sqrt(mean((X_V(:,i)-(X_V(:,1))),'omitnan').^2+mean((Y_V(:,i))-(Y_V(:,1)),'omitnan').^2);
        mean_z_squared1(i-1) = mean((Z_V(1,i)-(Z_V(1,1))).^2,'omitnan');
        %        disp(i)
    end

    for i = 2:(size(X_V2,2)-1)
        mean_x2_squared1(i-1) = mean((X_V2(1,i)-(X_V(1,1))).^2,'omitnan');
        mean_y2_squared1(i-1) = mean((Y_V2(1,i)-(Y_V(1,1))).^2,'omitnan');
        mean_r2_squared1(i-1) = sqrt(mean((X_V2(:,i)-((X_V(:,1)))),'omitnan').^2+mean((Y_V2(:,i))-(Y_V(:,1)),'omitnan').^2);
        mean_z2_squared1(i-1) = mean((Z_V2(1,i)-(Z_V(1,1))).^2,'omitnan');
        %        disp(i)
    end

    for i = 2:(size(X_V3,2)-1)
        mean_x3_squared1(i-1) = mean((X_V3(1,i)-(X_V(1,1))).^2,'omitnan');
        mean_y3_squared1(i-1) = mean((Y_V3(1,i)-(Y_V(1,1))).^2,'omitnan');
        mean_r3_squared1(i-1) = sqrt(mean((X_V3(:,i)-(X_V(:,1))),'omitnan').^2+mean((Y_V3(:,i))-(Y_V(:,1)),'omitnan').^2);
        mean_z3_squared1(i-1) = mean((Z_V3(1,i)-(Z_V(1,1))).^2,'omitnan');
        %        disp(i)
    end

    if (any(isnan(mean_x_squared1))|| any(isnan(mean_y_squared1))||any(isnan(mean_z_squared1))||any(isnan(mean_r_squared1)))

    else
        k = k+1;
        mean_x1_squared = mean_x1_squared + mean_x_squared1;
        mean_y1_squared = mean_y1_squared + mean_y_squared1;
        mean_z1_squared = mean_z1_squared + mean_z_squared1;

        mean_x2_squared = mean_x2_squared + mean_x2_squared1;
        mean_y2_squared = mean_y2_squared + mean_y2_squared1;
        mean_z2_squared = mean_z2_squared + mean_z2_squared1;

        mean_x3_squared = mean_x3_squared + mean_x3_squared1;
        mean_y3_squared = mean_y3_squared + mean_y3_squared1;
        mean_z3_squared = mean_z3_squared + mean_z3_squared1;
    end
    peter_name = sprintf('mean_results_8nm_no_%d.mat',j)
    save(peter_name,'mean_x1_squared','mean_y1_squared','mean_z1_squared','mean_x2_squared','mean_y2_squared','mean_z2_squared','mean_x3_squared','mean_y3_squared','mean_z3_squared');
    toc
end

mean_x1_squared = mean_x1_squared./j;
mean_y1_squared = mean_y1_squared./j;
mean_z1_squared = mean_z1_squared./j;

mean_x2_squared = mean_x2_squared./j;
mean_y2_squared = mean_y2_squared./j;
mean_z2_squared = mean_z2_squared./j;

mean_x3_squared = mean_x3_squared./j;
mean_y3_squared = mean_y3_squared./j;
mean_z3_squared = mean_z3_squared./j;

mean_x = mean_x./j;
mean_y = mean_y./j;
mean_z = mean_z./j;
%% Section for plotting

% load('results_file.mat')
dt = 1e-08;
time_array1 = dt:dt:(((2E+06-1)*dt));

time_array2 = ((2E+06)*dt):(10*dt):((((10*(2E+06)+(2E+06-21)))*dt));

time_array3 = (((10*(2E+06)+(2E+06-20)))*dt):(100*dt):(((100*(1.78E+06)+10*(2E+06)+(2E+06-300)))*dt);

figure (5)
loglog(time_array1,mean_x1_squared,'LineWidth',2)
hold on
loglog(time_array1,mean_y1_squared,'LineWidth',2)
hold on
loglog(time_array1,mean_z1_squared,'LineWidth',2)
hold on 
% loglog(time_array2,mean_x2_squared,'LineWidth',2)
% hold on
% loglog(time_array2,mean_y2_squared,'LineWidth',2)
% hold on
% loglog(time_array2,mean_z2_squared,'LineWidth',2)
% hold on
% loglog(time_array3,mean_x3_squared,'LineWidth',2)
% hold on
% loglog(time_array3,mean_y3_squared,'LineWidth',2)
% hold on
% loglog(time_array3,mean_z3_squared,'LineWidth',2)
set(gcf,'color','w')
xlabel('Characteristic diffusion time [s]')
ylabel('Mean squared displacement')
legend('X','Y','Z')
grid on
title('AF 0_4 Collagen Fibres')

% figure (6)
% loglog(time_array,mean_x,'LineWidth',2)
% hold on
% loglog(time_array,mean_y,'LineWidth',2)
% hold on
% loglog(time_array,mean_z,'LineWidth',2)
% hold on
% set(gcf,'color','w')
% xlabel('Characteristic diffusion time [s]')
% ylabel('Mean squared displacement')
% legend('X','Y','Z')
% grid on
% title('150 Collagen Fibres')

% save('results_file_disp_v2.mat','mean_x','mean_y','mean_z','mean_x_squared','mean_y_squared','mean_z_squared')
save('results_file_disp_v3.mat','mean_x1_squared','mean_y1_squared')
