### Appendix 1: Useful commands in Gloptipoly

An MPOL object X has the following internal structure:

- X.VAR = double vector, variable indices
- X.POW = double array, row = monomial index, column = variable power
- X.COEF = double vector, row = monomial coefficient

```
>> mpol x
>> f = 1 - x^3 + 4*x^4

Scalar polynomial

1-x^3+4x^4

>> listvar(f)

Scalar polynomial

x

>> length(ans)

ans =

     1

>> coef(f)

ans =

     1
    -1
     4

>> pow(f)

ans =

     0
     3
     4
```

Of course, we the ordering of coef and pow match.
