# Makefile for processing images and generating COE files

# Define variables for source files and Python interpreter
PYTHON = python3
SCRIPT = COEfile_generation.py  # Replace with the name of your Python file (regular space here)

# Temporary files
RED1_TEMP = red1_temp.txt
GREEN1_TEMP = green1_temp.txt
BLUE1_TEMP = blue1_temp.txt
RED2_TEMP = red2_temp.txt
GREEN2_TEMP = green2_temp.txt
BLUE2_TEMP = blue2_temp.txt

# Output COE files
RED1_COE = red1.coe
GREEN1_COE = green1.coe
BLUE1_COE = blue1.coe
RED2_COE = red2.coe
GREEN2_COE = green2.coe
BLUE2_COE = blue2.coe

# Default target
all: install_pip install_deps process_images merge_cleanup

# Install pip if not already installed
install_pip:
	@if ! command -v pip3 >/dev/null 2>&1; then \
		echo "pip3 not found. Installing pip3..."; \
		sudo apt update; \
		sudo apt install -y python3-pip; \
	else \
		echo "pip3 is already installed."; \
	fi

# Install required Python packages
install_deps:
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install --upgrade Pillow
# Process images and generate COE files
process_images:
	$(PYTHON) $(SCRIPT)

# Clean up intermediate files
merge_cleanup:
	rm -f $(RED1_TEMP) $(GREEN1_TEMP) $(BLUE1_TEMP) $(RED2_TEMP) $(GREEN2_TEMP) $(BLUE2_TEMP) $(RED2_COE) $(GREEN2_COE) $(BLUE2_COE)

# Clean target to delete all generated files
clean:
	rm -f $(RED1_COE) $(GREEN1_COE) $(BLUE1_COE) $(RED1_TEMP) $(GREEN1_TEMP) $(BLUE1_TEMP) $(RED2_TEMP) $(GREEN2_TEMP) $(BLUE2_TEMP) $(RED2_COE) $(GREEN2_COE) $(BLUE2_COE)
