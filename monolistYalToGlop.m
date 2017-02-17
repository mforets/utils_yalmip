%================================================================================================
% Returns a list of monomials up to degree d in sdpvariable x indexed in the basis used by Gloptipoly

% INPUTS: x - sdpvariable
%         d - maximum total degree of the monomials

% OUTPUTS: mlist - list of monomials

% NOTE: this helper function is from:
% ROA - Matlab codes (including distributions of YALMIP and GloptiPoly 3, and using either MOSEK or SeDuMi which should be installed) for computing estimates of the region of attraction of a polynomial control system, following the developments described in D. Henrion, M. Korda, Convex computation of the region of attraction of polynomial control systems, LAAS-CNRS Research Report 12488, August 2012. Developed by Milan Korda. 
% See Gloptipoly library and ROA Matlab codes in
% http://homepages.laas.fr/henrion/
% and references therein. 
%================================================================================================


function mlist = monolistYalToGlop(x,d)
    n = numel(x);
    mlist1 = repmat(x',numMonTot(n,d),1).^genPowGlopti(n,d);
    mlist = mlist1(:,1);
    for i = 2:n
        mlist = mlist.*mlist1(:,i);
    end
end
