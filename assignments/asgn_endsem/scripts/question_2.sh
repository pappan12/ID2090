#!/usr/bin/python3

# Set the transitions for the FSM
def set_transition(transitions, char, state):
    transitions[char] = state


# Get the transition for the FSM
def get_transition(transitions, char):
    # If the exact transition is not found, try with the '.' wildcard
    if char not in transitions:
        return transitions.get((char[0], "."))
    return transitions.get(char)


# Build the FSM from the pattern
def build_fsm(pattern):
    transitions = {}  # Transition table
    end_states = set()  # Set of end states
    current_state = 0  # Start state is 0
    next_char = None
    for i in range(len(pattern)):
        char = pattern[i]
        if char == "*" or char == "+":
            continue
        next_char = pattern[i + 1] if i + 1 < len(pattern) else None
        if next_char == "*":
            set_transition(transitions, (current_state, char), current_state)
            # Set the transition back to the current state
        elif next_char == "+":
            next_state = current_state + 1
            set_transition(transitions, (current_state, char), next_state)
            current_state = next_state
            set_transition(transitions, (current_state, char), current_state)
            """ Set transition to the next state and back to the current state 
              as '+' means one or more"""
        elif char == ".":
            next_state = current_state + 1
            for c in range(256):
                set_transition(transitions, (current_state, chr(c)), next_state)
                """ Set the transition to any ASCII character
                    as '.' means any character"""
            current_state = next_state
        else:
            next_state = current_state + 1
            set_transition(transitions, (current_state, char), next_state)
            # Set the transition to the next state
            current_state = next_state
    end_states.add(current_state)
    return transitions, end_states


# Match the string with the FSM
def match(transitions, end_states, string):
    current_state = 0
    match_start = 0
    matches = []
    for i, char in enumerate(string):
        next_state = get_transition(transitions, (current_state, char))
        if next_state is None:
            next_state = get_transition(transitions, (current_state, None))
        if next_state is None:
            if current_state in end_states:
                matches.append((match_start, i))
            match_start = i + 1
            current_state = 0
        else:
            current_state = next_state
    if current_state in end_states:
        matches.append((match_start, len(string)))
    return matches


# Colorize the matched parts in the string
def colorize_matches(string, matches):
    colorized_string = ""
    last_end = 0
    for start, end in matches:
        colorized_string += (
            string[last_end:start] + "\033[31m" + string[start:end] + "\033[0m"
        )
        # Colorize the matched part in red
        last_end = end
    colorized_string += string[last_end:]
    return colorized_string


# Get user input
pattern = input("Regular Expression: ")
sample_string = input("Sample string: ")


# Build the FSM and match the sample string
transitions, end_states = build_fsm(pattern)

match_results = match(transitions, end_states, sample_string)

# Print the sample string with the matched parts colorized in red
print(colorize_matches(sample_string, match_results))