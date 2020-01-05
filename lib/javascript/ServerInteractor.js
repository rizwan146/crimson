import MessageHandler from './MessageHandler.js'

export default class ServerInteractor {
    constructor(uri, objectManager, logger) {
        this.uri = uri;
        this.messageHandler = new MessageHandler(this, objectManager, logger);
        this.logger = logger;

        this.connect();
    }

    connect() {
        const me = this;

        me.socket = new WebSocket("ws://" + me.uri);
        me.socket.onopen = function (event) { me.onOpen(event); };
        me.socket.onmessage = function (event) { me.onMessage(event); };
        me.socket.onclose = function (event) { me.onClose(event); };
        me.socket.onerror = function (error) { me.onError(error); };
    }

    send(message) {
        this.socket.send(JSON.stringify(message));
    }

    onOpen(event) {
        this.logger.log("[ServerInteractor] Connection established");
    }

    onMessage(event) {
        this.logger.log(`[ServerInteractor] Data received from server: ${event.data}`);

        this.messageHandler.handle(JSON.parse(event.data));
    }

    onClose(event) {
        const me = this;

        if (event.wasClean) {
            me.logger.log(`[ServerInteractor] Connection closed cleanly, code=${event.code} reason=${event.reason}`);
        } else {
            me.logger.log("[ServerInteractor] Connection died.");
        }

        me.logger.log("[ServerInteractor] Attempting to reestablish connection...")
        setTimeout(function() {
            me.connect();
        }, 5000);
    }

    onError(error) {
        this.logger.log(`[ServerInteractor] Received Error: ${error.message}`);
    }
}