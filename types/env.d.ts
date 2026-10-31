declare namespace NodeJS {
    interface ProcessEnv {
        readonly APP_ENV: string;
        readonly APP_NAME: string;
        readonly APP_VERSION: string;
        readonly NODE_ENV: 'development' | 'production';
    }
}
