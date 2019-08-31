export default class ServerInteractor {
    constructor(uri) {
        let me = this;

        me.socket = new WebSocket("ws://" + uri);
        me.socket.onopen = function(event) { me.onOpen(event); };
        me.socket.onmessage = function(event) { me.onMessage(event); };
        me.socket.onclose = function(event) { me.onClose(event); };
        me.socket.onerror = function(error) { me.onError(error); };
    }

    onOpen(event) {
        console.log("[ServerInteractor] Connection established");
        console.log("[ServerInteractor] Sending to server 'Hello World'");

        this.socket.send("Hello World");
    }

    onMessage(event) {
        console.log(`[ServerInteractor] Data received from server: ${event.data}`);

        let message = JSON.parse(event.data);
    }

    onClose(event) {
        if (event.wasClean) {
            console.log(`[ServerInteractor] Connection closed cleanly, code=${event.code} reason=${event.reason}`);
        } else {
            console.log('[ServerInteractor] Connection died');
        }
    }

    onError(error) {
        console.log(`[ServerInteractor] Received Error: ${error.message}`);
    }
}