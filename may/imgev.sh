#!/bin/bash

# This Script has been written as a tool for an array of cases on May 2020 at the University of Alicante, based on Pablo Eleazar Mer\ino hard work. This script will be useful for instrument X-IFU of the ATHENA MISSION.

pixsize=0.0013888888888889

imgev \
    EvtFile="combination_evt.fits" \
    Image="separ"$separation"_ratio"$ratio"_models"$model1model2"_image.fits"\
    CoordinateSystem=0 Projection=TAN \
    NAXIS1=60 NAXIS2=60 CUNIT1=deg CUNIT2=deg \
    CRVAL1=10.0 CRVAL2=0.0 CRPIX1=30.5 CRPIX2=30.5 \
    CDELT1=$pixsize CDELT2=$pixsize \
    history=true \
    clobber=yes

