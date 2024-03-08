TARGET_EXEC := runme

INCLUDE_DIR := ./include
BUILD_DIR := ./build
SOURCE_DIR := ./src

CC := gcc
INCLUDE_FLAGS := $(addprefix -I, $(INCLUDE_DIR))
CFLAGS := $(INCLUDE_FLAGS) -MMD -MP

SRCS := $(wildcard $(SOURCE_DIR)/*.c)
OBJS := $(patsubst $(SOURCE_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))
DEPS := $(OBJS:.o=.d)

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $^ -o $@

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c | $(BUILD_DIR)
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

-include $(DEPS)
