/**
 * @file
 * @author Tomáš Chochola <tomaschochola@tomaschochola.cz>
 * @copyright © 2026 Tomáš Chochola <tomaschochola@tomaschochola.cz>
 *
 * @license CC-BY-ND-4.0
 *
 * @see {@link https://creativecommons.org/licenses/by-nd/4.0/} License
 * @see {@link https://github.com/tomaschochola} GitHub Profile
 * @see {@link https://github.com/sponsors/tomaschochola} GitHub Sponsors
 */

import { createPlaywrightConfig } from '@tomaschochola/tooling-playwright';

const baseURL = 'http://localhost:61090';

export default createPlaywrightConfig({
  tsconfig: './tsconfig.playwright.json',
  webServer: {
    command: 'npm exec --ignore-scripts -- webpack-cli serve --no-client --no-hot --no-live-reload --no-web-socket-server --mode=development --config-node-env=development --env APP_ENV=playwright',
    url: baseURL,
  },
  use: {
    baseURL,
  },
});
