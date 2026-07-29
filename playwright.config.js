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

import { defineConfig, devices } from '@playwright/test';

const isCI = process.env['CI'] === 'true';

export default defineConfig({
  projects: [
    {
      name: 'Google Chrome stable desktop landscape (1920x1080)',
      use: {
        browserName: 'chromium',
        channel: 'chrome',
        viewport: {
          width: 1920,
          height: 1080,
        },
      },
    },
    {
      name: 'Microsoft Edge stable desktop landscape (1920x1080)',
      use: {
        browserName: 'chromium',
        channel: 'msedge',
        viewport: {
          width: 1920,
          height: 1080,
        },
      },
    },
    {
      name: 'Firefox desktop landscape (1920x1080)',
      use: {
        browserName: 'firefox',
        viewport: {
          width: 1920,
          height: 1080,
        },
      },
    },
    {
      name: 'WebKit desktop landscape (1920x1080)',
      use: {
        browserName: 'webkit',
        viewport: {
          width: 1920,
          height: 1080,
        },
      },
    },
    {
      name: 'Android Chrome phone portrait (360x732)',
      use: {
        ...devices['Pixel 9'],
      },
    },
    {
      name: 'Android Chrome phone landscape (756x308)',
      use: {
        ...devices['Pixel 9 landscape'],
      },
    },
    {
      name: 'iOS Safari phone portrait (375x667)',
      use: {
        ...devices['iPhone SE (3rd gen)'],
      },
    },
    {
      name: 'iOS Safari phone landscape (667x375)',
      use: {
        ...devices['iPhone SE (3rd gen) landscape'],
      },
    },
    {
      name: 'Android Chrome tablet portrait (640x1024)',
      use: {
        ...devices['Galaxy Tab S9'],
      },
    },
    {
      name: 'Android Chrome tablet landscape (1024x640)',
      use: {
        ...devices['Galaxy Tab S9 landscape'],
      },
    },
    {
      name: 'iPadOS Safari tablet portrait (768x1024)',
      use: {
        ...devices['iPad Mini'],
      },
    },
    {
      name: 'iPadOS Safari tablet landscape (1024x768)',
      use: {
        ...devices['iPad Mini landscape'],
      },
    },
  ],
  webServer: {
    command: 'npm exec --ignore-scripts -- webpack-cli serve --mode=development --config-node-env=development',
    env: {
      ...process.env,
      APP_ENV: 'playwright',
    },
    url: 'http://localhost:61201/webpack-dev-server',
    reuseExistingServer: false,
    timeout: 5 * 60 * 1000,
  },
  use: {
    baseURL: 'http://localhost:61201',
    locale: 'en',
    screenshot: 'only-on-failure',
  },
  timeout: 5 * 60 * 1000,
  retries: isCI ? 2 : 0,
});
