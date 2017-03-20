### Appendix 1: Useful commands in Gloptipoly

An MPOL object X has the following internal structure:

- X.VAR = double vector, variable indices
- X.POW = double array, row = monomial index, column = variable power
- X.COEF = double vector, row = monomial coefficient

```matlab
% assume that f is a mpol object

% get the list of variables:
%listvar(f)

% get the degree:
%deg(f)

% get the list of coefficients
%coef(f)

% get the powers of the monomials involved
%pow(f_mpol)
```

Of course, we shall assume that coef and pow do match.
