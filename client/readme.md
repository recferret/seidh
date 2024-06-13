# Compile game client
1) haxe .\compile.hxml
2) copy *.html *.js ans resources to the server and serve static

# Compile game engine
1) haxe .\compileEngine.hxml -D js-es=6
2) put compiled game engine into the backend gameplay micriservice

# Local telegram development
1) compile game client
2) generate ssl (openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem)
3) http-server -S -C cert.pem