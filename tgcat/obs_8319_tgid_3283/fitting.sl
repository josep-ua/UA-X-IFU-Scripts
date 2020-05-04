% We load isisscripts and tbnew simple model:
require("isisscripts.sl");

%Preparing Gratings Data for Fitting
capella=load_data("capella.pha2");

%We list all the layers of the spectre
list_all;


!ls -l
%we load the rmf and arf data
arfm1=load_arf("leg_-1.arf");
arfp1=load_arf("leg_1.arf");
rmfm1=load_rmf("leg_-1.rmf");
rmfp1=load_rmf("leg_1.rmf");

%We assign each file to the spectrum taken with this detector
assign_rmf(rmfm1,capella[2]);
assign_arf(arfm1,capella[2]);
assign_rmf(rmfp1,capella[3]);
assign_arf(arfp1,capella[3]);


%FIRST FIT
%we exclude all the layers of pha2 that we don't need
exclude(capella[0],capella[1],capella[4],capella[5]);

%spectra layers as a variables
m1=capella[2];
p1=capella[3];

%we plot the whole data set
fancy_plot_unit("A");
plot_data(p1;dsym=1,dcol=2);

% A Model is born
fit_fun("constant(1)+gauss(1)+gauss(2)+gauss(3)");
%He-like oxygen triplet
set_par(3,21.6);
set_par(4,0.025);
set_par(6,21.8);
set_par(7,0.025);
set_par(9,22.1);
set_par(10,0.025);

