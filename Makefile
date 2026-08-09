# Makefile

SHELL := /usr/bin/env bash

GNUMAKEFLAGS ?=

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

.SHELLFLAGS := -Eeuo pipefail -c

.DELETE_ON_ERROR:
.SUFFIXES:
.NOTPARALLEL:

# Default goal

.DEFAULT_GOAL := never

.PHONY: never
.SILENT: never
never:
	printf '%s\n' 'No default target. Run an explicit target' >&2
	exit 1

# Options

DEVCONTAINER_FILTER := label=devcontainer.local_folder=$(CURDIR)

# Goals

.PHONY: fix
fix: eslint_fix stylelint_fix prettier_fix trimmer_fix

.PHONY: check
check: trimmer_check lint static test audit

.PHONY: lint
lint: eslint_check prettier_check stylelint_check

.PHONY: static
static: typescript_check

.PHONY: test
test: playwright_test

.PHONY: audit
audit: npm_audit

.PHONY: deps_install
deps_install: npm_install

.PHONY: deps_update
deps_update: npm_update

.PHONY: clean
clean:
	rm -rf ./dist
	rm -f ./dist.zip
	rm -rf ./test-results
	rm -rf ./tmp

.PHONY: deps_clean
deps_clean:
	rm -rf ./node_modules

.PHONY: distclean
distclean: clean deps_clean

.PHONY: trimmer_fix
trimmer_fix: ./node_modules/.package-lock.json ./package.json ./package-lock.json
	npm exec --ignore-scripts -- tooling-trimmer fix .

.PHONY: trimmer_check
trimmer_check: ./node_modules/.package-lock.json ./package.json ./package-lock.json
	npm exec --ignore-scripts -- tooling-trimmer check .

.PHONY: eslint_fix
eslint_fix: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./eslint.config.js
	npm exec --ignore-scripts -- eslint --concurrency=auto --fix .

.PHONY: prettier_fix
prettier_fix: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./prettier.config.js
	npm exec --ignore-scripts -- prettier -w .

.PHONY: stylelint_fix
stylelint_fix: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./stylelint.config.js
	npm exec --ignore-scripts -- stylelint --ignore-path ./.gitignore --allow-empty-input --fix './**/*.{sass,scss,css}'

.PHONY: eslint_check
eslint_check: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./eslint.config.js
	npm exec --ignore-scripts -- eslint --concurrency=auto .

.PHONY: prettier_check
prettier_check: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./prettier.config.js
	npm exec --ignore-scripts -- prettier -c .

.PHONY: stylelint_check
stylelint_check: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./stylelint.config.js
	npm exec --ignore-scripts -- stylelint --ignore-path ./.gitignore --allow-empty-input './**/*.{sass,scss,css}'

.PHONY: typescript_check
typescript_check: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./tsconfig.json ./tsconfig.playwright.json
	npm exec --ignore-scripts -- tsc --noEmit --project ./tsconfig.json
	npm exec --ignore-scripts -- tsc --noEmit --project ./tsconfig.playwright.json

.PHONY: playwright_test
playwright_test: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./playwright.config.js
	npm exec --ignore-scripts -- playwright test

.PHONY: npm_audit
npm_audit: ./node_modules/.package-lock.json ./package.json ./package-lock.json
	npm audit --ignore-scripts --audit-level=high --install-links --include=prod --include=dev --include=peer --include=optional

.PHONY: npm_install
npm_install: ./package.json ./package-lock.json
	npm ci --ignore-scripts --install-links --include=prod --include=dev --include=peer --include=optional

.PHONY: npm_update
npm_update: deps_clean ./package.json
	npm update --ignore-scripts --install-links --include=prod --include=dev --include=peer --include=optional

.PHONY: postcreate
postcreate: deps_install

.PHONY: start serve server dev
start serve server dev: ./node_modules/.package-lock.json ./package.json ./package-lock.json
	npm exec --ignore-scripts -- webpack-cli serve --mode=development --config-node-env=development --env APP_ENV=local

.PHONY: zip
zip: build
	rm -f ./dist.zip
	cd ./dist && zip -q -r ../dist.zip . -x '*.map' '*.map.br' '*.map.gz'

.PHONY: devcontainer_check
devcontainer_check:
	devcontainer read-configuration --workspace-folder . >/dev/null
	docker build --check --file ./.devcontainer/Dockerfile --platform linux/amd64 ./.devcontainer

.PHONY: up
up: devcontainer_check
	devcontainer up --workspace-folder .

.PHONY: devcontainer
devcontainer: up
	devcontainer exec --workspace-folder . /bin/bash

.PHONY: stop
stop:
	docker container ls --quiet --filter "$(DEVCONTAINER_FILTER)" | while IFS= read -r container; do docker container stop "$$container"; done

.PHONY: down
down: stop
	docker container ls --all --quiet --filter "$(DEVCONTAINER_FILTER)" | while IFS= read -r container; do docker container rm "$$container"; done

.PHONY: rebuild
rebuild: devcontainer_check down
	devcontainer up --workspace-folder . --build-no-cache

.PHONY: build
build: ./node_modules/.package-lock.json ./package.json ./package-lock.json
	npm exec --ignore-scripts -- webpack-cli build --fail-on-warnings --mode=production --config-node-env=production --env APP_ENV=production

.PHONY: playwright_failed
playwright_failed: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./playwright.config.js
	npm exec --ignore-scripts -- playwright test --last-failed

.PHONY: playwright_headed
playwright_headed: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./playwright.config.js
	xvfb-run --auto-servernum -- npm exec --ignore-scripts -- playwright test --headed

.PHONY: playwright_ui
playwright_ui: ./node_modules/.package-lock.json ./package.json ./package-lock.json ./playwright.config.js
	npm exec --ignore-scripts -- playwright test --ui --ui-host=0.0.0.0 --ui-port=61092

./node_modules/.package-lock.json: ./package.json ./package-lock.json
	$(MAKE) npm_install
