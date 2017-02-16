% Returns the TOTAL number of monomials in n variables of total degree UP TO d

% INPUTS:
% n - dimension
% d - maximum total degree

% OUTPUTS:
% monTot - TOTAL number of monomials in n variables of order UP TO d

% NOTE: this helper function is from the Gloptipoly library, see ROA Matlab codes in
% http://homepages.laas.fr/henrion/
% and references therein.

function monTot = numMonTot(n,d)
    monTot = nchoosek(n+d,n);
end
