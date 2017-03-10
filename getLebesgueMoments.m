function moments = getLebesgueMoments(d, box, YalmipBasis, p)
% GETLEBESGUEMOMENTS Computes the moments up to degree d of the n-dimensional
% Lebesgue measure over a box.
%
% INPUTS:
%
%   "d" - degree.
%
%   "box" - defined as [vector of lower bounds; vector of upper bounds]
%
%   "YalmipBasis" - monomial basis used by Gloptipoly (default=0), otherwise
%                   monomial basis used by YALMIP (=1).
%
%   "p" - (default=1) the p-norm to be used, should be 1 <= p < oo.
%
% OUTPUTS:
%
%   "moments" - vector of moments, as a column vector.
%
% EXAMPLES:
%
%   1. Generates moments of the lebesgue measure up to degree 2 in Yalmip
%      basis over the three-dimensional unit box [-1, 1]^3:
%
% >> getLebesgueMoments(2, [-1 -1 -1 ; 1 1 1], 1 )'
% Generating moments in Yalmip basis
%
%ans =
%
%    8.0000         0         0         0    2.6667         0    2.6667         0         0    2.6667
%
%
%    2. The same as in 1, but in the Gloptipoly basis:
%
% >> getLebesgueMoments(2, [-1 -1 -1 ; 1 1 1])'
% Generating moments in Gloptipoly basis
%
%ans =
%
%    8.0000         0         0         0    2.6667         0         0    2.6667         0    2.6667
%
%     3. Compute moments up to degree 4 in the p-norm for p=3/2, in the
% unit interval [0,1]:
%
% >> getLebesgueMoments(4, [0; 1], 0, 1.5)'
%Generating moments in Gloptipoly basis
%
%ans =
%
%    1.0000    0.5429    0.3969    0.3209    0.2733
%
% NOTES:
%
% - This helper function is from: ROA - Matlab codes (including distributions of YALMIP and GloptiPoly 3, and using either MOSEK or SeDuMi which should be installed) for computing estimates of the region of attraction of a polynomial control system, following the developments described in D. Henrion, M. Korda, Convex computation of the region of attraction of polynomial control systems, LAAS-CNRS Research Report 12488, August 2012. Developed by Milan Korda.
% See Gloptipoly library and ROA Matlab codes in
% http://homepages.laas.fr/henrion/
% and references therein.
%
% - Extension for p-norms, p >= 1 by Marcelo Forets, Feb. 2017.
%
% - The object dv for each choice of basis has the same entries but in
% possibly different rows. It is arranged as a table, with each line
% corresponding to the powers of the monomial in question. For instance, if
% the box is of the form [-1 -1 -1; 1 1 1], then the entry (1,1,0)
% corresdponds to x_1*x_2.
%
% - Note that if the domain is negative, for general p it may produce
% moments that are complex-valued.
%
% TO-DO:
%
% - Accept p = inf. Should solve for max_{x_j \in I_j} x_j^{\alpha_j p}. Or
% approximate for big  values of p. E.g. p = 1e6 works in small examples.
%

%==========================================================================

    if (~exist('p', 'var') || isempty(p))
        p = 1;
    end

    if (~exist('YalmipBasis', 'var') || isempty(YalmipBasis))
        YalmipBasis = 0;
    end
    n = size(box,2);

    if (YalmipBasis == 1)
        disp('Generating moments in Yalmip basis')
        dv = monpowers(n,d);
    else
        disp('Generating moments in Gloptipoly basis')
        dv = genPowGlopti(n,d);
    end

    % there is one moment for each row of dv
    moments = zeros(size(dv,1),1);

    if (p==1)
        for i = 1:numel(moments)
            moments(i) = prod((box(2,:).^(dv(i,:)+1) - box(1,:).^(dv(i,:)+1)) ./ (dv(i,:)+1));
        end

    elseif (1 < p) && (p < inf)
        if any(box < 0)
            warning('Negative domain main produce imaginary moments.')
        end

        for i = 1:numel(moments)
            moments(i) = prod((box(2,:).^(p*dv(i,:)+1) - box(1,:).^(p*dv(i,:)+1)) ./ (p*dv(i,:)+1));
            moments(i) = moments(i)^(1/p);
        end


    elseif (p == inf)
        error('p == inf not implemented.');

    else
        error('p not understood.');
    end

end
