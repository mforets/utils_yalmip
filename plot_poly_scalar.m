function plot_poly_scalar(p, x, I, options)
% PLOT_POLY_SCALAR Plot a polynomial scalar (real, 1 variable).
%
% INPUTS: 
%
%   "p" - polynomial scalar.
%
%   "x" - sdpvar object, argument of p.
%
%   "I" - The limits of the plot, I \subset R.
%
%   "options" - options to plot (e.g. color). NOT IMPLEMENTED.
%
% OUTPUTS: 
%
%   no output. just plots p(x) in the current figure handle (or creates a
%   new one if there is no current handle >> NOT TESTED).
%
% EXAMPLES: 
%
% 1. Plot a polynomial in the interval [0,1] :
%
% >> sdpvar x 
% >> plot_poly_scalar(x*(1-x), x, [0,1])
%
% 2. More interestingly, if w = w(x) is the solution of a sos program (no
% need to have it evaluated, done internally -- can be used just after 
% an optimize(..) command):
%
% >> ... 
% >> diagnostic = optimize(F, obj, options); % sos problem involving w
% >> plot_poly_scalar(w, x, [0,1]) 
%
% See also: plot_poly_scalar

%==========================================================================

% generate x discretization domain
xdom = linspace(I(1), I(2), 1e3);

% extract coefficients and monomials list
[c_p, mono_p] = coefficients(p, x);

% check if the coefficients are evaluated or not
if strfind(class(c_p(1)), 'sdpvar')
    
    got_evaluated = 0;
    % try to evaluate
    c_p = value(c_p);
    if any(isnan(c_p))
        fprintf(2, 'Warning: NaN detected.\n');
    end
    
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
        % the parameter was removed when solving the SDP. another situation
        % when is when the input polynomial depends on more than one variable,
        % and this variable has not been evaluated.)
        if ~isnan(c_p(i))
            p_coefficients_list(degree(mono_p(i))+1) = c_p(i);
        end
        
    end
    
end
    
% transform to decreasing order
p_coefficients_list = p_coefficients_list(end:-1:1);

% evaluate the polynomial in I
px = polyval(p_coefficients_list, xdom);

% finally, plot
plot(xdom, px, 'b-');

xlabel(inputname(2));
title(['Plotting polynomial ' inputname(1)]);

end