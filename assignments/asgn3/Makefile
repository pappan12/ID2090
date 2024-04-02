# Compiler
CC = g++

# Compiler flags
CXXFLAGS = -Wall -std=c++11

# Source files
SRC = $(wildcard *.cpp ./geometry/*.cpp)

# Object files
OBJ = $(SRC:.cpp=.o)

# Target executable
TARGET = main

# Default rule
all: $(TARGET)

# Rule to link the program
$(TARGET): $(OBJ) 
	@$(CC) $(CXXFLAGS) -o $@ $^

# Rule to compile the source files
%.o: %.cpp
	@$(CC) $(CXXFLAGS) -c $< -o $@

# Rule to compile and link the program (without creating separate .o files)
# $(TARGET): $(SRC)
# 	@$(CC) $(CXXFLAGS) $^ -o $@

# Rule to run the program
run: $(TARGET)
	./$(TARGET) map.txt

# Rule to clean the workspace
clean:
	@rm -f $(OBJ) $(TARGET)