const socket = io('ws://localhost:3000', {
// const socket = io('ws://localhost:3082', {
    transport: [ "websocket" ],
    auth: {    
      token: "ws-load-test_1"
    }
});

socket.on('connect', function() {
    console.log('Client connected');
});

socket.on('WORLD_STATE', function(data) {
    console.log('WORLD_STATE', data);
});

socket.on('exception', function(data) {
    console.log('exception');
    console.log('data', data);
});
socket.on('disconnect', function() {
    console.log('Disconnected');
});