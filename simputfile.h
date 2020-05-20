/*
   This file is part of SIMPUT.

   SIMPUT is free software: you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   any later version.

   SIMPUT is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   For a copy of the GNU General Public License see
   <http://www.gnu.org/licenses/>.


   Copyright 2007-2014 Christian Schmid, FAU
*/

#ifndef SIMPUTFILE_H
#define SIMPUTFILE_H 1

#include "ape/ape_trad.h"

#include "simput.h"
#include "common.h"
#include "parinput.h"

#define TOOLSUB simputfile_main
#include "headas_main.c"


struct Parameters {
  /** File name of the output SIMPUT file. */
  char Simput[SIMPUT_MAXSTR];

  /** ID of the source. */
  int Src_ID;
  /** Name of the source. */
  char Src_Name[SIMPUT_MAXSTR];

  /** Source position [deg]. */
  float RA;
  float Dec;

  /** Source flux [erg/s/cm^2]. If the source flux is not specified
      (value=0.0), it is set according to the assigned spectrum. */
  float srcFlux;

  /** Lower and upper boundary of the generated spectrum [keV]. */
  float Elow;
  float Eup;
  float Estep;

  /** Power law. */
  float plPhoIndex;
  float plFlux;

  /** Black body temperature [keV]. */
  float bbkT;
  float bbFlux;

  /** Line dispersion [keV]. */
  float flSigma;
  float flFlux;

  float rflSpin;
  float rflFlux;

  /** Absorption column [10^22 atoms/cm^2] */
  float NH;

  /** Reference energy band [keV]. */
  float Emin;
  float Emax;

  /** File name of the input ISIS parameter file containing a spectral
      model. */
  char ISISFile[SIMPUT_MAXSTR];
  /** File name for optional preperation script (f. e. to load additional
   models). */
  char ISISPrep[SIMPUT_MAXSTR];

  /** File name of the input Xspec spectral model. */
  char XSPECFile[SIMPUT_MAXSTR];
  /** File name for optional preperation script (f. e. to load additional
   models). */
  char XSPECPrep[SIMPUT_MAXSTR];

  /** File name of the input ASCII spectrum. */
  char ASCIIFile[SIMPUT_MAXSTR];

  /** File name of the input PHA spectrum. */
  char PHAFile[SIMPUT_MAXSTR];

  /** File name of the input ASCII light curve. */
  char LCFile[SIMPUT_MAXSTR];
  double MJDREF;

  /** PSD general parameters */
  long PSDnpt;
  float PSDfmin;
  float PSDfmax;

  /** PSD: Zero-frequency Lorentzian parameters */
  float LFQ;
  float LFrms;

  /** PSD: Horizontal branch Lorentzian parameters */
  float HBOf;
  float HBOQ;
  float HBOrms;

  /** PSD: Quasi-periodic Lorentzian parameters (1-3) */
  float Q1f;
  float Q1Q;
  float Q1rms;

  float Q2f;
  float Q2Q;
  float Q2rms;

  float Q3f;
  float Q3Q;
  float Q3rms;

  /** File name of the input ASCII PSD. */
  char PSDFile[SIMPUT_MAXSTR];

  /** File name of the input FITS image. */
  char ImageFile[SIMPUT_MAXSTR];

  int chatter;
  char clobber;
  char history;

  /** number of bins of the spectrum **/
  int nbins;
  /** should the bins be spaced logarithmically? **/
  int logegrid;


};


int simputfile_getpar(struct Parameters* const par);


#endif /* SIMPUTFILE_H */

