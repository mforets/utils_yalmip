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
% 2. A multivariate example:
% >> mpol x y
% >> f = mpol_to_sdpvar(1 - x^3 + 4*x^4);
% sdisplay(f)
%1-internal(1)^3+4*internal(1)^4
%
% NOTES: 
%  
% - Should extend to polynomial vector.
% 
% - In Matlab, a string is really just a vector of characters. So we cannot
% just store strings of different lengths (in Pythonic thinking this would
% make sense simply as a list of strings). Hence, one way around is to use
% a cell array. Warning: to concatenate cell arrays we have to use the
% usual [] operator, not {} (the last one would create nested cell arrays).   
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

% define a vector of sdp variables
x = sdpvar(n, 1);

f_sdpvar = coef(f_mpol)' * x.^pow(f_mpol);

elseif got_variables_names
    
    error('NotImplementedError: User-defined variable names are not implemented.')
end
   
% % try to get variable names?
% retrieve_variable_names = 0;
% 
% if retrieve_variable_names
%     
% %------------------------
% % Retrieve variable names
% %------------------------
% 
% % will create a cell array variables_names, each cell containing a 
% % string with the variable name in f. instead of finding this, we can just
% % ask the user to pass the variable names as a second argument.
% 
% find_variables_names = 1;
% 
% if (find_variables_names)
%     
% % we have to evaluate because listvar(f) is a mpol object...    
% list_variables_names = evalc('listvar(f)');
% 
% s = strsplit(list_variables_names, '):');
% 
% if length(s) == 1 % got polynomial in 1 variable
%     variables_names = {strtrim(strrep(s, 'Scalar polynomial', ''))};
% 
% elseif length(s) > 1 % got polynomial in more than 1 variable
%     variables_names = {};
% 
%     % s(1) is information about the object that we discard (e.g. 2-by-1 polynomial vector)
%     for i = 2:length(s)-1
%         
%         % this is typically: (1,1):x (2,1):t
%         vname = strsplit(char(s(i)), '(');
%         vname = strtrim(char(vname(1)));
%         variables_names = [variables_names; {vname}];
%         
%     end
%     
%     variables_names = [variables_names; {strtrim(char(s(end)))}];
% end
% 
% end 
% 
% clear list_variables_names s
% 
% %------------------------
% % Define sdpvar variables
% %------------------------
% 
% for i = 1:length(variables_names)
%     
%     % instantiate sdpvar variables in this workspace
%     sdpvar(char(variables_names{i}));
% 
%     % inject variables in the calling workspace
%     % e.g. evalin('caller', 'sdpvar u');
%     
%     % the problem is that the caller does not recosnigse the
%     % name variables_names, so the following fails:
%     %evalin('caller', 'sdpvar([''char(variables_names{i})'' ''_''])');
%     
%     % so the workaround is to: returning f_yalmip AND the names of the
%     % variables in f
%     
%     % ... or use assignin
%     
%     % need to have a variable name outside
%     assignin('caller', 'vni', char(variables_names{i})); 
%     
%     % use this variable name
%     evalin('caller', 'sdpvar([vni ''_''])');
%      
% end
% 
% % don't need to keep it
% evalin('caller', 'clear vni');
% 
% 
% %--------------------------------------------------
% % Get coefficients and the affected monomial powers
% %--------------------------------------------------
% 
% % Scalar case
% if length(variables_names) == 1
% 
%     % powers of monomials
%     pf = pow(f); pfi = pf(1);
% 
%     % coefficients
%     cf = coef(f); cfi = cf(1);
% 
% %------------------------------
% % Instantiate sdpvar polynomial
% %------------------------------
% 
%     % initialization (scalar case = only one variable)
%     f_aux = cfi*eval(char(variables_names{1}))^pfi;
%    
%     % run through all non-zero terms
%     for i = 2:length(pf)
%         pfi = pf(i); 
%         cfi = cf(i);
%         f_aux = f_aux + cfi*eval(char(variables_names{1}))^pfi;
%     end
% 
%     f_ = f_aux;
% 
% elseif length(variables_names) > 1
%     error('NotImplementedError: multivariate polynomial.');
% end
% 
% % --- old batch -----------------------------
% % f_yalmip = [inputname(1) '_yalmip'];
% % 
% % evalc('f_yalmip = q')
% 
% % Simple example: 
% % mpol x
% % f = 4*x^4 - 2*x^2 + x + 1
% % [f_sdpvar, x_sdpvar] = mpol_to_yalmip(f, x)
% %f_ = mpol_to_yalmip(f);
% %--------------------------------------------
% 
% end

end

%-------------------------------------------
% Appendix: Useful commands in Gloptipoly
%-------------------------------------------

% assume that f is a mpol object

% get the list of variables:
%listvar(f)

% get the degree:
%deg(f)

% get the list of coefficients
%coef(f)

% get the powers of the monomials involved
%pow(f_mpol)

% we shall assume that coef and pow are "aligned"


%-------------------------------------------
% Appendix: Useful commands in YALMIP
%-------------------------------------------

%sdpvar x

%f = 1 - x^3 + 4*x^4
%Polynomial scalar (real, 1 variable)

% display coefficients and monomials affected by them
%[c, v] = coefficients(f);

% >> c'
% 
% ans =
% 
%      1    -1     4
     
% sdisplay(v)'
% 
% ans = 
% 
%     '1'    'x^3'    'x^4'


%x = sdpvar(2, 1)
