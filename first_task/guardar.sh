#!/bin/bash
#This script runs a full simulation with SIXTE of a two single call mekal and b\

#University of Alicante
#
#Written by Jose Angel Vicente Ortuno. Started 3/04/2020
#Get the simulation time, name and separation of sources:
time=$1
#Set the path to the X-IFU files:
XIFUPATH=$SIXTE/share/sixte/instruments/athena-xifu2019


ralpha=(11.35438333 11.40 11.30 11.30 11.40)
decli=(-60.6229722 -60.64739722 -60.64739722 -60.598397222 -60.598397222)
flux=(4.4373301994e-10 4.4373301994e-11 4.4373301994e-11 4.4373301994e-11 4.4373301994e-11)
outfile=(cenx3 mekal1 mekal2 mekal3 mekal4)

for i in 0 1 2 3 4
do	    
      simputfile XSPECFile=${outfile[i]}.xcm \
      RA=${ralpha[i]} \
      Dec=${decli[i]} \
      srcFlux=${flux[i]} \
      Emin=0.2 Emax=12 \
      Simput=${outfile[i]}.simput
done

#We merge all the simputs
opt="clobber=yes FetchExtensions=yes"
simputmerge $opt Infile1=cenx3.simput Infile2=mekal1.simput Outfile=A.simput \

simputmerge $opt Infile1=mekal2.simput Infile2=mekal3.simput Outfile=B.simput \

simputmerge $opt Infile1=B.simput Infile2=mekal4.simput Outfile=C.simput \

simputmerge $opt Infile1=A.simput Infile2=C.simput Outfile=final.simput \

#echo -e "RA: \c"
ra=11.35438333
#echo -e "DEC: \c"
dec=-60.622972222

#Simulate the event file
xifupipeline \
    XMLFile=$XIFUPATH/xifu_baseline.xml \
    AdvXml=$XIFUPATH/xifu_detector_lpa25_tdm_40.xml \
    Background=no  \
    RA=$ra Dec=$dec \
    Simput=final.simput \
    Exposure=$time \
    EvtFile="exer_"$time"_evt.fits"  \
    UseRMF=T \
    clobber=yes \
    Chatter=3

#Now the spectrum file
makespec \
    EvtFile="exer_"$time"_evt.fits" \
    EventFilter="GRADING==1" \
    RSPPath=$XIFUPATH \
    Spectrum="exer_"$time".pha" \
    clobber=yes

#At last the image.fits file
imgev \
    EvtFile="exer_"$time"_evt.fits" \
    Image="exer_"$time"_img.fits" \
    CoordinateSystem=0 Projection=TAN \
    NAXIS1=60 NAXIS2=60 CUNIT1=deg CUNIT2=deg \
    CRVAL1=$ra CRVAL2=$dec CRPIX1=30.5 CRPIX2=30.5 \
    CDELT1=-0.0011888874248538006 CDELT2=-0.0011888874248538006 \
    history=true \
    clobber=yes
