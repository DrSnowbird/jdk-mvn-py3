#!/usr/bin/env node

const WebSocketServer = require('ws').Server;
const wss = new WebSocketServer({ port: 8080, host : '0.0.0.0' });

// -- connection --
wss.on('connection', function connection(ws) {
    const ip = ws._socket.remoteAddress;
    console.log('Server WebSocket was connected from: ' + ip);
    ws.send('... Hello World from openkbs/jdk-mvn-py3 with WebSocket in NodeJS supports! \n... See https://github.com/DrSnowbird/jdk-mvn-py3 for more information.\n');

    // -- open --
    ws.on('open', function open() {
        console.log('connected');
        ws.send('time (open): ' + Date.now());
    });

    // -- message --
    ws.on('message', function incoming(data) {
        // console.log(`Roundtrip time: ${Date.now() - data} ms`);
        ws.send('message: ' + data + ', received by Server at:' + Date.now());
        console.log('message: ' + data + ', received by Server at:' + Date.now());

        // setTimeout(function timeout() {
        //     console.log('setTimeout at:' + Date.now());
        //     ws.send('setTimeout at: ' + Date.now());
        // }, 500);
    });

    // -- close --
    ws.on('close', function close() {
        console.log('time (close) at:' + Date.now());
        console.log('disconnected');
    });

});

