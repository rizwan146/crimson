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
            message.children.forEach(child => {
                this.create(child);
            });
        }

        let attributes = Object.keys(message.attributes);
        attributes.forEach(attr => {
            let value = message.attributes[attr];
            object.setAttribute(attr, value);
        });

        if (message.style) {
            Object.keys(message.style).forEach(style_key => {
                object.style[style_key] = message.style[style_key];
            });
        }

        this.app.notifier.listenTo(message.id, message.events, message.meta);
    }
}