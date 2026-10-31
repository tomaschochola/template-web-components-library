import { WebpackConfigBuilder } from '@tomaschochola/tooling-webpack';

export default function (env = {}, argv = {}) {
    let tooling = new WebpackConfigBuilder({
        ecmaVersion: 2025,
        env,
        argv,
    });

    const appEnv = tooling.appEnv;
    const appName = tooling.appName;
    const appVersion = tooling.appVersion;

    const isProductionBuild = tooling.isProductionBuild;

    tooling = tooling
        .optimizeChunks()
        .setEntries({
            index: ['./smoke/index.ts'],
        })
        .setDevServerPort(8080)
        .addBrowserLoaders()
        .addDefinePlugin({
            'process.env.APP_ENV': JSON.stringify(appEnv),
            'process.env.APP_NAME': JSON.stringify(appName),
            'process.env.APP_VERSION': JSON.stringify(appVersion),
        })
        .addHtmlPlugin({
            template: './smoke/index.html',
        })
        .addRobotsPlugin()
        .optimizeAssets();

    if (isProductionBuild) {
        tooling = tooling.precompressAssets().addArchivePlugin();
    }

    return tooling.toConfig();
}
