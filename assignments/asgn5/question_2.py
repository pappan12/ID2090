#!/usr/bin/python3

import sys
import sympy as sp
from latex2sympy2 import latex2sympy
from subprocess import run

press = sys.argv[1]
with open(press, "r") as f:
    pressure_function = f.read()

pressure_function = latex2sympy(pressure_function)

z = sp.symbols("z")

P_z = sp.diff(pressure_function, "z")
# print(P_z)

r = sp.symbols("r")
v_z = -P_z / 4 * (1 - r**2)
# print(v_z)

v_cpp = sp.ccode(v_z)

with open("vel.cpp", "w") as fcpp:
    fcpp.write("#include <iostream>\n")
    fcpp.write("#include <cmath>\n")
    fcpp.write("using namespace std;\n")
    fcpp.write("int main(int argc, char* argv[]) {\n")
    fcpp.write("    double r = stod(argv[1]);\n")
    fcpp.write(f"    double v_z = {v_cpp};\n")
    fcpp.write("    cout << abs(v_z) << endl;\n")
    fcpp.write("    return 0;\n")
    fcpp.write("}\n")

run(["g++", "vel.cpp", "-o", "vel.out"])