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

 
export default defineConfig({
  projects: [
    {
      name: 'Desktop Edge',
      use: {
        ...devices['Desktop Edge'],
        viewport: {
          width: 1920,
          height: 1080,
        },
      },
    },
    {
      name: 'Desktop Chrome',
      use: {
        ...devices['Desktop Chrome'],
        viewport: {
          width: 1920,
          height: 1080,
        },
      },
    },
    {
      name: 'Desktop Firefox',
      use: {
        ...devices['Desktop Firefox'],
        viewport: {
          width: 1920,
          height: 1080,
        },
      },
    },
    {
      name: 'Desktop Safari',
      use: {
        ...devices['Desktop Safari'],
        viewport: {
          width: 1920,
          height: 1080,
        },
      },
    },
    {
      name: 'Pixel 7',
      use: {
        ...devices['Pixel 7'],
        viewport: {
          width: 384,
          height: 824,
        },
      },
    },
    {
      name: 'iPhone 15',
      use: {
        ...devices['iPhone 15'],
        viewport: {
          width: 384,
          height: 824,
        },
      },
    },
    {
      name: 'iPad Pro 11',
      use: {
        ...devices['iPad Pro 11'],
        viewport: {
          width: 768,
          height: 1024,
        },
      },
    },
  ],
  webServer: {
    command: 'npm exec --ignore-scripts -- webpack-cli serve --mode=development --config-node-env=development --env APP_ENV=playwright',
    url: 'http://localhost:61201/webpack-dev-server',
    reuseExistingServer: true,
    timeout: 5 * 60 * 1000,
  },
  use: {
    baseURL: 'http://localhost:61201',
    locale: 'en',
    screenshot: 'only-on-failure',
  },
  timeout: 5 * 60 * 1000,
  retries: 2,
});
