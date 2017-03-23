function [f_sdpvar] = mpol_to_sdpvar(f_mpol)
% MPOL_TO_SDPVAR Transform mpol object (Gloptipoly) to sdpvar object (YALMIP). 
%
% INPUTS: 
%
%   "f" - Scalar polynomial as a (Gloptipoly's) mpol object.
%
% EXAMPLES:
%
% - A univariate example:
% >> mpol x
% >> f = mpol_to_sdpvar(1 - x^3 + 4*x^4);
% sdisplay(f)
%1-internal(1)^3+4*internal(1)^4
%
% - Application example:
% >> mpol x
% >> integrate_poly_scalar(mpol_to_sdpvar(2*x^2 - x + 1), [], [0 1], [])
% 1.1667
%
% - Compare to:
% >> sdpvar x; integrate_poly_scalar(2*x^2 - x + 1, [], [0 1], [])
% 1.1667
%
% TESTS:
% 
% - Testing a constant polynomial:
%
% >> mpol x
% >> mpol_to_sdpvar(x-x+1)
% 
% ans =
% 
%      1
%
% TO-DO: 
%  
% - Should extend to polynomial vector.
% - Add possiblity to name the variables.
%
% See also: sdpvar_to_mpol, integrate_poly_scalar
%
% =========================================================================

if nargin == 1 % did not get variable names
    got_variables_names = 0;
end

if got_variables_names
    error('NotImplementedError: User-defined variable names are not implemented.')
end

% number of variables of the (possible multivariate) polynomial f_mpol
n = length(listvar(f_mpol));

if n > 1
    error('NotImplementedError: Number of variables greater than 1 is not implemented.')
end

% contant case is a corner case
if n == 0    
    % the pow returns 0, the coef returns ~= 0, but the n is set to 0 
    n = 1;
end

% define a vector of sdp variables
x = sdpvar(n, 1);

f_sdpvar = coef(f_mpol)' * x.^pow(f_mpol);

end