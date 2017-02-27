function superlevel_set_plot(w, x, xb, alpha, options)
% SUPERLEVEL_SET_PLOT Compute the alpha-superlevel set of w(x). 
%
% The alpha-superlevel set of a polynomial w(x) is defined as
% S_alpha = {x : w(x) >= alpha}.
% The input is  assumed to be a polynomial in two variables, 
% w = w(x1, x2).
%
% INPUTS: 
%
%   "w" - polynomial.
%
%   "x" - sdpvar object, argument of w.
%
%   "xb" - defines the bounds for plotting. Can be either a single number,
%   and [-xb, xb]^2 is assumed, or in the form: [-xb1 xb1; -xb2 xb2].
%
%   "alpha" - scalar, constraint on the contour plot. By defualt, the
%   contour plot is 'filled'.
%
%   "options" - options to plot (e.g. color). NOT IMPLEMENTED.
%
% OUTPUTS: 
%
%   The contour plot.
%
% EXAMPLES:
%
% 1. Plot {(x1, x2) : x1*(1-x2) >= 0}, in the square [-4, 4].
%
% >> sdpvar x1 x2 
% >> superlevel_set_plot(x1*(1-x2), [x1; x2], 4, 0)
%
% 2. More interestingly, the target polynomial is the solution of a 
% sos program:
%
% >> ... 
% >> diagnostic = optimize(F, obj, options); % sos problem involving w0
% >> superlevel_set_plot(w0, x, xb, 1);
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
% See also: surface_plot

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

p = strrep(p, char(sdisplay(x(1))), 'X');
p = strrep(p, char(sdisplay(x(2))), 'Y');

% x- and y- range
if size(xb,2) == 1
    xrange = -xb:0.01:xb;
    yrange = -xb:0.01:xb;
elseif size(xb,2) > 1
    if size(xb,1) == 1
        xrange = xb(1):0.01:xb(2);
        yrange = xb(1):0.01:xb(2);
    else
        xrange = xb(1,1):0.01:xb(1,2);
        yrange = xb(2,1):0.01:xb(2,2);
    end
end

[X, Y] = meshgrid(xrange, yrange);

% Value of w(x) at mesh points
Z = eval(p);

% Heights/values of level set(s) to plot
levels = [alpha];

% Plot level set(s)
contour(X, Y, Z, 'LevelList', levels, 'fill', 'on', 'ShowText', 'on')

% other fancy options
%figure
%numContours = 5;
%contour(X, Y, Z, numContours,'fill', 'on', 'ShowText', 'on')

axis equal

title([num2str(alpha), '-superlevel set plot of polynomial ', inputname(1)])

var_name = inputname(2);
if isempty(var_name)
    xlabel('x_1'); ylabel('x_2'); 
else
    xlabel([var_name '_1']); ylabel([var_name '_2']); 
end

end
