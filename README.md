# typst-cv
A frankentake on CVs using Typst

## Acknowledgments

- https://github.com/cammellos/typst-blue-header-cv
- https://github.com/sardorml/vantage-typst

## Usage

To build the CV, you need to have `typst` and `make` installed. If you have Nix installed, you can enter a development shell with all dependencies by running:

```sh
nix develop
```

Once the dependencies are available, you can build the PDF version of the resume by running:

```sh
make build
```

This will use the template defined in `TEMPLATE` (default: [`./templates/vantage.typ`](./templates/vantage.typ)) and the data from `INPUT_FILE` (default: [`./resumes/configuration.yaml`](./resumes/configuration.yaml)) to generate `OUTPUT_FILE` (default: [`./output/resume.pdf`](./output/resume.pdf)).

You can also generate an HTML version:

```sh
make html
```

Or a PNG version:
```sh
make png
```

To automatically rebuild the CV when source files (`.typ` or `.yaml`) change:
```sh
make watch
```

To format the Typst files:
```sh
make format
```

## Edits
The main data for the CV is stored in `INPUT_FILE` (default: [`./resumes/configuration.yaml`](./resumes/configuration.yaml)). You can edit this YAML file to update your personal information, experience, education, skills, etc.

To change the template used for rendering the CV, you can modify the `TEMPLATE` variable in the `Makefile` or specify it when running `make`. For example, to use a different template named `my_custom_template.typ` located in the `./templates/` directory:

```sh
make build TEMPLATE=./templates/my_custom_template.typ
```

Ensure your new template is compatible with the data structure in your `INPUT_FILE`.

## Futher development
To manage multiple CV versions for different positions, you can easily specify different input files or templates directly via `make` command arguments.

For example, to use a specific data file for a "Software Engineer" position and a different one for a "Data Scientist" position, you can run:

```sh
# For Software Engineer position
make build INPUT_FILE=./resumes/software_engineer.yaml

# For Data Scientist position
make build INPUT_FILE=./resumes/data_scientist.yaml
```

Similarly, if you have different templates tailored for these roles:

```sh
# For Software Engineer position with a specific template
make build TEMPLATE=./templates/swe_template.typ INPUT_FILE=./resumes/software_engineer.yaml

# For Data Scientist position with another template
make build TEMPLATE=./templates/data_science_template.typ INPUT_FILE=./resumes/data_scientist.yaml
```

This allows for flexible management of various CV versions without altering the `Makefile` for each build.
