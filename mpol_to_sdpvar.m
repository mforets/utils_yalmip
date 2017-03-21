function [f_sdpvar] = mpol_to_sdpvar(f_mpol, x)
% MPOL_2_SDPVAR Transform mpol object (Gloptipoly) to sdpvar object (YALMIP). 
%
%
% INPUTS: 
%
%   "f" - Scalar polynomial as a (Gloptipoly's) mpol object.
% 
%   "x" - (optional) strings containing the names of the variables of the 
%         function f.
%
% OUTPUTS: 
%
%   The polynomial as a YALMIP's sdpvar object. If x is not given, the variables 
%   of the output function are x1, x2, ..., xn, where n is the number of
%   variables of f.
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
% - Test a constant polynomial:
%
%
% NOTES: 
%  
% - Should extend to polynomial vector.
%
% See also: integrate_poly_scalar
%
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

if n == 0    % contant case is a corner case: the pow returns 0, the coef returns ~= 0, but the n is set to 0 
   n = 1;
   %sdpvar x
   %f_sdpvar = x - x + coef(f_mpol);
   %return 
end

% define a vector of sdp variables
x = sdpvar(n, 1);

f_sdpvar = coef(f_mpol)' * x.^pow(f_mpol);

elseif got_variables_names 
    error('NotImplementedError: User-defined variable names are not implemented.')
    
end

end

