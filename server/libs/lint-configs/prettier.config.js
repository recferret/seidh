module.exports = {
  singleQuote: true,
  trailingComma: 'all',

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
    '^@glory/(.*)$',
    '^glory-(.*)$',

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

    '.export',
    '.constants',
    '/constants',
    '.decorator',
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
