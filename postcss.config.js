import { PostCSSConfigBuilder } from '@tomaschochola/tooling-postcss';

export default new PostCSSConfigBuilder().addPresetEnvPlugin().toConfig();
