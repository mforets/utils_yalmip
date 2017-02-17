%================================================================================================
% Computes the moments up to degree d of the n-dimensional lebesgue measure over a box

% INPUTS:
% d - degree 
% box - defined as [vector of lower bounds; vector of upper bounds]
% YalmipBasis = 1 => monomial basis used by Yalmip, otherwise monomial basis used by Gloptipoly (deafault Gloptipoly)

% OUTPUTS
% moments - vector of moments

% EXAMPLES: (1) getLebesgueMomentsNew(10, [-1 -1 -1 ; 1 1 1], 1 )
%               generates moments of the lebesgue measure up to degree 10 in Yalmip basis over the unit box
%           (2) getLebesgueMomentsNew(10, [-1 -1 -1 ; 1 1 1], 0 )
%               the same but in the Gloptipoly basis

% NOTE: this helper function is from:
% ROA - Matlab codes (including distributions of YALMIP and GloptiPoly 3, and using either MOSEK or SeDuMi which should be installed) for computing estimates of the region of attraction of a polynomial control system, following the developments described in D. Henrion, M. Korda, Convex computation of the region of attraction of polynomial control systems, LAAS-CNRS Research Report 12488, August 2012. Developed by Milan Korda. 
% See Gloptipoly library and ROA Matlab codes in
% http://homepages.laas.fr/henrion/
% and references therein. 
%================================================================================================

function moments = getLebesgueMoments( d, box, YalmipBasis )
    if(~exist('YalmipBasis','var') || isempty(YalmipBasis))
        YalmipBasis = 0;
    end
    n = size(box,2);
 
    if(YalmipBasis == 1)
        disp('Generating moments in Yalmip basis')
        dv = monpowers(n,d);
    else
        disp('Generating moments in Gloptipoly basis')
        dv = genPowGlopti(n,d);
    end
    moments = zeros(size(dv,1),1);
    for i = 1:numel(moments)
        moments(i) = prod((box(2,:).^(dv(i,:)+1) - box(1,:).^(dv(i,:)+1)) ./ (dv(i,:)+1));
    end
end

