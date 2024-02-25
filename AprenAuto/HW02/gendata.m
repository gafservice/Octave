## Copyright (C) 2022-2024 Pablo Alvarado
## EL5857 Aprendizaje automático
## Tarea 2


## usage: [X,z] = gendata(numSamples[,noise])
##
## Generate simulated depth data.  For each position in a row of X,
## the height in meters is returned.  The deepest value is around
## -5012m below the see level, and the highest is around 3729.  Note
## that each pixel is covering a large area.  That's why Chirripo is
## not reflected with its proud 3820m, but rather the average height
## around it.
##
## Optionally you can provide the level of desired data noise in the z
## direction, which by default is set to 4m, which is around the
## precision of the measurements, and on the plane
##
## The generated data consists of 2D grid positions in the rows of X,
## and the corresponding z value at that position.  The order of the 2D
## positions in X is completely random (except for the reference data).
##
## The mandatory argument is a number, that indicates the absolute
## number of samples (if the provided number is greater than 1), or the
## percentage of total samples (if the provided number is less or equal
## than 1).  If exactly 1 is provided, then all data without noise is
## created.
##
function [X,z] = gendata(numSamples,noiseZ=4.0,noiseP=0.01)

  pkg load image;

  ## Load the 16-bit profile, which has an offset of 6000m
  Orig = flipud(imread("heightmap.png"));

  ## Cast it to double and pad it before filtering
  I = padarray(double(Orig)-6000.0,[2,2],"replicate");

  k5 = [1 4 6 4 1]; ## Binomial kernel
  k5 = k5 / sum(k5);

  ## Filter the profile to smooth out the 16-bit boundaries
  F=conv2(k5,k5,I,"valid");

  ## Get the complete data grid
  [xx,yy] = meshgrid(1:columns(F),1:rows(F));
  all = [xx(:) yy(:)];

  ## Does the user want the reference data only?
  if (numSamples==1 && noiseZ==0 && noiseP==0)
    ## Return the reference data
    X=all;
    z=F(:);
  else
    if numSamples<=1
      numSamples = round(numSamples*rows(Orig)*columns(Orig));
    endif

    ## Take some random data without replacement
    idx=randperm(rows(all),numSamples);

    ## Get the data and add the desired noise
    X = all(idx,:) + randn(rows(idx),2)*noiseP;
    z = F(idx) + randn(rows(idx),1)*noiseZ;
  endif
endfunction
