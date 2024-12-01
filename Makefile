.PHONY: new-year days-for-year

# Creates day-xx directories in the current directory
days-for-year:
	@seq -w 1 25 | xargs -I {} mkdir -p day-{}

# Creates a year directory, then runs prime-directories inside it
new-year:
	@if [ -z "$(YEAR)" ]; then \
		echo "Error: Please provide a year as an argument (e.g., 'make new-year YEAR=2024')"; \
		exit 1; \
	fi
	@mkdir -p years/$(YEAR)
	@cd years/$(YEAR) && seq -w 1 25 | xargs -I {} mkdir -p day-{}
	@echo "Created directories for year: $(YEAR)"

# Compiles a Swift script in a given year/day directory and runs the resulting executable
swift-build:
	@if [ -z "$(YEAR)" ] || [ -z "$(DAY)" ]; then \
		echo "Error: Please provide YEAR, DAY, and ARG as arguments (e.g., 'make build-and-run-swift YEAR=2024 DAY=day-01 ARG=HelloWorld')"; \
		exit 1; \
	fi
	@script_dir="years/$(YEAR)/day-$(DAY)"; \
	if [ ! -d "$$script_dir" ]; then \
		echo "Error: Directory $$script_dir does not exist"; \
		exit 1; \
	fi; \
	script_path="$$script_dir/main.swift"; \
	if [ ! -f "$$script_path" ]; then \
		echo "Error: Swift script $$script_path does not exist"; \
		exit 1; \
	fi; \
	echo "Compiling $$script_path..."; \
	swiftc "$$script_path" -o "$$script_dir/swiftbuild"; \
	echo "Running $$script_dir/swiftbuild with argument '$(ARG)'..."; \
	"$$script_dir/swiftbuild" "$(ARG)"
