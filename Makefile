.PHONY: new-year days-for-year deno-build

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
		echo "Error: Please provide YEAR, DAY, and ARG as arguments (e.g., 'make swift-build YEAR=2024 DAY=01 ARG=HelloWorld')"; \
		exit 1; \
	fi; \
	script_dir="years/$(YEAR)/day-$(DAY)"; \
	if [ ! -d "$$script_dir" ]; then \
		echo "Error: Directory $$script_dir does not exist"; \
		exit 1; \
	fi; \
	script_path="$$script_dir/main.swift"; \
	if [ ! -f "$$script_path" ]; then \
		echo "Error: Swift script $$script_path does not exist"; \
		exit 1; \
	fi; \
	util_path="years/$(YEAR)/util/util.swift"; \
	echo "Compiling $$script_path with $$util_path..."; \
	rm "$$script_dir/swiftbuild"; \
	swiftc "$$script_path" "$$util_path" -o "$$script_dir/swiftbuild"; \
	cd "$$script_dir"; \
	echo "Running $$script_dir/swiftbuild with argument '$(ARG)'..."; \
	"swiftbuild" "$(ARG)"

# Executes Deno code
deno-build:
	@if [ -z "$(YEAR)" ] || [ -z "$(DAY)" ]; then \
		echo "Error: Please provide YEAR, DAY, and ARG as arguments (e.g., 'make deno-build YEAR=2024 DAY=day-01 ARG=HelloWorld')"; \
		exit 1; \
	fi
	@script_dir="years/$(YEAR)/day-$(DAY)"; \
	if [ ! -d "$$script_dir" ]; then \
		echo "Error: Directory $$script_dir does not exist"; \
		exit 1; \
	fi; \
	script_path="$$script_dir/index.ts"; \
	if [ ! -f "$$script_path" ]; then \
		echo "Error: Deno script $$script_path does not exist"; \
		exit 1; \
	fi; \
	echo "Running $$script_dir/swiftbuild with argument '$(ARG)'..."; \
	"deno --allow-read $$script_path" "$(ARG)"
