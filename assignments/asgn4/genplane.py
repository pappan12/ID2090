import csv
import random

def generate_points_on_plane(a, b, c, num_points):
    points = []
    for _ in range(num_points):
        x = 10 * (2 * random.random() - 1)  # random x value within a range
        y = 10 * (2 * random.random() - 1)  # random y value within a range
        z = (1 - a*x - b*y) / c  # calculate z based on the plane equation
        points.append((x, y, z))
    return points

def write_to_csv(points, filename):
    with open(filename, 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(['x', 'y', 'z'])
        csv_writer.writerows(points)

a = -1  # coefficient a in the plane equation
b = 0  # coefficient b in the plane equation
c = 1 # coefficient c in the plane equation
num_points = 100  # adjust as needed
points = generate_points_on_plane(a, b, c, num_points)
write_to_csv(points, 'points_on_plane.csv')
