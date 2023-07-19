%% Generate Random Collagen geometries and save the parameters into the HPC loop
clear all
close all
clc

%% Physical Parameters
Area_frac = 0.3;
no_geometries = 6;
for p = 6:no_geometries
    plot_yes = 1;
    D = 1E-06; % [m] Diameter of Conduit System
    D_f = 40E-09; % [m] Diameter of Collagen Fibres  2nd Option: D_f = 80E-09; 
    D_e = 0.2E-09; 
    N_f = ceil((Area_frac*(pi*(D/2)^2))/(pi*(D_f/2)^2)); % [] Number of Collagen fibres
    T = 298; % [K] Temperature
    x0 = 0; % [m] Center of the conduit in the x direction.
    y0 = 0; % [m] Center of the conduit in the y direction.
    kb = 1.38E-23; % [J/K] Boltzmann's constant
    mu = 20e-4; % [Pas] Lymph Fluid viscosity [Pas]
    antigen_r = 4E-09; % [m] Antigen/Chemokine hydrodynamic radius (Limit of the conduit system)
    Diff=(kb*T)/(6*pi*mu*antigen_r); % [m^2/s] Antigen diffusivity
    avogadro_no = 6.02*10^(23); % [ ] Avogadro's Number
    L_conduit = 1E-06; % [m] Length of Conduit (assuming straight cylinder)

       %% Display conduit figure.
    [X,Y,Z] = cylinder(D/2,100);
    h = L_conduit;
    if (plot_yes ==1)
        figure (1)
        circle3(x0,y0,D/2,'k',0);
        xlabel('X(m)');
        ylabel('Y(m)');grid on; box on;
        axis equal;
        xlim([-5E-07 5E-07]); xticks(-5E-07:1E-07:5E-07);
        ylim([-5E-07 5E-07]); yticks(-5E-07:1E-07:5E-07);
        set(gcf,'color','w')
        hold on
    end

    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    box off
    set(gca,'Visible','off')
    
    [collagen,N_f2] = simulate_collagen_plot(D_f,N_f,D,x0,y0,L_conduit,plot_yes); % Assemble Conduit Model, add in Collagen

    %% Randomly simulate Antigens/Chemokines to start
    Ava = 6.022*10^(23); % [ ] Avogadro's Constant
    N_a = 1000; % [ ] Number of Antigens simulated

    %% Random Walk Simulation Parameters
    N = 2.00E+8; % [ ] number of random walks
    t = 0; n = 1; % [ ] initialize time and walk indices
    dt = 1E-08; % [s] time-step. Implement adaptive time-stepping? Let dt be small at the start,
    % and then dt can increase later on in the simulation.
    r = sqrt(Diff*6*dt); % [m] displacement for 2d random walk
    r_copy = r;
    debug_1 = 0;
    vel_x = zeros(1,N); vel_y = zeros(1,N); vel_z = zeros(1,N);
    V_initial = [vel_x(:,1) vel_y(:,1) vel_z(:,1)];
    size_3 = 1.78E+06; size_2 = 2E+06; size_1 = 2E+06;
    in_collagen = 1; collagen_sum = 0;

    str = string(Area_frac)
    str2 = strrep(str,'.','_')

    [antigen,N2] = simulate_antigen_initial_plot(antigen_r,N_a,D,x0,y0,collagen,N_f,D_f+D_e,L_conduit,plot_yes); % Simulate initial antigens

    % save_name = sprintf('input_data_AF_%s_filev3_%d.mat',str2,p)
    % save(save_name)
end