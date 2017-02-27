function [px] = poly_evaluate(p, x, y, y0)
% POLY_EVALUATE Evaluate the coefficients of a polynomial p = p(x),
% usually obtained as the solution of a SDP problem, but in general
% accepts any p = p(x, y), returning the polynomial evaluated at y=y0.
%
% INPUTS:
%
%   "p" - polynomial scalar.
%
%   "x" - sdpvar object, argument of p (scalar).
%
%   "y" - sdpvar object, argument of p (scalar or vector).
%
%   "y0" - vector of doubles, same length at y.
%
% OUTPUTS:
%
%   "px" - p(x) as a polynomial scalar
%
% EXAMPLES:
%
% 1. If v = v(x) is the solution of a sos program:
%
% >> ...
% >> diagnostic = optimize(F, obj, options); % sos problem involving v
% >> sdisplay(v)
% v_beta(1)+x*v_beta(2)+x^2*v_beta(3)+x^3*v_beta(4)+x^4*v_beta(5)
% >> vx = poly_evaluate(v, x)
% Polynomial scalar (real, 1 variable)
% >> sdisplay(vx)
% 2.4848*x-0.5613*x^2-1.1752e-06*x^3+7.6582e-07*x^4
%
% 2. Evaluation of a polynomial
%
% >> ...
% >> diagnostic = optimize(F, obj, options); % sos problem involving v
% >> sdisplay(v)
% v_beta(1)+x*v_beta(2)+x^2*v_beta(3)+x^3*v_beta(4)+x^4*v_beta(5)
% >> vx = poly_evaluate(v, x)
% Polynomial scalar (real, 1 variable)
% >> sdisplay(vx)
% 2.4848*x-0.5613*x^2-1.1752e-06*x^3+7.6582e-07*x^4
%
% TO DO:
% - Extend to multivariate polynomials in x.
%
% See also: plot_poly_scalar

%==========================================================================

got_xy = 0;
if nargin == 4
  % The short way: use yalmip's replace function!
  p = replace(p, y, y0);
  got_xy = 1;

  % The long way: substituting the numerical value for each monomial
  % assign(y, y0); % also works on vectors
end

% extract coefficients and monomials list
[c_p, mono_p] = coefficients(p, x);

if strfind(class(c_p(1)), 'sdpvar')

    % try to evaluate
    if ~exist('value')
        c_p = double(c_p);
    else
        c_p = value(c_p);
    end

    if any(isnan(c_p))
      warning('NaN detected. Removing NaN values. \n');
      mono_p = mono_p(c_p ~= NaN);
      c_p = c_p(c_p ~= NaN);
    end
end

% MISSING: to ignore NaN values!

px = c_p'*mono_p;
sdisplay(px)


% p_coefficients_list is a row vector containing the coefficients of
% p, in increasing order.
% if there are zeros in the coefficients list, these are added as well
% (in contrast to c_f in coefficients(..) output).

% we should take degree in x
%p_coefficients_list = zeros(1, 1+degree(p)); % works in the scalar x case
% [p_coefficients_list, ~] = degree(p, [x y]);
%
% mlist = monolist([x y], degree(p));
%
% % beta will collect the degree of each monomial, in increasing order
% beta = zeros(1, 1+degree(p));
%
% for i = 1:length(c_p)
%     % in some cases the value(..) might return a NaN (for instance if
%     % the parameter was removed when solving the SDP)
%     if ~isnan(c_p(i))
%         beta(i) = degree(mono_p(i));
%         p_coefficients_list(beta(i)+1) = c_p(i);
%     end
% end
%
% px = p_coefficients_list*(x.^beta)';

% // for later
% transform to decreasing order (optional)
%p_coefficients_list = p_coefficients_list(end:-1:1);

% evaluate the polynomial in an interval (optional)
% xdom = linspace(I(1), I(2), 1e3);
%px = polyval(p_coefficients_list, xdom);

% plot (optional)
%plot(xdom, px, 'b-');
% //

end
