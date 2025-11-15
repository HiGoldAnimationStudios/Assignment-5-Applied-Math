%create a struct containing plotting info for a single box
%INPUTS:
%box_params
function box_plot_struct = initialize_box_plot()
    box_plot_struct = struct();
    box_plot_struct.line_plot = plot(0,0,'k','linewidth',2);
    box_plot_struct.point_plot = plot(0,0,'ro','markerfacecolor','r','markersize',7);
end