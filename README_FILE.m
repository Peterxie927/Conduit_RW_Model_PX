%% README File for the Antigen Random Walk Model
%% 1. Main File: 'rwmodelv7_AF_03.m' - Main code to run the ARW Model:
% with collisions incorporporated for:
% a) Antigen to Collagen
% b) Antigen to Conduit 
% c) Antigen to Antigen
% No need to handle antigen-antigen collisions.

%% 2. 'Dynamic_plotting_mean_displacement.m'- 
% Dynamically plot the mean squared displacement as a function of number of
% samples

%% 3. Generate collagen geometries. 'Generate_collagen_geometries_and_save.m' test file 
% Generate random collagen packing geometries for different area fraction
% values. RNG used.

%% 4. Post-Processing: Find the MSD trajectories for RW Model. 'Post_process_plot_displacement.m' test file 
% Post process the mean square displacement from individual trajectories
%% FUNCTIONS
% 1.'simulate_collagen.m' - Simulates random non-overlapping collagen fibres
% in the conduit 
% function [collagen,c] = simulate_collagen(D_f,N_f,D,x0,y0,L_conduit,plot_yes)

% 2.'simulate_antigen_initial.m' - Simulates random antigens in the conduit volume
% function [antigen,c] = simulate_antigen_initial(antigen_r,N_a,D,x0,y0,collagen,N_f,D_f,L_conduit,plot_yes)

% 3.'conduit_collision.m' - Handles the collision between antigens and
% the conduit surface.
% 'function [x_temp y_temp V_temp] = conduit_collision(x_temp,y_temp,x_p,y_p,D,antigen_r,r,vel_j)'

% 4.'intersect_line_cir.m' - Check if the antigen is going to collide with
%  any collagen fibres in teh conduit system
% function [flag_intersect_v] = intersect_line_cir(P1,P2,C,D_f,antigen_r)

% 5.'collagen_collision.m' - Handles collisions between antigens and the
% collagen fibres in the conduits.
% function [x_temp y_temp V_temp] = collagen_collision(x_temp,y_temp,x_p,y_p,coll_center,D_f,antigen_r,r,vel_j)

% 6. 'antigen_collision.m' - Handles collisions between antigens and each
% other. 
% function [p1_col p2_col p1_new p2_new v1_new v2_new] ..........
% = antigen_collision(pos1,pos2,v1,v2,antigen_r, dt)

% 7. 'circle3.m' - Plots circles in 2D plot given center and radius
% function h = circle3(x,y,r,color)

%% 
% 8. 'Generate_collagen_geometries_and_save.m' - Plots circles in 2D plot given center and radius
% function h = circle3(x,y,r,color)

