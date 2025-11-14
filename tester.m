function tester()
    LW = 10; LH = 1; LG = 3;
    m = 1; Ic = (1/12)*(LH^2+LW^2);
    g = 1; k = 20; k_list = [.5*k,.5*k,2*k,5*k];
    l0 = 1.5*LG;
    Pbl_box = [-LW;-LH]/2;
    Pbr_box = [LW;-LH]/2;
    Ptl_box = [-LW;LH]/2;
    Ptr_box = [LW;LH]/2;
    boundary_pts = [Pbl_box,Pbr_box,Ptr_box,Ptl_box,Pbl_box];
    Pbl1_world = Pbl_box + [-LG;-LG];
    Pbl2_world = Pbl_box + [LG;-LG];
    Pbr1_world = Pbr_box + [0;-l0];
    Pbr2_world = Pbr_box + [l0;0];
    P_world = [Pbl1_world,Pbl2_world,Pbr1_world,Pbr2_world];
    P_box = [Pbl_box,Pbl_box,Pbr_box,Pbr_box];
    %define system parameters
    box_params = struct();
    box_params.m = m;
    box_params.I = Ic;
    box_params.g = g;
    box_params.k_list = k_list;
    box_params.l0_list = l0*ones(size(P_world,2));
    box_params.P_world = P_world;
    box_params.P_box = P_box;
    box_params.boundary_pts = boundary_pts;

    Fehlberg = struct();
    Fehlberg.C = [0, 1/4, 3/8, 12/13, 1, 1/2];
    Fehlberg.B = [16/135, 0, 6656/12825, 28561/56430, -9/50, 2/55;...
    25/216, 0, 1408/2565, 2197/4104, -1/5, 0];
    Fehlberg.A = [0,0,0,0,0,0;...
    1/4, 0,0,0,0,0;...
    3/32, 9/32, 0,0,0,0;...
    1932/2197, -7200/2197, 7296/2197, 0,0,0;...
    439/216, -8, 3680/513, -845/4104, 0,0;...
    -8/27, 2, -3544/2565, 1859/4104, -11/40, 0];
    h_ref = 2.8;
    error_desired = 10^-6;
    p=5;

    %load the system parameters into the rate function
    %via an anonymous function
    my_rate_func = @(t_in,V_in) box_rate_func(t_in,V_in,box_params);

    x0 =1;       %your code here
    y0 =2;       %your code here
    theta0 = 10;   %your code here
    vx0 = 3;      %your code here
    vy0 = 2;     %your code here
    vtheta0 = 1;   %your code here
    V0 = [x0;y0;theta0;vx0;vy0;vtheta0];
    tspan = [0 10];    %your code here

    solver_params=struct();
    solver_params.dx_tol=1e-14;
    
    [Veq,~,~] = multi_newton_solver_generalized(my_rate_func,V0,solver_params);
    
    
    dx0 = 1%your code here
    dy0 = 1%your code here
    dtheta0 = 1%your code here
    vx0 = 1%your code here
    vy0 = 1%your code here
    vtheta0 = 1%your code here
    %small number used to scale initial perturbation
    epsilon =1 %your code here
    V0 = Veq + epsilon*[dx0;dy0;dtheta0;vx0;vy0;vtheta0];
    tspan = [0 10]; %your code here
    %run the integration of nonlinear system
    % [tlist_nonlinear,Vlist_nonlinear] =...
    % your_integrator(my_rate_func,tspan,V0,...);
    %run the integration of linear system
    % [tlist_linear,Vlist_linear] =...
    % your_integrator(my_linear_rate,tspan,V0,...);

    %run the integration
    [t_list,X_list,h_avg, num_evals, fail_rate, h_rec] = explicit_RK_variable_step_integration(my_rate_func,tspan,V0,h_ref,Fehlberg, p, error_desired);
    size(X_list)
end