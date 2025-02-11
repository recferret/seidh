# Compile game client
1) haxe ./scripts/compile_prod.hxml
2) npm run build:prod
3) node ./scripts/update_html_version.js
4) copy new resources (if exists) and /prod/yandex.min.js to the yandex S3
5) npx netlify deploy --dir ./build/prod/netlify/tg/ --site tg-game.seidh-game.com --prod
6) npx netlify deploy --dir ./build/prod/netlify/vk/ --site vk-game.seidh-game.com --prod

# Compile game engine
1) haxe .\compile_engine.hxml -D js-es=6
2) put compiled game engine into the backend gameplay micriservice

# Local telegram development
1) compile game client
2) generate ssl (openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem)
3) http-server -S -C cert.pem

# Generate res.pak
1) haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build
2) hl hxd.fmt.pak.Build.hl
3) upload to yandex