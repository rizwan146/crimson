export default class Updater {
    constructor(app) {
        this.app = app;
    }

    update(message) {
        let object = this.app.objects[message.id];

        if (message.value) {
            object.innerHTML = message.value;
        }

        if (message.events) {
            this.app.notifier.listenTo(message.id, message.events, message.meta);
        }

        if (message.parent) {
            parent = this.app.objects[message.parent];
            parent.append(object);
        }

        if (message.attributes) {
            let attributes = Object.keys(message.attributes);
            attributes.forEach(attr => {
                let value = message.attributes[attr];
                object[attr] = value;
            });
        }

        if (message.style) {
            Object.keys(message.style).forEach(style_key => {
                object.style[style_key] = message.style[style_key];
            });
        }
    }
}