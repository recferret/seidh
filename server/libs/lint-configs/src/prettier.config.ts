import { PrettierConfig } from '@trivago/prettier-plugin-sort-imports';

export const prettierConfig: PrettierConfig = {
  singleQuote: true,
  trailingComma: 'all',

  printWidth: 120,

  endOfLine: 'auto',

  plugins: ['@trivago/prettier-plugin-sort-imports'],

  importOrderGroupNamespaceSpecifiers: true,
  importOrderCaseInsensitive: true,
  importOrderSortSpecifiers: true,
  importOrderSeparation: true,
  importOrderParserPlugins: [
    'decorators-legacy',
    'classProperties',
    'typescript',
  ],

  importOrder: [
    '^@nestjs/(.*)$',
    '^@sentry/(.*)$',
    '^@reward/(.*)$',
    '^@willsoto/(.*)$',

    'rxjs',

    '^typeorm',
    '^express',
    '^passport',

    '.factory',
    '.middleware',
    '.interceptor',
    '.filter',

    '.module',
    '.wrapper',
    '.provider',
    '/providers',

    '.controller',
    '.service',

    '.strategy',
    '.strategies',
    '.guard',
    '.guards',

    '.export',
    '.constants',
    '/constants',
    '.decorator',
    '.builder',
    '.builders',
    '.mapper',
    '.mappers',
    '.adapter',
    '.adapters',
    '/decorators',
    '.helper',
    '/helpers',
    '.validator',
    '.utils',
    '.api',
    '.queues',
    '.queue',
    '.envalid',

    '.entity',
    '.dto',
    '.mock',
    '/dto',
    '/mocks',
    '/entities',

    '.interfaces',
    '.interface',
    '/interfaces',
    '.enum',
    '/enums',
    '.types',
    '.type',
    '/types',
    '^@types/(.*)$',

    '^[./]',
  ],
};
