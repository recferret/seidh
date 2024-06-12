# Seidh game

Seidh is a online game that built for Telegram and TON.

Core parts:
* client
    * Haxe + Heaps.io
    * Compiled into HTML5 to make it work on the browser
    * Rest + Socket.io for client/server communication
    * Integrated into Telegram using telegram.js sdk
* server
    * Typescript + Nestjs, 7 microservices at the moment
    * Mongo for data persistance 
    * Compiled client part of game logic engine is a part of Gameplay microservice
    * Gameplay microservice could be scaled because of we need lots of working rooms in parralel 
    * https://nats.io for interservice communication
    * Docker compose file that contains everythin
* ton