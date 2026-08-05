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

import { ESLintConfigBuilder, filePatterns } from '@tomaschochola/tooling-eslint';

const typescriptFiles = filePatterns.allTypeScriptFiles;
const javascriptFiles = filePatterns.allJavaScriptFiles;

export default new ESLintConfigBuilder()
  .addNodeGlobalsForConfigFiles()
  .addBrowserGlobals()
  .addGitIgnoreFile(import.meta.url)
  .addJavaScriptRecommendedRules()
  .addJavaScriptPolicyRules()
  .addTypeScriptStrictTypeCheckedRules({ files: typescriptFiles })
  .addTypeScriptStylisticTypeCheckedRules({ files: typescriptFiles })
  .enableTypeScriptProjectService({ files: typescriptFiles })
  .enableTypeScriptProject({
    files: filePatterns.playwrightTypeScriptFiles,
    project: './tsconfig.playwright.json',
  })
  .addTypeScriptPolicyRules({ files: typescriptFiles })
  .addRawConfig({
    files: [...filePatterns.allConfigScriptFiles, '**/*.d.ts', '**/*.d.*.ts'],
    rules: {
      'no-restricted-exports': 'off',
    },
  })
  .disableTypeScriptTypeChecking({ files: javascriptFiles })
  .addStylisticCustomizedRules()
  .addStylisticPolicyRules()
  .disableStylisticLegacyRules()
  .addSonarJsRecommendedRules()
  .addSonarJsPolicyOverrides()
  .toConfig();
