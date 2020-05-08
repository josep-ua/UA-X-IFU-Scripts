#!/bin/bash

# This Script has been written as a tool for an array of cases on May 2020 at the University of Alicante, based on Pablo Eleazar Merino hard work. This script will be useful for instrument X-IFU of the ATHENA MISSION.

#Written by Pablo Merino, first mod Fourth of May 2020

#Point of the Script, we have two point sources, simulated with different parameters:

#1) Separation of 2,3,5,7, arcsec.
#2) Flow ratio: 1, 1/2, 1/3, 1/10
#3) Models used:

#     a) Cen X-3 a real source
#     b) Mekal of kT=0.5 KeV
#     c) Mekal of kT=2 KeV

# We also assume that files simputgen.bsh, xifusimul.bsh and create_spec_singlepix.bsh are place in the current folder.

# We load the auxiliary functions library:
source ./auxiliarystuff_separex4b.bsh

#Models in use:
A=cenx3
B=mekal1
C=mekal2

#Simulations fixed parameters
flux=0.0000000000044373301994
filedirectory=xifu_crosstalk
time=100
configuration=LPA2
#We select current detector configuration:
#detectorflag=$1

#In the auxiliarystuff_sep.bsh there's a lot of configurations
#select_configuration $filedirectory $detectorflag
xmlfile=xifu_detector_lpa_75um_AR0.5_pixoffset_mux40_pitch275um.xml
echo $xmlfile

#GRID OF CASES:
# FIRST THE SEPARATION
for separation in 2 3 5 7 10
do

    #Fix the separation between the sources
    separ=$(echo "scale=16; $separation*0.0027778" | bc)

    #SECOND THE FLUX RATIO
    for ratio in 1 2 3 10
    do

	#Flux of the second source by applying the flux ratio
	flux1=$flux
	flux2=$(echo "scale=16; $flux1/ $ratio"| bc)
	echo "ratio : "$ratio" = "$(echo "scale=16; $flux2 / $flux1"| bc)

	#THIRD THE MODELS
	for model1 in A B C
	do

	    for model2 in A B C
	    do

	    #Let's do the current cases:

	       filename="separ"$separation"_ratio"$ratio"_models"$model1$model2

	       echo "================================= CASE SEPAR"$separation"_ratio"$ratio"_models"$model1$model2 " ============================="

	       mkdir $filename
	       cd $filename

	       #We create a log file for control the array:

	       touch control.log

	       #Write commands in control.log

	       printf "Case separ"$separation"_ratio"$ratio"_models"$model1$model2" \n" >> control.log
	       printf "pixsize = "$pixsize"  \n" >> control.log


	       #Copying simulation scripts:
	       cp ../simputgen.bsh .
	       cp ../xifusimul.bsh .
	       cp ../create_spec_singlepix.bash .

	       cp ../${!model1}".xcm" .
	       cp ../${!model2}".xcm" .

	       #Creating a simputfile containing two sources using simput merge command:

	       . simputgen.bsh ${!model1}".xcm" ${!model1}"1.simput" 10.0 0.0 $flux1
	       . simputgen.bsh ${!model2}".xcm" ${!model2}"2.simput" 10.0 $separ $flux2
               simputmerge ${!model1}"1.simput" ${!model2}"2.simput" combination.simput yes
	      # . simputmerge.sh

	       #Writting in control.log
	       printf "Source 1 Parameters : \nmodel = "${!model1}" \nflux = "$flux1" \n" >> control.log
	       printf "Source 2 Parameters : \nmodel = "${!model2}" \nflux = "$flux2" \n" >> control.log
	       printf "Separation = "$separ " \n" >> control.log

	       #SIMULATION
	       . xifusimul.bsh combination.simput combination_ 10.0 0.0 $time $xmlfile

	       printf "X-IFU Simulation parameters: \ntime = "$time" \nxmlfile = "$xmlfile" \n" >> control.log

	       # We create and image from the _evt.fits file:
	       imgev combination_evt.fits "separ"$separation"_ratio"$ratio"_models"$model1model2"_image.fits" 0 TAN 500 500 deg deg 10.0 0.0 250 250 $pixsize $pixsize


	       #SPECTRUM EXTRACT. First we extract the pixel where Source 1 is placed:
	       . create_spec_singlepix.bash combination 1 10.0 0.0

	       #Depending on the other position, we extract different the corresponding pixel:

	       select_ra_dec_source2
	       echo $ra_src_2
	       echo $dec_src_2
	       . create_spec_singlepix.bash combination 2 $ra_src_2 $dec_src_2

	       #EXIT CURRENT DIRECTORY



	       cd ..
	    done

	done
    done
done
