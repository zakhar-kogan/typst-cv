.PHONY: build watch format all output_input png html

# Template is the Typst template file
TEMPLATE := ./templates/vantage.typ

# Find all YAML files in ./resumes
YAML_FILES := $(shell find ./resumes -name '*.yaml')

# Generate corresponding PDF output file names in ./output
# Ensure the patsubst pattern matches the paths from 'find' (e.g., ./resumes/file.yaml)
PDF_FILES := $(patsubst ./resumes/%.yaml,./output/%.pdf,$(YAML_FILES))


# Pattern rule to compile a single YAML to a PDF
# This rule is used by Make to build each file in $(PDF_FILES)
build:
	@$(if $(YAML_FILES), \
		$(foreach yaml_file, $(YAML_FILES), \
			echo "Compiling $(yaml_file) to $(patsubst ./resumes/%.yaml,./output/%.pdf,$(yaml_file))"; \
			mkdir -p $(dir $(patsubst ./resumes/%.yaml,./output/%.pdf,$(yaml_file))); \
			typst compile --root . --format pdf --input filename="/$(patsubst ./%,%,$(yaml_file))" $(TEMPLATE) "$(patsubst ./resumes/%.yaml,./output/%.pdf,$(yaml_file))"; \
		), \
		echo "No YAML files to compile." \
	)

# --- Utility and Other Targets ---

# Watch for changes in Typst or YAML files and rebuild all PDFs
watch:
	$(find . -name '*.typ' -o -name '*.yaml' | entr -r make build)

# Target to display discovered input and output files (for debugging)
output_input:
	@$(info Input YAML files found:)
	@$(foreach file, $(YAML_FILES), $(info   $(file)))
	@$(info Corresponding PDF files to be generated:)
	@$(foreach file, $(PDF_FILES), $(info   $(file)))

# --- Targets for other formats (PNG, HTML) ---

# Generate corresponding PNG output file names in ./output
PNG_FILES := $(patsubst ./resumes/%.yaml,./output/%.png,$(YAML_FILES))

# Generate corresponding HTML output file names in ./output
HTML_FILES := $(patsubst ./resumes/%.yaml,./output/%.html,$(YAML_FILES))

# Target to generate PNGs from all PDFs
png:
	@$(if $(YAML_FILES), \
		$(foreach yaml_file, $(YAML_FILES), \
			$(eval pdf_file := $(patsubst ./resumes/%.yaml,./output/%.pdf,$(yaml_file))) \
			$(eval png_file := $(patsubst ./resumes/%.yaml,./output/%.png,$(yaml_file))) \
			echo "Converting $(pdf_file) to $(png_file)"; \
			mkdir -p $(dir $(png_file)); \
			magick -background white -alpha remove -alpha off -density 300 -depth 8 -quality 85 $(pdf_file) $(png_file); \
		), \
		echo "No YAML files found. Cannot generate PNGs." \
	)

# Target to generate HTMLs from all YAMLs
html:
	@$(if $(YAML_FILES), \
		$(foreach yaml_file, $(YAML_FILES), \
			$(eval html_file := $(patsubst ./resumes/%.yaml,./output/%.html,$(yaml_file))) \
			echo "Compiling $(yaml_file) to $(html_file) (HTML)"; \
			mkdir -p $(dir $(html_file)); \
			typst compile --root . --input filename="/$(patsubst ./%,%,$(yaml_file))" --features html --format html --font-path ./assets/fonts $(TEMPLATE) "$(html_file)"; \
		), \
		echo "No YAML files found. Cannot generate HTMLs." \
	)

# Rule to ensure PDFs are built before PNGs if 'make png' is called directly
# and PDFs don't exist yet. This makes 'png' depend on the 'build' target's outputs.
$(PNG_FILES): $(PDF_FILES)

format:
	typstyle -i *.typ