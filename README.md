# Makefile template
First designed to build my hashtable library but the idea was scrapped because it seemed a lot of overhead for that project. I was left with a fancy makefile so I decided to _make_ a new repository for its glory.

### Motivation
It's just cool to have a generic makefile which can be used for any project with minimal changes.

# What can it do?
This makefile can be run in two ways:
1. ```make``` builds the project and creates a build directory where it outputs the executable, ```.o``` and ```.d``` files.
2. ```make clean``` removes the build directory and its contents.

# Overview
## Paths and dependency configurations
The main feature which makes it versatile is that adding or modifying variables is enough to successfully build projects. The targets are dynamically created.
```
# Define compiler and flags
CC := gcc
INCLUDE_FLAGS := $(addprefix -I, $(INCLUDE_DIR))
CFLAGS := $(INCLUDE_FLAGS) -MMD -MP
```
```addprefix```: is a makefile function which simply concatenates a prefix to a list of words. In this case, the ```-I``` flag prefixes the ```include/``` directory path.

```-MMD```: tells the compiler to generate dependency files for each source file.

```-MP```: used in combination with ```-MMD```, by adding dummy phony targets for each dependency other than the main file. It ensures Make does not encounter errors when headers are renamed or deleted.

```
# Get source files and generate object files
SRCS := $(wildcard $(SOURCE_DIR)/*.c)
OBJS := $(patsubst $(SOURCE_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))
DEPS := $(OBJS:.o=.d)  # Dependency files
```
```wildcard```: is a makefile function which is used to find files matching a pattern. Reasons to use it over the ```find``` command in shell:
1. **Portable**: Native feature of Make
2. **Performance**: ```wildcard``` tends to be faster than ```find```(which counts as an external command). As the complexity of the project increases, the build's performance will be more visible.
3. **Error prevention**: If ```wildcard``` finds no matches, then it returns an empty string. So, this can be handled properly by displaying a message and skipping the compilation process entirely.

```patsubst```(pattern substitution): is used to get each source file from ```$(SRCS)``` list and create a list of paths for object files located in ```$(BUILD_DIR)```.

```OBJS:.o=.d```: using this Make specific initialization syntax, for each file path we are replacing the ```.o``` extension with ```.d```.

## Build
The building process is broken down into three phases:
1. **Creating the build directory**:
```
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
```

2. **Generating objects and dependency files**:
```
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
```
The first line reads as follows: For each ```.o``` file located in ```BUILD_DIR```, which depends on its corresponding ```.c``` file, do something only if ```BUILD_DIR``` exists.
The pipe **'|'** symbol indicates that it is an order-only prerequisite, meaning it ensures its existence. Though, it does not trigger a rebuild if the build directory's timestamp changes.

In the second line, two automatic variables are used to ensure build versatility.

```$<```: first dependency(```$(SOURCE_DIR/%.c)```)

```$@```: target(```$(BUILD_DIR)/%.o```)

Explicit example:
```
./build/main.o: ./src/main.c | ./build
	gcc -I ./include -MMD -MP -c ./src/main.c -o ./build/main.o
```

3. **Linking objects into executable**:

```
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $^ -o $@
```
```$^```: all dependencies(```$(OBJS)```)

## Clean phony
```
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
```

Calling ```make clean``` will remove the build directory and its contents.

## Include dependencies
Using the ```include``` directive at the end of the makefile ensures the dependencies are added after the definition of rules and variables. The ```-``` prefix will supress errors caused by dependencies which cannot be included for any reason or they are missing.

## Notes
Commands may be supressed from being printed in ```stdin``` by adding ```@``` in front.

Example:
```@mkdir -p $(BUILD_DIR)```
