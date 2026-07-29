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

# Options

export APP_ENV ?= production
export NODE_ENV ?= production

# Default goal

.DEFAULT_GOAL := never

.PHONY: never
.SILENT: never
never:
	printf '%s\n' 'No default target. Run an explicit target' >&2
	exit 1

# Goals

.PHONY: fix
fix: eslint_fix prettier_fix stylelint_fix

.PHONY: check
check: lint static test audit

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
	rm -rf ./node_modules
	rm -rf ./dist
	rm -rf ./release
	rm -rf ./test-results

.PHONY: distclean
distclean: clean
	rm -rf ./package-lock.json

.PHONY: eslint_fix
eslint_fix: ./node_modules ./package.json ./package-lock.json ./eslint.config.js
	npm exec --ignore-scripts -- eslint --concurrency=auto --fix .

.PHONY: prettier_fix
prettier_fix: ./node_modules ./package.json ./package-lock.json ./prettier.config.js
	npm exec --ignore-scripts -- prettier -w .

.PHONY: stylelint_fix
stylelint_fix: ./node_modules ./package.json ./package-lock.json ./stylelint.config.js
	npm exec --ignore-scripts -- stylelint --allow-empty-input --fix ./**/*.{sass,scss,css}

.PHONY: eslint_check
eslint_check: ./node_modules ./package.json ./package-lock.json ./eslint.config.js
	npm exec --ignore-scripts -- eslint --concurrency=auto .

.PHONY: prettier_check
prettier_check: ./node_modules ./package.json ./package-lock.json ./prettier.config.js
	npm exec --ignore-scripts -- prettier -c .

.PHONY: stylelint_check
stylelint_check: ./node_modules ./package.json ./package-lock.json ./stylelint.config.js
	npm exec --ignore-scripts -- stylelint --allow-empty-input ./**/*.{sass,scss,css}

.PHONY: typescript_check
typescript_check: ./node_modules ./package.json ./package-lock.json ./tsconfig.json ./tsconfig.playwright.json
	npm exec --ignore-scripts -- tsc --noEmit --project ./tsconfig.json
	npm exec --ignore-scripts -- tsc --noEmit --project ./tsconfig.playwright.json

.PHONY: playwright_test
playwright_test: ./node_modules ./package.json ./package-lock.json ./playwright.config.js
	npm exec --ignore-scripts -- playwright test

.PHONY: playwright_install
playwright_install: ./node_modules ./package.json ./package-lock.json ./playwright.config.js
	npm exec --ignore-scripts -- playwright install --with-deps chromium firefox webkit chrome msedge

.PHONY: npm_audit
npm_audit: ./node_modules ./package.json ./package-lock.json
	npm audit --ignore-scripts --audit-level=critical --install-links --include=prod --include=dev --include=peer --include=optional

.PHONY: npm_install
npm_install: ./package.json ./package-lock.json
	npm install --ignore-scripts --install-links --include=prod --include=dev --include=peer --include=optional

.PHONY: npm_update
npm_update: ./package.json
	rm -rf ./node_modules
	rm -rf ./package-lock.json
	npm update --ignore-scripts --install-links --include=prod --include=dev --include=peer --include=optional

.PHONY: precreate
precreate:
	docker volume create tomaschochola-npm-cache

.PHONY: postcreate
postcreate: deps_install playwright_install

.PHONY: start serve server dev
start serve server dev: override export APP_ENV := local
start serve server dev: override export NODE_ENV := development
start serve server dev: ./node_modules ./package.json ./package-lock.json
	npm exec --ignore-scripts -- webpack-cli serve --mode=$${NODE_ENV} --config-node-env=$${NODE_ENV}

.PHONY: local_dist local_zip
local_dist local_zip: override export APP_ENV := local
local_dist local_zip: override export NODE_ENV := development

.PHONY: development_dist development_zip
development_dist development_zip: override export APP_ENV := development
development_dist development_zip: override export NODE_ENV := development

.PHONY: sit_dist sit_zip
sit_dist sit_zip: override export APP_ENV := sit
sit_dist sit_zip: override export NODE_ENV := production

.PHONY: uat_dist uat_zip
uat_dist uat_zip: override export APP_ENV := uat
uat_dist uat_zip: override export NODE_ENV := production

.PHONY: production_dist production_zip
production_dist production_zip: override export APP_ENV := production
production_dist production_zip: override export NODE_ENV := production

local_dist development_dist sit_dist uat_dist production_dist:
	${MAKE} build

local_zip: local_dist
development_zip: development_dist
sit_zip: sit_dist
uat_zip: uat_dist
production_zip: production_dist

local_zip development_zip sit_zip uat_zip production_zip:
	mkdir -p ./release
	rm -f "./release/$${APP_ENV}.zip"
	cd "./dist/$${APP_ENV}" && zip -q -r "../../release/$${APP_ENV}.zip" .

.PHONY: devcontainer
devcontainer: precreate
	devcontainer up --workspace-folder .
	devcontainer exec --workspace-folder . /bin/bash || true
	docker ps -q --filter "label=devcontainer.local_folder=$${PWD}" | xargs -r docker stop

.PHONY: build
build: ./node_modules ./package.json ./package-lock.json
	npm exec --ignore-scripts -- webpack-cli build --mode=$${NODE_ENV} --config-node-env=$${NODE_ENV}

.PHONY: playwright_failed
playwright_failed: ./node_modules ./package.json ./package-lock.json ./playwright.config.js
	npm exec --ignore-scripts -- playwright test --last-failed

.PHONY: playwright_headed
playwright_headed: ./node_modules ./package.json ./package-lock.json ./playwright.config.js
	npm exec --ignore-scripts -- playwright test --headed

.PHONY: playwright_ui
playwright_ui: ./node_modules ./package.json ./package-lock.json ./playwright.config.js
	npm exec --ignore-scripts -- playwright test --ui

# Dependencies

./package-lock.json ./node_modules &: ./package.json
	${MAKE} npm_update
