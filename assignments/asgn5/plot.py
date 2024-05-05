import numpy as np
import matplotlib.pyplot as plt
from sympy import symbols, exp, sqrt, pi

# Define the symbols
x = symbols('x')

# Define the functions
f1 = (sqrt(2) * exp(-0.5 * ((x / 2) - 1/2)**2)) / (8 * sqrt(pi))
f2 = (sqrt(2) * exp(-0.5 * ((x / 2) - 5/2)**2)) / (8 * sqrt(pi))
f3 = exp(-(x - 6)**2/16) / (16 * sqrt(pi))

# Convert the sympy expressions to numpy functions
f1_np = np.vectorize(lambda x_val: f1.subs(x, x_val))
f2_np = np.vectorize(lambda x_val: f2.subs(x, x_val))
f3_np = np.vectorize(lambda x_val: f3.subs(x, x_val))

# Generate x values
x_values = np.linspace(-10, 20, 1000)

# Generate y values for each function
y1_values = f1_np(x_values)
y2_values = f2_np(x_values)
y3_values = f3_np(x_values)

# Plot the functions
plt.figure(figsize=(10, 6))
plt.plot(x_values, y1_values, label=r'$\frac{\sqrt{2} e^{- 0.5 \left(\frac{x}{2} - \frac{1}{2}\right)^{2}}}{8 \sqrt{\pi}}$')
plt.plot(x_values, y2_values, label=r'$\frac{\sqrt{2} e^{- 0.5 \left(\frac{x}{2} - \frac{5}{2}\right)^{2}}}{8 \sqrt{\pi}}$')
plt.plot(x_values, y3_values, label=r'$\frac{exp(-(x - 6)^2/16)}{16\sqrt{\pi}}$')
plt.xlabel('x')
plt.ylabel('y')
plt.title('Plot of Functions')
plt.legend()
plt.grid(True)
plt.show()