function surface_plot(w, x, xb, options)
% SURFACE_PLOT Show surface plot of w(x). 
%
% The input is  assumed to be a polynomial in two variables, 
% w = w(x1, x2).
%
% INPUTS: 
%
%   "w" - polynomial.
%
%   "x" - sdpvar object, argument of w.
%
%   "xb" - defines a bounding box [-xb, xb]^2 for plotting.
%
%   "options" - options to plot (e.g. color). NOT IMPLEMENTED.
%
% OUTPUTS: 
%
%   The 'surf' plot.
%
% EXAMPLES:
%
% 1. Surface plot of p(x) = x1*(1-x2) in the square [-4, 4].
%
% >> sdpvar x1 x2 
% >> surface_plot(x1*(1-x2), [x1; x2], 4)
%
% 2. More interestingly, the target polynomial is the solution of a 
% sos program:
%
% >> ... 
% >> diagnostic = optimize(F, obj, options); % sos problem involving w0
% >> surface_plot(w0, x, xb);
%
% NOTES: 
%  
% - The polynomial does not need to be 'evaluated', this is done internally
% if necessary. This means that we can call this function directly after
% an optimize(..) command, as in the example 2 above.
%
% - As of yalmip('version')=20160930, the keyword 'value' exists;
% otherwise, 'double' is used.
%
% See also: superlevel_set_plot

%==========================================================================

% extract coefficients and monomials list
[cw, mono_w] = coefficients(w, x);

% check if the coefficients are evaluated or not
if strfind(class(cw(1)), 'sdpvar')
    got_evaluated = 0;

    % try to evaluate 
    if ~exist('value')
        cw = double(cw);
    else
        cw = value(cw);
    end    
    
elseif strfind(class(cw(1)), 'double')
    got_evaluated = 1;
else
    error('Could not recognise coefficients type.')
end

figure;

sdpvar X Y

%--------------------
% Remark: if using monolist to produce the monomial basis, we need to
% extract the degree of w. However, if we use mono_w as above we don't need
% to instantiate vv. Notice that in general mono_w will have a different
% than that of vv below, so we should be careful about possible mismatches.
% d = max(degree(w, x));
% For instance for d = 2, this produces 1, X, Y, X^2, X*Y, Y^2
% vv = monolist([X;Y], d); 
% p = vectorize(sdisplay(cw'*vv));
%--------------------

% p <- w(x)
p = vectorize(sdisplay(cw'*mono_w)); 

% we want to change variables:
% X <- x(1) and Y <- x(2)

p = strrep(p, 'x(1)' ,'X');
p = strrep(p, 'x(2)' ,'Y');

[X, Y] = meshgrid(-xb:0.05:xb,-xb:0.05:xb);

Z = eval(p);

surf(X,Y,Z)

title(['Surface plot of polynomial ' inputname(1)])
var_name = inputname(2);
if isempty(var_name)
    xlabel('x_1'); ylabel('x_2'); 
else
    xlabel([var_name '_1']); ylabel([var_name '_2']); 
end

end
