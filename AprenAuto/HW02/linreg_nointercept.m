## Copyright (C) 2022-2024 Pablo Alvarado
## EL5857 Aprendizaje automático
## Tarea 2

function varargout=linreg_nointercept(p,X,z)
  ## This code is for simple linear regression with no intercept
 
  rz=p*theta;

  ## The first returned value must be the estimated rz heights.
  varargout{1}=rz;
  
  if nargout>1
    ## The user also wants the parameters theta    
    varargout{2}=theta;
  endif
endfunction
