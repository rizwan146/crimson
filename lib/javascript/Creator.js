export default class Creator {
    constructor(app) {
        this.app = app;
    }

    create(message) {
        let object = document.createElement(message.tag);
        
        object.setAttribute("id", message.id);
        this.app.objects[message.id] = object;

        if (message.parent) {
            this.app.objects[message.parent].appendChild(object);
        } else {
            this.app.root.appendChild(object);
        }

        if (message.value) {
            object.innerHTML = message.value;
        } else if (message.children) {
            for (let i = 0; i < message.children.length; i++) {
                this.create(message.children[i]);
            }
        }

        let attributes = Object.keys(message.attributes);
        for (let i = 0; i < attributes.length; i++) {
            let attribute = attributes[i];
            let value = message.attributes[attribute];
            object[attribute] = value;
        }

        this.app.notifier.listenTo(message.id, message.events, message.meta);
    }
}