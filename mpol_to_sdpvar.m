function [f_sdpvar] = mpol_to_sdpvar(f_mpol, x)
% MPOL_2_SDPVAR Transform mpol object (Gloptipoly) to sdpvar object (YALMIP). 
%
%
% INPUTS: 
%
%   "f" - Scalar polynomial as a (Gloptipoly's) mpol object.
% 
%   "x" - (optional) strings containing the names of the variables of the function f.
%
% OUTPUTS: 
%
%   The polynomial as a YALMIP's sdpvar object. If x is not given, the variables 
%   of the output function are x1, x2, ..., xn, where n is the number of
%   variables of f.
%
% EXAMPLES:
%
% 1. A univariate example:
% >> mpol x
% >> f = mpol_to_sdpvar(1 - x^3 + 4*x^4);
% sdisplay(f)
%1-internal(1)^3+4*internal(1)^4
%
% NOTES: 
%  
% - Should extend to polynomial vector.

%==========================================================================

if nargin == 1 % did not get variable names
    got_variables_names = 0;
end

if ~got_variables_names
    
% number of variables of the (possible multivariate) polynomial f_mpol
n = length(listvar(f_mpol));

if n > 1
    error('NotImplementedError: Number of variables greater than 1 is not implemented.')
end

% define a vector of sdp variables
x = sdpvar(n, 1);

f_sdpvar = coef(f_mpol)' * x.^pow(f_mpol);

elseif got_variables_names
    
    error('NotImplementedError: User-defined variable names are not implemented.')
end

end

