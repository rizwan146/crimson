import Utilities from './Utilities.js'

export default class MessageHandler {
    constructor(serverInteractor, objectManager, logger) {
        this.serverInteractor = serverInteractor;
        this.objectManager = objectManager;
        this.logger = logger;
        this.eventHandlers = {};
    }

    handle(message) {
        switch (message.action) {
            case "create": this.handleCreateMessage(message); break;
            case "update": this.handleUpdateMessage(message); break;
            case "destroy": this.handleDestroyMessage(message); break;
            case "invoke": this.handleInvokeMessage(message); break;
            default:
                this.logger.log(`[MessageHandler] Unknown action ${message.action}`);
        }
    }

    handleCreateMessage(message) {
        const object = document.createElement(message.tag);

        this.objectManager.insert(message.id, object);
        this.objectManager.get("root").appendChild(object);

        this.handleUpdateMessage(message);
    }

    handleUpdateMessage(message) {
        Object.keys(message.changes).forEach(change => {
            if (change === "children") {
                this.handleUpdateChildrenMessage(message);
            } else if (change === "events") {
                this.handleUpdateEventsMessage(message);
            } else if (!(change in this.objectManager.get(message.id))) {
                this.logger.log(`[MessageHandler] Unknown attribute '${change}' for ${message.id}`);
            } else if (change === "style") {
                this.handleUpdateStyleMessage(message);
            } else {
                this.handleUpdateAttributeMessage(change, message);
            }
        });
    }

    handleUpdateAttributeMessage(attr, message) {
        const object = this.objectManager.get(message.id);

        object[attr] = message.changes[attr];
        object.setAttribute(attr, message.changes[attr]);
    }

    handleUpdateChildrenMessage(message) {
        const object = this.objectManager.get(message.id);

        for (let i = 0; i < message.changes.children.length; i++) {
            const childId = message.changes.children[i];
            const child = this.objectManager.get(childId);

            Utilities.insertAt(object, child, i);
        }
    }

    handleUpdateEventsMessage(message) {
        const me = this;
        const object = this.objectManager.get(message.id);

        // remove previous event handlers
        if (me.eventHandlers[message.id]) {
            Object.keys(me.eventHandlers[message.id]).forEach(eventName => {
                object.removeEventListener(eventName, me.eventHandlers[message.id][eventName]);
            });
        }

        me.eventHandlers[message.id] = {};

        // add new handlers
        message.changes.events.forEach(eventName => {
            me.eventHandlers[message.id][eventName] = function (e) {
                const data = JSON.parse(Utilities.stringifyEvent(e));

                if (object.tagName === "FORM") {
                    const formData = new FormData(object);
                    formData.forEach(function (value, key) {
                        data[key] = value;
                    });
                }

                if (eventName === "dragstart") {
                    e.dataTransfer.setData("text/plain", object.id);
                } else if (e.dataTransfer) {
                    data.target = e.dataTransfer.getData("text/plain");
                }

                me.serverInteractor.send({
                    action: "event",
                    id: message.id,
                    event: eventName,
                    data: data
                });

                return false;
            };

            object.addEventListener(eventName, me.eventHandlers[message.id][eventName], false);
        });
    }

    handleUpdateStyleMessage(message) {
        const object = this.objectManager.get(message.id);

        Object.keys(message.changes.style).forEach(style => {
            object.style[style] = message.changes.style[style];
        });
    }

    handleDestroyMessage(message) {
        this.objectManager.get(message.id).remove();
        this.objectManager.remove(message.id);
    }

    handleInvokeMessage(message) {
        const object = this.objectManager.get(message.id);

        if (!(functor in object)) {
            this.logger.log(`[ObjectManager] Trying to invoke a non-existing functor ${message.functor}!`);
            return;
        }

        for (let i = 0; i < args.length; i++) {
            if (this.objectManager.contains(args[i]))
                args[i] = this.objectManager.get(args[i]);
        }

        this.send({
            action: "response",
            token: message.token,
            returnValue: object[functor].apply(object, args)
        });
    }
}