#!/usr/bin/python3

import numpy as np
import matplotlib.pyplot as plt


# Node Class
class Node:
    def __init__(self, position):
        self.position = position
        self.parent = None


# Greedy Sampling
def biased_sampling(goal, bias):
    if np.random.random() < bias:  # Bias towards the goal
        return goal
    else:
        return np.random.uniform([0, 0], [width, height])


# Define the minimum distance to be maintained from the obstacles
def min_distance_to_obstacle(point, obstacle_positions, obstacle_sizes):
    min_distance = float("inf")
    for obs_pos, obs_size in zip(obstacle_positions, obstacle_sizes):
        dx = max(obs_pos[0] - point[0], 0, point[0] - obs_pos[0] - obs_size[0])
        dy = max(obs_pos[1] - point[1], 0, point[1] - obs_pos[1] - obs_size[1])
        min_distance = min(min_distance, np.sqrt(dx * dx + dy * dy))
    return min_distance


# Check if the path between nodes do not intersect with the obstacles
def is_collision_free(
    start, end, obstacle_positions, obstacle_sizes, min_obstacle_dist
):
    for obstacle_position, obstacle_size in zip(obstacle_positions, obstacle_sizes):
        if not (
            end[0] < obstacle_position[0]
            or start[0] > obstacle_position[0] + obstacle_size[0]
            or end[1] < obstacle_position[1]
            or start[1] > obstacle_position[1] + obstacle_size[1]
        ):
            return False

        # Check if the new node is at least min_obstacle_dist away from all obstacles
        if min_obstacle_dist is not None:
            dx = max(
                obstacle_position[0] - end[0],
                0,
                end[0] - obstacle_position[0] - obstacle_size[0],
            )
            dy = max(
                obstacle_position[1] - end[1],
                0,
                end[1] - obstacle_position[1] - obstacle_size[1],
            )
            distance = np.sqrt(dx * dx + dy * dy)
            if distance < min_obstacle_dist:
                return False

    return True


# Reconstruct the path from the start node to the goal node
def reconstruct_path(node):
    path = []
    while node.parent is not None:
        path.append(node.position)
        node = node.parent
    path.append(start)
    return path[::-1]


# Smoothen the path using a polynomial
def smooth_path(path):
    path = np.array(path)
    t = np.arange(path.shape[0])

    # Fit a polynomial to the x and y coordinates separately
    poly_x = np.polyfit(t, path[:, 0], deg=15)  # Degree of the polynomial is 15
    poly_y = np.polyfit(t, path[:, 1], deg=15)

    # Find the polynomial functions
    poly_x_fn = np.poly1d(poly_x)
    poly_y_fn = np.poly1d(poly_y)

    # Generate smooth t values
    smooth_t = np.linspace(t.min(), t.max(), 500)

    # Find the smooth path
    smooth_path = np.vstack([poly_x_fn(smooth_t), poly_y_fn(smooth_t)]).T

    return smooth_path


# RRT Algorithm
def rrt(
    start,
    goal,
    obstacle_positions,
    obstacle_sizes,
    smoothen=False,
    max_iterations=10000,
):
    global required_iterations
    tree = [Node(start)]
    all_paths = []  # Store all attempted paths

    for i in range(max_iterations):
        random_point = biased_sampling(goal, bias)
        nearest_node = min(
            tree, key=lambda node: np.linalg.norm(node.position - random_point)
        )
        direction = random_point - nearest_node.position
        direction = direction.astype(float)
        direction /= np.linalg.norm(direction)

        new_node_position = nearest_node.position + direction * 1
        # Step size is 1 because the direction is already normalized

        if is_collision_free(
            nearest_node.position,
            new_node_position,
            obstacle_positions,
            obstacle_sizes,
            min_obstacle_dist,
        ):
            new_node = Node(new_node_position)
            new_node.parent = nearest_node
            tree.append(new_node)
            all_paths.append(
                (nearest_node.position, new_node_position)
            )  # Store the attempted path

            if np.linalg.norm(new_node.position - goal) < 1:
                required_iterations = i
                path = reconstruct_path(new_node)
                return path, all_paths

    return None, all_paths


# Visualize the RRT
def visualize_rrt(
    start,
    goal,
    obstacle_positions,
    obstacle_sizes,
    path=None,
    all_paths=None,
    display_tree=False,
):
    plt.figure(figsize=(8, 8))
    plt.xlim(0, width)
    plt.ylim(0, height)
    plt.grid(False)
    plt.title("Rapidly-exploring Random Tree")

    for obstacle_position, obstacle_size in zip(obstacle_positions, obstacle_sizes):
        obstacle_rect = plt.Rectangle(
            obstacle_position, obstacle_size[0], obstacle_size[1], fc="gray"
        )
        plt.gca().add_patch(obstacle_rect)

    plt.plot(start[0], start[1], "go", markersize=10)
    plt.plot(goal[0], goal[1], "ro", markersize=10)

    if display_tree and all_paths is not None:
        for start, end in all_paths:
            plt.plot(
                [start[0], end[0]], [start[1], end[1]], "y.-"
            )  # Plot all attempted paths

    if path is not None:
        if smoothen:
            path = smooth_path(path)
        plt.plot([p[0] for p in path], [p[1] for p in path], "b-")

    plt.show()


# Define the intialising parameters
width = 40  # Dimensions of the environment
height = 30
start = np.array([1, 1])  # Start position
goal = np.array([35, 28])  # Goal position
# start, goal = goal, start

# The data was made on the following environment
# obstacle_positions = [(3, 3), (10, 10), (15, 15), (25, 20)]  # Obstacle positions
# obstacle_sizes = [(5, 5), (4, 4), (3, 7), (6, 2)]

# New environment
obstacle_positions = [(3, 3), (10, 10), (20, 3), (25, 20)]  # Obstacle positions
obstacle_sizes = [(5, 5), (4, 4), (3, 7), (6, 2)]

# #Custom Environment
# start = np.array([20, 1])
# goal = np.array([20, 29])
# obstacle_positions = [(1,1),(24,1)]
# obstacle_sizes = [(15,28),(15,28)]

min_obstacle_dist = None  # Minimum distance to be maintained from the obstacles
bias = 0  # Bias towards the goal
smoothen = False  # Smoothen the path

# Run the RRT algorithm
path, all_paths = rrt(start, goal, obstacle_positions, obstacle_sizes, smoothen)
# print(required_iterations)
visualize_rrt(
    start,
    goal,
    obstacle_positions,
    obstacle_sizes,
    path,
    all_paths,
    display_tree=True,
)