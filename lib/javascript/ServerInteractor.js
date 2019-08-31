export default class ServerInteractor {
    constructor(uri) {
        this.socket = new WebSocket("ws://" + uri);
        this.socket.onopen = this.onOpen;
        this.socket.onmessage = this.onMessage;
        this.socket.onclose = this.onClose;
        this.socket.onerror = this.onError;
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