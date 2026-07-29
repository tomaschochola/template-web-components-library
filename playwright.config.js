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

export default createPlaywrightConfig({
  webServer: {
    command: 'npm exec --ignore-scripts -- webpack-cli serve --mode=development --config-node-env=development',
    env: {
      ...process.env,
      APP_ENV: 'playwright',
    },
    url: 'http://localhost:61201/webpack-dev-server',
  },
  use: {
    baseURL: 'http://localhost:61201',
  },
});
