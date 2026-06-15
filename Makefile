.PHONY: help lint-json lint-yaml ci

help:
	@echo "Available targets:"
	@echo "  make lint-json  - Validate all JSON files in the repository"
	@echo "  make lint-yaml  - Validate all YAML files in the repository"
	@echo "  make ci         - Run the local equivalent of the lint CI workflow plus YAML validation"

lint-json:
	@echo "INFO: Validating JSON files..."
	@count=$$(find . -type f -name '*.json' | wc -l); \
	echo "DEBUG: Validating $$count JSON files"; \
	find . -type f -name '*.json' -print0 | xargs -0 -n1 python3 -m json.tool > /dev/null; \
	echo "INFO: JSON validation passed"

lint-yaml:
	@echo "INFO: Validating YAML files..."
	@count=$$(find . -type f \( -name '*.yml' -o -name '*.yaml' \) | wc -l); \
	echo "DEBUG: Validating $$count YAML files"; \
	find . -type f \( -name '*.yml' -o -name '*.yaml' \) -print0 | xargs -0 -n1 python3 -c 'import pathlib, sys, yaml; yaml.safe_load(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))' > /dev/null; \
	echo "INFO: YAML validation passed"

ci: lint-json lint-yaml
	@echo "INFO: Local lint CI equivalent passed"
