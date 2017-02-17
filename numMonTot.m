%================================================================================================
% Returns the TOTAL number of monomials in n variables of total degree UP TO d

% INPUTS:
% n - dimension
% d - maximum total degree

% OUTPUTS:
% monTot - TOTAL number of monomials in n variables of order UP TO d

% NOTE: this helper function is from:
% ROA - Matlab codes (including distributions of YALMIP and GloptiPoly 3, and using either MOSEK or SeDuMi which should be installed) for computing estimates of the region of attraction of a polynomial control system, following the developments described in D. Henrion, M. Korda, Convex computation of the region of attraction of polynomial control systems, LAAS-CNRS Research Report 12488, August 2012. Developed by Milan Korda. 
% See Gloptipoly library and ROA Matlab codes in
% http://homepages.laas.fr/henrion/
% and references therein. 
%================================================================================================

function monTot = numMonTot(n,d)
    monTot = nchoosek(n+d,n);
end
