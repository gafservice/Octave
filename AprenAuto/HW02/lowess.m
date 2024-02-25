## Copyright (C) 2022-2024 Pablo Alvarado
## EL5857 Aprendizaje automático
## Tarea 2

## -*- texinfo -*-
## @deftypefn {Function File} {@var{rz} =} lowess(@var{p},@var{X},@var{z},@var{tau})
## LOcally WEighted regreSSion (LOWESS)
##
## Given a set of m training points in @var{X} with known 'z'-values
## stored in in the vector @var{z}, estimate the 'z'-values on the n
## data points in @var{p}, which usually lie somewhere inbetween the
## points in @var{X}.
##
## @param @var{p}: matrix of size n x d, with n d-D positions on which
##                 the z value needs to be regressed
##
## @param @var{X}: support data (or training data) with all m known d-D
##                 positions
##
## @param @var{z}: support data with the corresponding m z values for
##                 each position in @var{X}
##
## @param @var{tau}: bandwidth of the locally weighted regression
##
## @return @var{rz}: the n z-values for each data in @var{p}
##
## The number of rows of @var{X} must be equal to the length of @var{z}.
##
## The function must generate the z position for all data points in
## @var{p}.
## @end deftypefn
function rz=lowess(p,X,z,tau)
  ## This code is for simple linear regression with no-intercept

  ## CHANGE THE FOLLOWING CODE
  ## You have to replace this for proper LWR code
  ##
  ## (The following two lines should be removed)
  theta=pinv(X)*z(:);
  rz=p*theta;
endfunction
