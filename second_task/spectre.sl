%ALIAS

alias("plot_data_counts", "pdc");
alias("oplot_model_counts", "opmc");

dat=load_data("spectrum_hires_cluster_src.fits");
()=load_arf("pn10.arf");
()=load_rmf("pn10.rmf");
assign_arf(1,1);
assign_rmf(1,1);

%PLOTTING
variable id=open_plot ("spectrum_hires_cluster_src.fits");
resize(15);
xlog; ylog;
plot_data({dat});
close_plot(id);