export default class ServerInteractor {
    constructor(app) {
        let me = this;

        me.app = app;

        me.socket = new WebSocket("ws://" + app.uri);
        me.socket.onopen = function(event) { me.onOpen(event); };
        me.socket.onmessage = function(event) { me.onMessage(event); };
        me.socket.onclose = function(event) { me.onClose(event); };
        me.socket.onerror = function(error) { me.onError(error); };
    }

    send(message) {
        this.socket.send(JSON.stringify(message));
    }

    onOpen(event) {
        console.log("[ServerInteractor] Connection established");
    }

    onMessage(event) {
        console.log(`[ServerInteractor] Data received from server: ${event.data}`);

        let message = JSON.parse(event.data);
        switch(message.action) {
            case "create":
                this.app.creator.create(message)
                break;
            case "destroy":
                this.app.destroyer.destroy(message)
                break;
            case "update":
                this.app.updater.update(message)
                break;
            case "invoke":
                this.app.invoker.invoke(message)
                break;
            default:
                console.log(`[ServerInteractor] Unknown action ${message.action}`)
        }
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