# Default shell
SHELL := /bin/bash

# Default goal
.DEFAULT_GOAL := never

# Options
export DEBIAN_FRONTEND := noninteractive

# Goals
.PHONY: commit
commit: distclean update fix check

.PHONY: fix
fix: eslint_fix prettier_fix stylelint_fix yq_fix

.PHONY: check
check: lint stan test audit

.PHONY: lint
lint: eslint_check prettier_check stylelint_check

.PHONY: stan
stan: typescript_check

.PHONY: test
test: playwright_test

.PHONY: audit
audit: npm_audit

.PHONY: install
install: npm_install

.PHONY: update
update: npm_update

.PHONY: clean
clean:
	rm -rf ./node_modules
	rm -rf ./dist
	rm -rf ./tmp

.PHONY: distclean
distclean: clean
	git clean -Xfd

.PHONY: eslint_fix
eslint_fix: ./node_modules ./eslint.config.js
	npm exec --ignore-scripts -- eslint --concurrency=auto --fix .

.PHONY: prettier_fix
prettier_fix: ./node_modules ./prettier.config.js
	npm exec --ignore-scripts -- prettier -w .

.PHONY: stylelint_fix
stylelint_fix: ./node_modules ./stylelint.config.js
	npm exec --ignore-scripts -- stylelint --allow-empty-input --fix ./**/*.{sass,scss,css}

.PHONY: yq_fix
yq_fix:
	find . -type f -name "*.yml" -exec yq -i 'sort_keys(..)' {} \;

.PHONY: eslint_check
eslint_check: ./node_modules ./eslint.config.js
	npm exec --ignore-scripts -- eslint --concurrency=auto .

.PHONY: prettier_check
prettier_check: ./node_modules ./prettier.config.js
	npm exec --ignore-scripts -- prettier -c .

.PHONY: stylelint_check
stylelint_check: ./node_modules ./stylelint.config.js
	npm exec --ignore-scripts -- stylelint --allow-empty-input ./**/*.{sass,scss,css}

.PHONY: typescript_check
typescript_check: ./node_modules ./tsconfig.json ./tsconfig.playwright.json
	npm exec --ignore-scripts -- tsc --noEmit --project ./tsconfig.json
	npm exec --ignore-scripts -- tsc --noEmit --project ./tsconfig.playwright.json

.PHONY: playwright_test
playwright_test: ./node_modules ./playwright.config.js
	npm exec --ignore-scripts -- playwright test

.PHONY: playwright_install
playwright_install: ./node_modules ./playwright.config.js
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
	docker volume create tomaschochola-npm-cache >/dev/null

.PHONY: postcreate
postcreate: install

.PHONY: start serve server dev
start serve server dev: ./node_modules ./package.json ./package-lock.json
	npm exec --ignore-scripts -- webpack-cli serve --mode=$${NODE_ENV:-development} --config-node-env=$${NODE_ENV:-development} --env APP_ENV=$${APP_ENV:-local}

.PHONY: port ports
port ports:
	@printf '\033[1m%-80s\033[0m\n' 'template-web-components-library ports'
	@printf '%-80s\n' '--------------------------------------------------------------------------------'
	@printf '\033[1m%-12s %-21s %-12s %-20s\033[0m\n' 'Kind' 'Host' 'Container' 'Service'
	@printf '%-12s %-21s %-12s %-20s\n' 'reserved' '-' '61200' '-'
	@printf '%-12s %-21s %-12s %-20s\n' 'webpack' '127.0.0.1:61201' '61201' 'devcontainer'
	@printf '%-80s\n' '--------------------------------------------------------------------------------'
	@printf '\n\033[1mLinks\033[0m\n'
	@printf '%s\n' 'Webpack smoke server: http://127.0.0.1:61201/'

.PHONY: devcontainer
devcontainer: precreate
	devcontainer up
	devcontainer exec /bin/bash || true
	docker ps -q --filter "label=devcontainer.local_folder=$${PWD}" | xargs -r docker stop

.PHONY: prune
prune:
	@projects="$$(docker ps -aq --filter "label=devcontainer.local_folder=$${PWD}" | xargs -r docker inspect --format '{{ index .Config.Labels "com.docker.compose.project" }}' | sort -u)"; for project in $$projects; do docker ps -aq --filter "label=com.docker.compose.project=$$project" | xargs -r docker rm -f; done; docker ps -aq --filter "label=devcontainer.local_folder=$${PWD}" | xargs -r docker rm -f

.PHONY: fresh
fresh: prune devcontainer

.PHONY: build
build:
	npm exec --ignore-scripts -- webpack-cli build --mode=$${NODE_ENV:-development} --config-node-env=$${NODE_ENV:-development} --env APP_ENV=$${APP_ENV:-local}

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
production:
	npm exec --ignore-scripts -- webpack-cli build --mode=$${NODE_ENV:-development} --config-node-env=$${NODE_ENV:-development} --env APP_ENV=$${APP_ENV:-local}

.PHONY: playwright_failed
playwright_failed: ./node_modules ./playwright.config.js
	npm exec --ignore-scripts -- playwright test --last-failed

.PHONY: playwright_headed
playwright_headed: ./node_modules ./playwright.config.js
	npm exec --ignore-scripts -- playwright test --headed

.PHONY: playwright_ui
playwright_ui: ./node_modules ./playwright.config.js
	npm exec --ignore-scripts -- playwright test --ui

# Dependencies
./package-lock.json ./node_modules: ./package.json
	${MAKE} npm_update
