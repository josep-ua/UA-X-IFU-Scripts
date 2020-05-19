#!/bin/bash
# Input parameters:
events=$1
#srcid=$2
ra=$2
dec=$3
pixsize=0.001388888888888

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


