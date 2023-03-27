# vim: noai:ts=2
# vim: noexpandtab

SHELL := /usr/bin/env bash # bash-Shell verwenden
.SHELLFLAGS = -c # Subkommandos mit "-c" ausführen

.EXPORT_ALL_VARIABLES: ; # alle Variablen exortieren und an Sub-Shell übergeben

.PHONY: all # Das Makefile generiert keine Dateien
.DEFAULT: help # Das Standard-Kommando, wenn make ohne Befehl ausgeführt wird

# help: @ Zeigt alle möglichen Targets an
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# test: @ Alle definierten Tests ausführen
test: test-codespell test-yamllint test-jsonlint test-terraform-format test-terraform-validation
	@echo 'All tests Done!'

# test-codespell: @ Rechtschreibung prüfen
test-codespell:
	codespell -H -f -s -C 4 -q 6 --skip "Makefile" *.tf

# test-yamllint: @ YAML Dateien prüfen
test-yamllint:
	yamllint -c .yamllint.yaml .

# test-jsonlint: @ JSON Dateien prüfen
test-jsonlint:
	for file in $(shell find . -name '*.json' ! -path "**/venv/*"); do\
		echo $${file} ;\
		jq < $${file} >/dev/null;\
		err=$$(($$? + err)) ;\
	done; exit $$err

# test-terraform-format: @ Terraform-Code Stil und Formatierung prüfen
test-terraform-format:
	terraform fmt -check=true -diff=true -recursive

# test-terraform-validation: @ Terraform-Syntax prüfen
test-terraform-validation:
	terraform init 2>&1 >/dev/null
	terraform validate

# all: @ Alle definierten Tests ausführen
all: test
