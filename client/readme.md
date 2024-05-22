# Compile game client
haxe .\compile.hxml

# Compile game engine
haxe .\compileEngine.hxml -D js-es=6

# Local telegram development

1) compile game client
2) generate ssl (openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem)
3) http-server -S -C cert.pem