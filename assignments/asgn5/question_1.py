#!/usr/bin/python3

import sys
import sympy as sp
from latex2sympy2 import latex2sympy

text_file = sys.argv[1]
with open(text_file, "r") as f:
    fns_lat = f.read().split("\n")

fns = [latex2sympy(i) for i in fns_lat]

x = sp.symbols("x")
k = sp.symbols("k")

ft_fns = [sp.fourier_transform(i, x, k) for i in fns]

convolution = sp.inverse_fourier_transform(ft_fns[0] * ft_fns[1], k, x)
convolution = sp.simplify(convolution)

print(sp.latex(convolution))

## Traditional integral method

# import sys
# import sympy as sp
# from latex2sympy2 import latex2sympy

# text_file = sys.argv[1]
# with open(text_file, "r") as f:
#     fns_lat = f.read().split("\n")

# fns = [latex2sympy(i) for i in fns_lat]

# x = sp.symbols("x")
# T = sp.symbols("T")

# f1 = fns[0]
# f2 = fns[1]

# convolution = sp.integrate(f1.subs(x, T) * f2.subs(x, x - T), (T, -sp.oo, sp.oo))
# convolution = sp.simplify(convolution)

# sp.pprint(convolution)