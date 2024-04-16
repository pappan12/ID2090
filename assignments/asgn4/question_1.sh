#!/usr/bin/python3

## INFO: Obtain a matrix from a YAML serialized file and perform various operations on it.
## usage: ./question_1.sh <yaml_file>

import sympy
import yaml
import sys

## Check if arguments are correct
if len(sys.argv) != 2:
    print("Usage: ./question_1.sh <yaml_file>", file=sys.stderr)
    exit(1)

## Load the YAML file and obtain the matrix
yaml_file = sys.argv[1]
with open(yaml_file, "r") as f:
    matrix = yaml.load(f, Loader=yaml.Loader)

## REMARK: Format of matrix.eigenvects() is a list of tuples,
# where each tuple is of the form (eigenvalue, multiplicity, eigenvectors)

## Eigenvalues of the matrix
lev = []
print("Eigenvalues:")
# Using eigenvects() to print eignevalues in the same order as eigenvectors
for i in matrix.eigenvects():
    for j in range(i[1]):
        lev.append(i[0])
sympy.pprint(lev)
print()

## Unitary Matrix which diagonalizes the matrix # M=UDU^H (where U^H denotes the conjugate transpose of U)
# Orthonormalize the eigenvectors using the Gram-Schmidt process (for repeated eigenvalues)
print("U:")
eigenvectors = []
for i in matrix.eigenvects():
    for j in range(i[1]):
        eigenvectors.append(i[2][j])
P_orthonormal = sympy.GramSchmidt(eigenvectors, True)
P_orthonormal = sympy.Matrix.hstack(
    *P_orthonormal
)  # Convert list of vectors back to matrix
sympy.pprint(P_orthonormal)
print()

## Diagonalized matrix
print("D:")
P, D = (
    matrix.diagonalize()
)  # This inbuilt function returns the diagonalized matrix and the unitary matrix
sympy.pprint(D)
print()

## Spectral decomposition of the matrix
print("Decomposition:")
expr = (
    sympy.matrices.expressions.matadd.MatAdd()
)  # Initialize the expression (the type had to specified)
for i in range(len(lev)):
    vvT = (
        P_orthonormal[:, i] * P_orthonormal[:, i].H
    )  # Outer product of the orthogonalised eigenvectors
    term = sympy.MatMul(
        lev[i], vvT, evaluate=False
    )  # The term is the eigenvalue times the outer product
    expr = sympy.MatAdd(
        expr, term, evaluate=False
    )  # Add each term, these lines are to pretty print the expression
sympy.pprint(expr)
print()

## Classifications of the matrix
print("Classification:")
classy = "A is "
if matrix == matrix.H:  # Hermitian (matrix.H is the conjugate transpose of the matrix)
    classy += "Hermitian, "
if (
    matrix.det() != 0 and matrix.H == matrix.inv()
):  # Unitary (matrix.inv() is the inverse of the matrix)
    classy += "Unitary, "
if all(
    (ev >= 0 if ev.is_real else False) for ev in lev
):  # Positively Semidefinite (all eigenvalues are non-negative)
    classy += "Positively Semidefinite, "
if all(
    (ev > 0 if ev.is_real else False) for ev in lev
):  # Positively Definite (all eigenvalues are positive)
    classy += "Positively Definite, "
if (
    matrix * matrix.H == matrix.H * matrix
):  # Normal (matrix commutes with its conjugate transpose)
    classy += "Normal, "
print(classy[:-2])
print()

# References:
# https://pyyaml.org/wiki/PyYAMLDocumentation
# https://docs.sympy.org/latest/modules/matrices/matrices.html
# https://www.cse.iitk.ac.in/users/rmittal/prev_course/s14/notes/lec10.pdf
# https://en.wikipedia.org/wiki/Gram%E2%80%93Schmidt_process
# https://math.stackexchange.com/questions/135546/looking-for-orthogonal-basis-of-eigenvectors-using-gram-schmidt-process
# https://people.tamu.edu/~yvorobets//MATH304-2011A/Lect3-05web.pdf