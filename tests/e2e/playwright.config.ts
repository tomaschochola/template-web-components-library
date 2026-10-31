import {
    createPlaywrightConfig,
    createPlaywrightDesktopProjects,
    // createPlaywrightPhoneProjects,
    // createPlaywrightTabletProjects,
} from '@tomaschochola/tooling-playwright';

const baseURL = 'http://127.0.0.1:8080';

export default createPlaywrightConfig({
    projects: [
        ...createPlaywrightDesktopProjects(),
        // ...createPlaywrightPhoneProjects(),
        // ...createPlaywrightTabletProjects(),
    ],
    testDir: '.',
    webServer: {
        command:
            'npm exec --ignore-scripts -- webpack-cli serve --no-client --no-hot --no-live-reload --no-web-socket-server --mode=development --config-node-env=development --env APP_ENV=playwright',
        cwd: '../..',
        url: baseURL,
    },
    use: {
        baseURL,
    },
});
