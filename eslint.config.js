import { ESLintConfigBuilder, filePatterns } from '@tomaschochola/tooling-eslint';

const browserFiles = ['smoke/**/*.{js,jsx,mjs,mts,ts,tsx}', 'src/**/*.{js,jsx,mjs,mts,ts,tsx}'];
const typescriptFiles = [...filePatterns.typescript, ...filePatterns.tsx];

export default new ESLintConfigBuilder()
    .addNodeGlobalsForConfigFiles()
    .addNodeGlobals({ files: filePatterns.playwright })
    .addBrowserGlobals({ files: browserFiles })
    .addGitIgnoreFile(import.meta.url)
    .addJavaScriptRecommendedRules({ files: filePatterns.scripts })
    .addTypeScriptRecommendedTypeCheckedRules({ files: typescriptFiles })
    // .addTypeScriptStrictTypeCheckedRules({ files: typescriptFiles })
    // .addTypeScriptOpinionatedTypeCheckedRules({ files: typescriptFiles })
    .enableTypeScriptProjectService({ files: typescriptFiles })
    // .addSonarJsRecommendedRules({ files: browserFiles })
    .toConfig();
