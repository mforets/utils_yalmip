%================================================================================================
% Generates powers of monomials UP TO degree d in the basis used by Gloptipoly

% INPUTS:
% n - dimension
% d - degree

% OUTPUTS:
% powers - monomial powers of the Gloptipoly basis

% NOTE: this helper function is from:
% ROA - Matlab codes (including distributions of YALMIP and GloptiPoly 3, and using either MOSEK or SeDuMi which should be installed) for computing estimates of the region of attraction of a polynomial control system, following the developments described in D. Henrion, M. Korda, Convex computation of the region of attraction of polynomial control systems, LAAS-CNRS Research Report 12488, August 2012. Developed by Milan Korda. 
% See Gloptipoly library and ROA Matlab codes in
% http://homepages.laas.fr/henrion/
% and references therein. 
%================================================================================================

function powers =  genPowGlopti(n,d)
    powers = [];
    for k = 0:d
        powers = [ powers ; genpow(n,k) ];
    end
end
