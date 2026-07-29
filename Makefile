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

.DEFAULT_GOAL := help

# Options

export DEBIAN_FRONTEND := noninteractive

# Goals

.PHONY: help
.SILENT: help
help:
	printf '\033[1m%s\033[0m\n' "$${PWD##*/} targets"
	printf '%s\n' '--------------------------------------------------------------------------------'
	printf '\033[1m%-18s\033[0m  %s\n' 'help' 'Show this help.'
	printf '\033[1m%-18s\033[0m  %s\n' 'all' 'Build production artifacts and package dist.zip.'
	printf '\033[1m%-18s\033[0m  %s\n' 'fix' 'Run all automatic fixers.'
	printf '\033[1m%-18s\033[0m  %s\n' 'check' 'Run lint, static analysis, tests, and audits.'
	printf '\033[1m%-18s\033[0m  %s\n' 'lint' 'Run code style checks.'
	printf '\033[1m%-18s\033[0m  %s\n' 'static' 'Run static analysis.'
	printf '\033[1m%-18s\033[0m  %s\n' 'test' 'Run tests.'
	printf '\033[1m%-18s\033[0m  %s\n' 'audit' 'Run dependency/security audits.'
	printf '\033[1m%-18s\033[0m  %s\n' 'deps_install' 'Install dependencies from current lock files.'
	printf '\033[1m%-18s\033[0m  %s\n' 'deps_update' 'Refresh dependencies and generated lock files.'
	printf '\033[1m%-18s\033[0m  %s\n' 'clean' 'Remove generated build, dependency, and test artifacts.'
	printf '\033[1m%-18s\033[0m  %s\n' 'distclean' 'Run clean and remove generated lock files.'
	printf '\033[1m%-18s\033[0m  %s\n' 'eslint_fix' 'Fix JavaScript/TypeScript lint issues with ESLint.'
	printf '\033[1m%-18s\033[0m  %s\n' 'prettier_fix' 'Format files with Prettier.'
	printf '\033[1m%-18s\033[0m  %s\n' 'stylelint_fix' 'Fix stylesheet lint issues with Stylelint.'
	printf '\033[1m%-18s\033[0m  %s\n' 'eslint_check' 'Check JavaScript/TypeScript with ESLint.'
	printf '\033[1m%-18s\033[0m  %s\n' 'prettier_check' 'Check formatting with Prettier.'
	printf '\033[1m%-18s\033[0m  %s\n' 'stylelint_check' 'Check stylesheets with Stylelint.'
	printf '\033[1m%-18s\033[0m  %s\n' 'typescript_check' 'Run TypeScript type checking.'
	printf '\033[1m%-18s\033[0m  %s\n' 'playwright_test' 'Run Playwright tests.'
	printf '\033[1m%-18s\033[0m  %s\n' 'playwright_install' 'Install Playwright browsers and OS dependencies.'
	printf '\033[1m%-18s\033[0m  %s\n' 'npm_audit' 'Run npm audit at the configured severity level.'
	printf '\033[1m%-18s\033[0m  %s\n' 'npm_install' 'Install npm dependencies from package-lock.json.'
	printf '\033[1m%-18s\033[0m  %s\n' 'npm_update' 'Refresh npm dependencies and package-lock.json.'
	printf '\033[1m%-18s\033[0m  %s\n' 'precreate' 'Run pre-devcontainer setup hooks.'
	printf '\033[1m%-18s\033[0m  %s\n' 'postcreate' 'Run post-devcontainer setup hooks.'
	printf '\033[1m%-18s\033[0m  %s\n' 'start' 'Start the local development server.'
	printf '\033[1m%-18s\033[0m  %s\n' 'serve' 'Alias for start.'
	printf '\033[1m%-18s\033[0m  %s\n' 'server' 'Alias for start.'
	printf '\033[1m%-18s\033[0m  %s\n' 'dev' 'Alias for start.'
	printf '\033[1m%-18s\033[0m  %s\n' 'port' 'Print local service ports.'
	printf '\033[1m%-18s\033[0m  %s\n' 'ports' 'Alias for port.'
	printf '\033[1m%-18s\033[0m  %s\n' 'devcontainer' 'Open a devcontainer shell, then stop the container.'
	printf '\033[1m%-18s\033[0m  %s\n' 'build' 'Build project artifacts.'
	printf '\033[1m%-18s\033[0m  %s\n' 'dist_zip' 'Package the contents of ./dist into ./release/dist.zip.'
	printf '\033[1m%-18s\033[0m  %s\n' 'local' 'Build/run with APP_ENV=local.'
	printf '\033[1m%-18s\033[0m  %s\n' 'development' 'Build/run with APP_ENV=development.'
	printf '\033[1m%-18s\033[0m  %s\n' 'sit' 'Build/run with APP_ENV=sit.'
	printf '\033[1m%-18s\033[0m  %s\n' 'uat' 'Build/run with APP_ENV=uat.'
	printf '\033[1m%-18s\033[0m  %s\n' 'production' 'Build/run with APP_ENV=production.'
	printf '\033[1m%-18s\033[0m  %s\n' 'playwright_failed' 'Open the last failed Playwright test report.'
	printf '\033[1m%-18s\033[0m  %s\n' 'playwright_headed' 'Run Playwright tests in headed mode.'
	printf '\033[1m%-18s\033[0m  %s\n' 'playwright_ui' 'Open Playwright UI mode.'

.PHONY: all
all: dist_zip

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
	rm -rf ./tmp
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
	npm exec --ignore-scripts -- playwright install --with-deps

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
postcreate: deps_install

.PHONY: start serve server dev
start serve server dev: ./node_modules ./package.json ./package-lock.json
	npm exec --ignore-scripts -- webpack-cli serve --mode=$${NODE_ENV:-development} --config-node-env=$${NODE_ENV:-development} --env APP_ENV=$${APP_ENV:-local}

.PHONY: port ports
.SILENT: port ports
port ports:
	printf '\033[1m%-80s\033[0m\n' 'template-web-components-library ports'
	printf '%-80s\n' '--------------------------------------------------------------------------------'
	printf '\033[1m%-12s %-21s %-12s %-20s\033[0m\n' 'Kind' 'Host' 'Container' 'Service'
	printf '%-12s %-21s %-12s %-20s\n' 'reserved' '-' '61200' '-'
	printf '%-12s %-21s %-12s %-20s\n' 'webpack' '127.0.0.1:61201' '61201' 'devcontainer'
	printf '%-80s\n' '--------------------------------------------------------------------------------'
	printf '\n\033[1mLinks\033[0m\n'
	printf '%s\n' 'Webpack smoke server: http://127.0.0.1:61201/'

.PHONY: devcontainer
devcontainer: precreate
	devcontainer up
	devcontainer exec /bin/bash || true
	docker ps -q --filter "label=devcontainer.local_folder=$${PWD}" | xargs -r docker stop

.PHONY: build
build: ./node_modules ./package.json ./package-lock.json
	npm exec --ignore-scripts -- webpack-cli build --mode=$${NODE_ENV:-development} --config-node-env=$${NODE_ENV:-development} --env APP_ENV=$${APP_ENV:-local}

.PHONY: dist_zip
dist_zip: production
	rm -rf ./release
	mkdir -p ./release
	cd ./dist && zip -r ../release/dist.zip .

.PHONY: local
local: export APP_ENV := local
local: export NODE_ENV := development
local: build

.PHONY: development
development: export APP_ENV := development
development: export NODE_ENV := production
development: build

.PHONY: sit
sit: export APP_ENV := sit
sit: export NODE_ENV := production
sit: build

.PHONY: uat
uat: export APP_ENV := uat
uat: export NODE_ENV := production
uat: build

.PHONY: production
production: export APP_ENV := production
production: export NODE_ENV := production
production: build

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
