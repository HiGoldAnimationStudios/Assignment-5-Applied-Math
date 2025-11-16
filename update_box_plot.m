function update_box_plot(box_plot_struct,box_params)
    plot_pts = box_params.P_box;
    set(box_plot_struct.line_plot,'xdata',plot_pts(1,:),'ydata',plot_pts(2,:));
    set(box_plot_struct.point_plot,'xdata',plot_pts(1,:),'ydata',plot_pts(2,:));
end