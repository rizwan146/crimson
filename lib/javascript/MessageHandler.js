import Utilities from './Utilities.js'

export default class MessageHandler {
    constructor(serverInteractor, objectManager) {
        this.serverInteractor = serverInteractor;
        this.objectManager = objectManager;
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
        this.objects.root.appendChild(object);
    }

    handleUpdateMessage(message) {
        Object.keys(message.changes).forEach(change => {
            if (change === "children") {
                this.handleUpdateChildrenMessage(message);
            } else if (change === "events") {
                this.handleUpdateEventsMessage(message);
            } else if (!(change in object)) {
                this.logger.log(`[MessageHandler] Unknown attribute '${change}' for ${id}`);
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
        const object = this.objectManager.get(message.id);

        
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
            this.logger.log(`[ObjectManager] Trying to invoke a non-existing functor ${functor}!`);
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