function [g] = composition(v, f)
% COMPOSITION Returns function composition v(f(x)). 
%
% INPUTS: 
%
%   "v" - Polynomial.
%
%   "f" - Polynomial.
%
% EXAMPLES:
%
% - Example of degree two, with sdpvar:
% >> sdpvar x
% >> f = x^2 + 2*x + 1;    % = (x+1)^2
% >> v = x + 1    
% >> sdisplay(composition(v, f))    % v(f(x)) = (x+1)^2 + 1
% 2+2*x+x^2
%
% TESTS:
% 
% - Testing mpol input:
%
% >> mpol x
% >> f = x^2 + 2*x + 1;    % = (x+1)^2
% >> v = x + 1    
% >> sdisplay(composition(v, f))    % v(f(x)) = (x+1)^2 + 1
% 2+2*internal(1)+internal(1)^2
%
% TO-DO: 
%  
% - Accept multivariate polynomials.
%
% =========================================================================

%---------------------
% Checking input types
%---------------------

warning('This function is currently only implemented for a univariate function. If f and v are univariate, then ignore this message.')

if isa(f, 'mpol')
    f = mpol_to_sdpvar(f);
elseif isa(f, 'sdpvar')
    % this function works with spdvar objects
else
    error('Input type of f not recognised.')
end

if isa(v, 'mpol')
    v = mpol_to_sdpvar(v);
elseif isa(v, 'sdpvar')
    % this function works with sdpvar objects
else
    error('Input type of v not recognised.')
end

%------------------------------
% Retrieve coeffs and monomials 
%------------------------------

% define a sdp variables
sdpvar x

[coef_f, mono_f] = coefficients(f);

[coef_v, mono_v] = coefficients(v);

%----------------
% Do composition
%----------------

% Let f = \sum_\alpha f_\alpha x^\alpha, and v = \sum_\beta v_\beta
% x^\beta. Then, g(x) = v(f(x)) = \sum_\beta v_\beta (\sum_\alpha f_\alpha
% x^\alpha)^\beta.

% is automatically coerced to an sdpvar in the sum
g = 0;

for i = 1:length(mono_v)
    base = f;
    beta = degree(mono_v(i));
    ex = base^beta;
    v_beta = coef_v(i);
    g = g + v_beta*ex;
end

end