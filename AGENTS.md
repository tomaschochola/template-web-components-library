# template-web-components-library

Web Components library template with TypeScript, Webpack, and Playwright.

## Stack

- Language: TypeScript on Node 24
- Runtime: GNU/Linux, browsers via Playwright
- Libraries: none (template skeleton)
- Package manager: npm

## Toolchain

- Format: prettier 3.x, trimmer
- Lint: eslint 10.x, stylelint 17.x
- Test: `node --test` + real Chromium, Firefox, WebKit
- Audit: npm audit

## Devcontainer

- Base: official Node
- User: node
- Browsers install natively: chromium, firefox, webkit
- Sidecars: none
- Up: `make up`
- Execute: `devcontainer exec --workspace-folder . <command>`
- Down: `make down`

## Makefile

- `update` — refresh locks, only tool that may touch them
- `fix` — auto-fix, may dirty tree
- `check` — full gate: doctor + lint + analyze + test + dist + audit
- `doctor` — tree and toolchain ok
- `lint` — eslint + stylelint + prettier + trimmer checks
- `analyze` — npm + type checks
- `test` — unit + browser tests
- `dist` — production bundles
- `audit` — dependency audit
- `all` — build all bundles
- `postcreate` — first-time setup, runs automatically on create
- `stop` — stop container, keep it
- `down` — stop and remove container
- `clean` — drop generated files
- `distclean` — drop everything rebuildable
- `rebuild` — full rebuild, only when broken

## Layout

├── Makefile
├── .editorconfig
├── .devcontainer/
├── package.json
├── babel.config.js
├── eslint.config.js
├── postcss.config.js
├── prettier.config.js
├── stylelint.config.js
├── tsconfig.json
├── webpack.config.js
├── LICENSE
├── AUTHORS.md
├── src/
│   └── index.ts
└── tests/
