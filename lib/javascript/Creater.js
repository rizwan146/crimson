export default class Creater {
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
    }
}