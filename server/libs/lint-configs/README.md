# glory-lint-configs

Configs with rules for ESLint and Prettier

---

# Installation

```shell
npm install glory-lint-configs --save-dev
```

or

```shell
yarn add glory-lint-configs -D
```

---

# Usage basic (Not stable extended)

.eslintrc.js

```js
module.exports = {
  extends: ['@glory/lint-configs'],
  // Your custom settings
};
```

.prettierrc

```json
{
  "extends": "@glory/lint-configs",
  // Your custom settings
  "singleQuote": true
}
```

---

# Usage commonjs (Stable extended)


```js
const config = require('@glory/lint-configs');

module.exports = {
  ...config.esLintConfig,
};

```

prettier.config.js

```js
const configs = require('@glory/lint-configs');

module.exports = configs.prettierConfig;

```

---

# Publish package process

1) Change version into package.json
```json
{
  "name": "@glory/lint-configs",
  "version": "{CHANGE_ME}"
}
```

2) Build package
```shell
npm run build
```

3) Create new pack
```shell
npm pack
```

4) Login to Nexus if you haven't already.
```shell
npm login
```

5) Publish package to nexus
```shell
npm publish
```
