import { test } from '@playwright/test';
import { assertStandardPage } from '@tomaschochola/tooling-playwright';

// Assertions are encapsulated by assertStandardPage.
test('renders the smoke page', async ({ page }) => {
    await assertStandardPage(page, {
        heading: 'tomaschochola/template-web-components-library',
        title: 'tomaschochola/template-web-components-library',
        url: '/',
    });
});
