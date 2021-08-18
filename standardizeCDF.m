%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Function to interpolate binned CDF %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code taken from Adam Caccavano
% (https://www.jneurosci.org/content/40/26/5116/tab-e-letters)
function cdfOut = standardizeCDF(cdfXIn, cdfFIn, bins)
% function to interpolate CFD to standardized nBins

  % Trim duplicate X-values (would cause interpolation to crash)
  [cdfX, indX] = unique(cdfXIn, 'last');
  cdfF = cdfFIn(indX);
  
  % Cap CDF with X,Y = (0,0) and (xMax,1) if not present
  if cdfX(1) ~= bins(1)
    cdfX = vertcat(bins(1), cdfX);
    cdfF = vertcat(0, cdfF);
  end
  
  if cdfX(end) ~= bins(end)
    cdfX = vertcat(cdfX, bins(end));
    cdfF = vertcat(cdfF, 1);
  end
  
  cdfOut = interp1(cdfX, cdfF, bins, 'previous');
  
end
