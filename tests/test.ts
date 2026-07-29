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

import { expect, type Page } from '@playwright/test';
import { waitForIdle } from '@tomaschochola/tooling-playwright';

export { waitForIdle };

export async function loadPage(page: Page, url: string): Promise<void> {
  await page.goto(url);
  await waitForIdle(page);
  await expect(page).toHaveURL(url);
  await expect(page.locator('#webpack-dev-server-client-overlay')).not.toBeAttached();
}
