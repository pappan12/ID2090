import matplotlib.pyplot as plt

# x values
x = ['Normal', 'With Clearance', 'Biased', 'Biased with Clearance']

# corresponding y values
# y = [613.233, 590.907, 191.762, 191.145]
y=[58.669,59.572,55.28,56.702]

bars = plt.bar(x, y)
plt.xlabel('Variants of RRT')
plt.ylabel('Average Nodes in Path')
plt.title('Average Nodes in Path of different RRT variants')

# Display the values on top of the bars
for bar in bars:
    yval = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2.0, yval, round(yval, 2), va='bottom', ha='center')  # va: vertical alignment

plt.show()