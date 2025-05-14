.PHONY: build watch format

TEMPLATE ?= ./templates/vantage.typ
INPUT_FILE ?= ./resumes/configuration.yaml
OUTPUT_FILE ?= ./output/resume.pdf
OUTPUT_IMAGE ?= ./output/resume.png
OUTPUT_HTML ?= ./output/resume.html

build:
	typst compile --root . --input filename=$(INPUT_FILE) $(TEMPLATE) $(OUTPUT_FILE)
watch:
	find . -name '*.typ' -o -name '*.yaml' | entr -r make build INPUT_FILE=$(INPUT_FILE)
png:
	make build && magick convert -background white -alpha remove -alpha off -density 300 -depth 8 -quality 85  $(OUTPUT_FILE)[0] $(OUTPUT_IMAGE)
html:
	typst compile --root . --input filename=$(INPUT_FILE) --features html --format html --font-path ./assets/fonts $(TEMPLATE) $(OUTPUT_HTML)

format:
	typstyle -i *.typ