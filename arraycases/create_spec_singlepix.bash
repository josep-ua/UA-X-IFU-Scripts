#!/bin/bash
# This script has been written as a tool used in the separation_exercises, done during the spring and summer of 2016 at the
# University of Alicante in the context of the proyect: Scientific and technological of instrument X-IFU of the ESA's ATHENA
# mission: High resolution X-Ray spectroscopy in astrophysical scenarios.
#
# Written by P. Eleazar Merino Alonso. Last modification: 21/10/2016
# with this script we extract the spectra of a single pixel, centered in the coordinates (ra, dec) pased as input.
# An id, receives as well as argument is assigned to the extraction to mark the pixel from wich the spectrum is taken.
# it takes as arguments:
# 1) The name of the _evt file containing information.
# 2) an index for classifying extractions in case of several extractions
# 3) the ra coordinate where the pixel is centered.
# 4) the dec coordinate where the pixel is centered.

# Input parameters:
events=$1
#srcid=$2
ra=$2
dec=$3
pixsize=0.0013888888888889


# The variable pixsize should have already been set by calling the function select_configuration, written in the file
# auxilliary_stuff.bsh. Firstly we checked that variable pixsize is actually set:
if [ -z ${pixsize+x}  ]; then
        echo " FATAL ERROR! There's no current detector selected. Impossible to know pixelsize!"
fi
semipix=$( echo "scale=16; $pixsize / 2 " | bc)

# Files where sixte instrument's files are placed:
#file=/home/xray/Athena/simput/share/sixte/instruments/athena/1469mm_xifu/
file=$SIXTE/share/sixte/instruments/athena-xifu2019

# limits of the pixel:
dec_low_lim=$(echo " $dec - $semipix " | bc)
dec_hig_lim=$(echo " $dec + $semipix " | bc)
ra_low_lim=$(echo " $ra - $semipix " | bc)
ra_hig_lim=$(echo " $ra + $semipix " | bc)

# spectra straction:
makespec \
	EvtFile=$events"_evt.fits" \
    	EventFilter="GRADING==1 && DEC > "$dec_low_lim" && DEC < "$dec_hig_lim" && RA > "$ra_low_lim" && RA < "$ra_hig_lim \
	RSPPath=$file \
	Spectrum="spectrum_hires_"$events"_src.fits" \
    	clobber=yes

makespec \
        EvtFile=$events"_evt.fits" \
        EventFilter="GRADING==2 && DEC > "$dec_low_lim" && DEC < "$dec_hig_lim" && RA > "$ra_low_lim" && RA < "$ra_hig_lim \
        RSPPath=$file \
        Spectrum="spectrum_midres_"$events"_src.fits" \
        clobber=yes

makespec \
        EvtFile=$events"_evt.fits" \
        EventFilter="GRADING==3 && DEC > "$dec_low_lim" && DEC < "$dec_hig_lim" && RA > "$ra_low_lim" && RA < "$ra_hig_lim \
        RSPPath=$file \
        Spectrum="spectrum_lowres_"$events"_src.fits" \
        clobber=yes

