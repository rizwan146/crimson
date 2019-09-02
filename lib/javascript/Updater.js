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
            this.app.notifier.listenTo(message.id, message.events);
        }
    }
}