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
source /media/xray/Elements/2016_XIFU/simulfiles/shell/auxiliary\
       stuff_separex4b.bsh

#Models in use:
A=cenx3
B=mekal1
C=mekal2

#Simulations fixed parameters
flux=4.4373301994e-9
mirror=xifu_crosstalk
time=1000

#We select current detector configuration:
detectorflag=$1

#In the auxiliarystuff_sep.bsh there's a lot of configurations
select_coinfiguration $mirror $detectorflag
echo $xmlfile

#GRID OF CASES:
# FIRST THE SEPARATION
for separation in 2 3 5 7 10
do

    #Fix the separation between sources in degrees
    separ=$(echo "scale=16; $separation*0.0027778" | bc)

    #SECOND THE FLUX RATIO
    for ratio in 1 2 3 10
    do

	#Flux of the second source by applying the flux ratio
	flux1=$flux
	flux2=$(echo "scale=16; $flux1/ $ratio"| bc)
	echo "ratio : "$ratio" = "$(echo "scale=16; $flux1/ $ratio"| bc)

	#THIRD THE MODELS
	for model 1 in A B C
	do

	    for model2 in A B C
	    do

	    #Let's do the current cases:
