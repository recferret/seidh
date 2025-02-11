const config = require('./libs/lint-configs');

const commonConfig = { ...config.esLintConfig };

commonConfig.rules['@typescript-eslint/no-useless-constructor'] = 'off';
commonConfig.ignorePatterns = [...commonConfig.ignorePatterns, '*.js'];

module.exports = { ...commonConfig };
