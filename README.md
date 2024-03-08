# Makefile template
First designed to build my hashtable library but the idea was scrapped because seemed a lot of overhead for that project. I got left with a full fancy makefile so I decided to make a new repository for it's glory.

### Motivation
It's just cool to have a makefile template which can be quickly modified so as I can build projects.

# What can it do?
This makefile can be run in two ways:
1. ```make``` builds the project and creates a build directory where it outputs the executable, ```.o``` and ```.d``` files.
2. ```make clean``` removes the build directory and it's contents.

# Overview
## Paths and dependency configurations
The main reason of it being versatile is that we just need to add or modify variables so as it will build projects successfully.
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
OBJ_DIRS := $(basename $(OBJS))
```
```wildcard``` is a makefile function which is used to find files matching a pattern. Reasons to use it over the ```find``` command in shell:
1. Portable: being native to Make, it is widely supported across Make.
2. Performance: ```wildcard``` tends to be faster than ```find```(which counts as an external command). May become more noticeable as the complexity of build process increases.
3. Error prevention: If ```wildcard``` finds no matches, then it returns an empty string. So, this can be handled properly by displaying a message and skipping the compilation process entirely.


