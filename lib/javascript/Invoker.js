export default class Invoker {
    constructor(app) {
        this.app = app;
    }

    invoke(message) {
        switch (message.invoker) {
            case "default": this.default(message); break;
            case "canvas": this.canvas(message); break;
            default:
                console.log(`[Invoker] Unknown invoker ${message.invoker}`);
        }
    }

    default(message) {
        let object = this.app.objects[message.id];

        // replace any object-ids in the argument with the actual argument
        for (let i = 0; i < message.args.length; i++) {
            let arg = message.args[i];
            if (this.app.objects[arg])
                message.args[i] = this.app.objects[arg];
        }

        object[message.method].apply(object, message.args);
    }

    canvas(message) {
        let object = this.app.objects[message.id];
        let context = object.getContext(message.type);

        context[message.method].apply(context, message.args);
    }
}