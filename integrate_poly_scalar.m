function ipx = integrate_poly_scalar(p, x, I, options)
% INTEGRATE_POLY_SCALAR Integrate a polynomial scalar (real, 1 variable).
%
% INPUTS: 
%
%   "p" - polynomial scalar.
%
%   "x" - sdpvar object, argument of p.
%
%   "I" - The limits are of integration, I \subset R.
%
%   "options" - options for the integrator, e.g. accuracy. NOT IMPLEMENTED.
%
% OUTPUTS: 
%
%   "ipx" - definite integral: int_I p(x) dx
%
% EXAMPLES:
%
% 1. Integrate a custom polynomial scalar: 
%
% >> sdpvar x
% >> f = x^2 - 1
% >> integrate_poly_scalar(f, x, [0, 1], [])
%
%ans =
%
%   -0.6667
%
% 2. More useful when w is the dual solution of an optimization problem:
%
% >> integrate_poly_scalar(w, x, [0, 0.001])
%
% ans =
%
%    0.0010
%
% See also: plot_poly_scalar

%==========================================================================

% first we have to retrieve coefficients of p. if it is the solution of a 
% sdp problem then we must beforehand check if it is evaluated or not.

% extract coefficients and monomials list
[c_p, mono_p] = coefficients(p, x);

% check if the coefficients are evaluated or not
if strfind(class(c_p(1)), 'sdpvar')
    got_evaluated = 0;
    % try to evaluate
    c_p = value(c_p);
elseif strfind(class(c_p(1)), 'double')
    got_evaluated = 1;
else
    error('Could not recognise coefficients type.')
end

% p_coefficients_list is a row vector containing the coefficients of
% p, in increasing order. 
% if there are zeros in the coefficients list, these are added as well 
% (in contrast to c_f in coefficients(..) output).
p_coefficients_list = zeros(1, 1+degree(p));

for i = 1:length(c_p)
    
    if got_evaluated
    
        % assuming the coefficients of p are already evaluated
        p_coefficients_list(degree(mono_p(i))+1) = c_p(i);
    
    elseif ~got_evaluated
        
        % in some cases the value(..) might return a NaN (for instance if
        % the parameter was removed when solving the SDP)
        if ~isnan(c_p(i))
            p_coefficients_list(degree(mono_p(i))+1) = c_p(i);
        end
        
    end
    
end
    
% transform to decreasing order
p_coefficients_list = p_coefficients_list(end:-1:1);

% integrate the polynomial using a constant of integration 0
ind_ipx = polyint(p_coefficients_list);

% find the value of the integral by evaluating it at the limits of
% integration
ipx = diff(polyval(ind_ipx, I));

end