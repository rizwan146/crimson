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
            for (let i = 0; i < attributes.length; i++) {
                let attribute = attributes[i];
                let value = message.attributes[attribute];
                object[attribute] = value;
            }
        }
    }
}