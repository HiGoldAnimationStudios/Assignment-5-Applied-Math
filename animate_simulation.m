function animate_simulation(tlist, Vlist, box_params)
    mypath1 = 'C:\Users\jvidaurrazaga\Downloads\';
    fname='box_animation.mp4';
    input_fname = [mypath1,fname];
    writerObj = VideoWriter(input_fname);
    open(writerObj);
    fig1 = figure('color','w');


    
    axis equal; hold on;

    all_positions = Vlist(1:2,:);
    minx = min(all_positions(1,:)); 
    maxx = max(all_positions(1,:));
    miny = min(all_positions(2,:)); 
    maxy = max(all_positions(2,:));

    pad = 10;
    axis([minx-pad, maxx+pad, miny-pad, maxy+pad]);
    
    n = size(box_params.P_world,2);
    spring_structs = cell(1,n);
    num_zigs = 8;
    w = 0.3;
    for i = 1:n
        spring_structs{i} = initialize_spring_plot(num_zigs,w);
    end
    
    box = patch('XData',[], 'YData',[], 'FaceColor','none', 'EdgeColor','b', 'LineWidth', 1.8);
    
    plot(box_params.P_world(1,:), box_params.P_world(2,:), 'k.', 'MarkerSize', 12);
    
    N = length(tlist);
    for k = 1:N
        x = Vlist(1,k); y = Vlist(2,k); theta = Vlist(3,k);

        % compute current body points and boundary
        P_body_world = compute_rbt(x,y,theta,box_params.P_box);
        boundary_world = compute_rbt(x,y,theta,box_params.boundary_pts);
        set(box, 'XData', boundary_world(1,:), 'YData', boundary_world(2,:));

        % update springs
        for i = 1:n
            P1 = box_params.P_world(:,i);  
            P2 = P_body_world(:,i);                 
            update_spring_plot(spring_structs{i}, P1, P2);
        end

        title(sprintf('t = %.2f s', tlist(k)));
        drawnow;
        current_frame = getframe(fig1);
        %write the frame to the video
        writeVideo(writerObj,current_frame);
        pause(0.001);
    end

    close(writerObj);
end