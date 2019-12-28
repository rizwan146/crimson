export default class ServerInteractor {
    constructor(uri, objectManager, logger) {
        let me = this;

        me.objectManager = objectManager;
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

        let message = JSON.parse(event.data);
        switch (message.action) {
            case "create": this.onCreateMessage(message); break;
            case "update": this.onUpdateMessage(message); break;
            case "destroy": this.onDestroyMessage(message); break;
            case "invoke": this.onInvokeMessage(message); break;
            default:
                this.logger.log(`[ServerInteractor] Unknown action ${message.action}`);
        }
    }

    onCreateMessage(message) {
        this.objectManager.insert(message.id, message.tag);
        this.onUpdateMessage(message);
    }

    onUpdateMessage(message) {
        this.objectManager.update(message.id, message.changes);
    }

    onDestroyMessage(message) {
        this.objectManager.remove(message.id);
    }

    onInvokeMessage(message) {
        let returnValue = this.objectManager.invoke(message.id, message.functor, message.args);

        this.send({
            message: message.token,
            returnValue: returnValue
        });
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