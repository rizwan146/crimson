export default class Destroyer {
    constructor(app) {
        this.app = app;
    }

    destroy(message) {
        let object = this.app.objects[message.id];
        object.remove();
        delete this.app.objects[message.id];
    }
}