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
set_par(3,21.6,0,21.5,21.7);
set_par(4,0.025);
set_par(6,21.8,0,21.7,21.9);
set_par(7,0.025);
set_par(9,22.1,0,22.0,22.2);
set_par(10,0.025);

%Now we want to ignore some energy interval like 20.6-21.5 and 22.6-22.8 in both data sets
ignore([p1,m1],20.6,21.5);
ignore([p1,m1],22.6,22.8);

%Also we ignore any data below 20A and above 23A
ignore([p1,m1],NULL,20);
ignore([p1,m1],23,NULL);

%Performing the fit:
Fit_Verbose=1;
fit_counts();


%The best fit parameters are below:
list_par;


plot_data({m1,p1};dsym={1,1},decol={2,4},dcol={2,4},mcol={4,4},res=1);



%%%%%%%%% SPECTRAL DIAGNOSIS RATIO G,R,G %%%%%%%%%%

% To calculate the ratios like G=(f+i)/r or R=f/i
r=get_params("gauss(1).area");
i=get_params("gauss(2).area");
f=get_params("gauss(3).area");

%Take a look at the contex of r:
print(r);

%Now we calculate de ratios
rat=f[0].value/i[0].value;
g=(f[0].value+i[0].value)/r[0].value;
print(rat);
print(g);


%%%%%%%%%%%%%%% ERROR BARS %%%%%%%%%%%%%%%
%The error bar for the flux of the forbidden line is calculated as follow:
set_par("gauss(3).area",f[0].value,0,0.75*f[0].value,1.25*f[0].value);
list_par;


%At this point, we use the vconf tool
(fmi,fma)=vconf("gauss(3).area");

%Printing all the final error bars
print(fmi);
print(fma);
print(f[0].value-fmi);
print(fma-f[0].value);





print(f[0].value);