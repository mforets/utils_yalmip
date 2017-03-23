function [f_mpol] = sdpvar_to_mpol(f_sdpvar)
% SDPVAR_TO_MPOL Transform sdpvar object (YALMP) to mpol object (Gloptipoly). 
%
% INPUTS: 
%
%   "f" - Scalar polynomial as a (YALMIP's) sdpvar object.
%
% EXAMPLES:
%
% - A univariate example:
% >> sdpvar x
% >> f = sdpvar_to_mpol(1 - x^3 + 4*x^4)
%Scalar polynomial
%
% 1-x^3+4x^4
%
% - Test back and forth:
% >> sdpvar x
% >> f_sdpvar = 2*x^6 - 4*x^2 + 1;
% >> g_sdpvar = mpol_to_sdpvar(sdpvar_to_mpol(f_sdpvar))
%Polynomial scalar (real, 1 variable)
% >> 1-4*internal(1)^2+2*internal(1)^6
%
% TESTS:
% 
% - Testing a constant polynomial:
%
% >> sdpvar x
% >> sdpvar_to_mpol(x-x+1)
%Scalar polynomial
%
%1
%
% TO-DO: 
%  
% - Should extend to polynomial vector.
% - Add possiblity to name the variables.
%
% See also: integrate_poly_scalar, mpol_to_sdpvar
%
%==========================================================================

if nargin == 1 % did not get variable names
    got_variables_names = 0;
end

if got_variables_names
    error('NotImplementedError: User-defined variable names are not implemented.')
end

% number of variables of the (possible multivariate) polynomial f_mpol
%n = length(listvar(f_mpol));
warning('This function is only implemented for a univariate function. If f_mpol is univariate, then ignore this message.')

[coef_f_sdpvar, mono_f_sdpvar] = coefficients(f_sdpvar);

% define mpol variable
mpol x

% instantiate zero f_mpol polynomial
f_mpol = mpol();

for i = 1:length(mono_f_sdpvar)
    f_mpol = f_mpol + coef_f_sdpvar(i) * x.^degree(mono_f_sdpvar(i));
end

end