%%%%%%%%%%%%%%%%%%%%%%%% ADVANCED FITTING TECHS %%%%%%%%%%%%%%%%%
% 1) REBINNING DATA
% 2) FITTING DATA FROM MULTIPLE INSTRUMENTS SIMULTANEOUSLY
% 3) COMPLICATED ERROR CALCULATIONS

%%%%%%%% REBINNING DATA %%%%%%%%%%


%Preparing Gratings Data for Fitting
capella=load_data("capella.pha2");

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

%we exclude all the layers of pha2 that we don't need
exclude(capella[0],capella[1],capella[4],capella[5]);

%spectra layers as a variables
m1=capella[2];
p1=capella[3];

ignore([p1,m1],NULL,0.53);
ignore([p1,m1],0.63,NULL);

%Plotting BEFORE REBINNING
plot_unit("A");
plot_counts(p1);
group([leg1];min_sn=3);
plot_counts(p1);