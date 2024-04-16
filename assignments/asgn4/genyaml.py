import yaml
import sympy

A = sympy.Matrix([[1,1,1],[1,1,1],[1,1,1]])
with open('obj.yml', 'w') as f:
    matrix = yaml.dump(A, f)