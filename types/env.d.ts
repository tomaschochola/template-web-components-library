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

declare namespace NodeJS {
  interface ProcessEnv {
    // 'development' | 'production'
    readonly NODE_ENV: string;

    // 'development' | 'production'
    readonly WEBPACK_MODE: string;

    // regex: ^\d+\.\d+\.\d+$
    readonly APP_VERSION: string;

    // regex: ^[a-zA-Z0-9-_]+$
    readonly APP_NAME: string;

    // 'local' | 'playwright' | 'development' | 'sit' | 'uat' | 'production'
    readonly APP_ENV: string;

  }
}
