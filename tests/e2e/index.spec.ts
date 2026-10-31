import { test } from '@playwright/test';
import { assertStandardPage } from '@tomaschochola/tooling-playwright';

test('renders the smoke page', async ({ page }) => {
    await assertStandardPage(page, {
        heading: 'github.com/tomaschochola/template-web-components-library',
        title: 'github.com/tomaschochola/template-web-components-library',
        url: '/',
    });
});
