import MessageHandler from './MessageHandler.js'

export default class ServerInteractor {
    constructor(uri, objectManager, logger) {
        let me = this;

        me.messageHandler = new MessageHandler(me, objectManager, logger);
        me.logger = logger;

        me.socket = new WebSocket("ws://" + uri);
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
        if (event.wasClean) {
            this.logger.log(`[ServerInteractor] Connection closed cleanly, code=${event.code} reason=${event.reason}`);
        } else {
            this.logger.log("[ServerInteractor] Connection died");
        }
    }

    onError(error) {
        this.logger.log(`[ServerInteractor] Received Error: ${error.message}`);
    }
}