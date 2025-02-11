#!/bin/bash

haxe ./scripts/compile_prod.hxml

npm run build:prod

node ./scripts/update_html_version.js

const tgFilePath = path.join(__dirname, '../build/prod/netlify/tg/index.html');
const vkFilePath = path.join(__dirname, '../build/prod/netlify/tg/index.html');