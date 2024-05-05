#!/usr/bin/python3

## INFO: This Sage(python) script find the best fit plane for a set of points in 3D space.
## usage: ./question_2.sh <csv_file>

import sys
import csv
from sage.all import matrix, vector, var, round

## Read points from CSV file
csv_file = sys.argv[1]
points = []
with open(csv_file, "r") as f:
    reader = csv.reader(f)
    next(reader)  # Skip the header
    for row in reader:
        points.append([float(val) for val in row])

## Define the variables
a, b, c, x, y, z = var("a b c x y z")

## Define objective function as sum of squares of distances of the plane from the points
L = (a * x + b * y + c * z - 1) ** 2

## Calculate the derivatives of the objective function
L_a = L.diff(a)
L_b = L.diff(b)
L_c = L.diff(c)

## Define the gradient
grad = vector([L_a, L_b, L_c])

## Define the Hessian matrix
H = matrix(
    [
        [L_a.diff(a), L_a.diff(b), L_a.diff(c)],
        [L_b.diff(a), L_b.diff(b), L_b.diff(c)],
        [L_c.diff(a), L_c.diff(b), L_c.diff(c)],
    ]
)

## Define and initialise vector v
v = vector([0, 0, 0])
print(f"Initialised: {v[0]} {v[1]} {v[2]}")

count = error = 0

while True:
    # Calculate the gradient and Hessian at the current point
    grad_val = vector([0, 0, 0])
    H_val = matrix(3, 3, [0] * 9)  # 3x3 zero matrix
    for point in points:
        grad_val += grad.subs(
            {a: v[0], b: v[1], c: v[2], x: point[0], y: point[1], z: point[2]}
        )
        H_val += H.subs(
            {a: v[0], b: v[1], c: v[2], x: point[0], y: point[1], z: point[2]}
        )
        # Error calculation
        error += (v[0]*point[0] + v[1]*point[1] + v[2]*point[2] - 1)**2
        
    # Calculate the step size
    step = H_val.inverse() * grad_val

    # Check for convergence
    if step.norm() < 1e-6:
        break

    # Update the vector v
    v = v - step

    count += 1

## Print the optimal values of a, b, c
print(f"Optimal: {round(v[0], 4)} {round(v[1], 4)} {round(v[2], 4)}")

## Print the number of iterations it took to converge
print(f"Epochs: {count}")