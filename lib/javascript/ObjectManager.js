import Utilities from './Utilities.js'

export default class ObjectManager {
    constructor(root, logger) {
        this.logger = logger;
        this.objects = {
            "root": root
        };
    }

    insert(id, tag) {
        if (id in this.objects) {
            this.logger.log(`[ObjectManager] Inserting object ${id} that already exists!`);
            return;
        }

        const object = document.createElement(tag);
        object.id = id;

        this.objects[id] = object;
        this.objects.root.appendChild(object);
    }

    update(id, changes) {
        if (!(id in this.objects)) {
            this.logger.log(`[ObjectManager] Updating non-existant object ${id}!`);
            return;
        }

        const object = this.objects[id];
        Object.keys(changes).forEach(attr => {
            if (attr === "children") {
                for (let i = 0; i < changes.children.length; i++) {
                    const childId = changes.children[i];

                    if (!(childId in this.objects)) {
                        this.logger.log(`[ObjectManager] Updating hierarchy for non-existant child ${childId}!`);
                        return;
                    }

                    const child = this.objects[childId];
                    Utilities.insertAt(object, child, i);
                }
            } else if (!(attr in object)) {
                this.logger.log(`[ObjectManager] Unknown attribute '${attr}' for ${id}`);
            } else if (attr === "style") {
                Object.keys(changes[attr]).forEach(style => {
                    object.style[style] = changes.style[style];
                });
            } else {
                object[attr] = changes[attr];
                object.setAttribute(attr, changes[attr]);
            }
        });
    }

    remove(id) {
        if (!(id in this.objects)) {
            this.logger.log(`[ObjectManager] Removing object ${id} that does not exist!`);
            return;
        }

        this.objects[id].remove();
        delete this.objects[id];
    }

    invoke(id, functor, args) {
        if (!(id in this.objects)) {
            this.logger.log(`[ObjectManager] Invoking ${functor} on object ${id} that does not exist!`);
            return;
        }

        const object = this.objects[id];
        if (!(functor in object)) {
            this.logger.log(`[ObjectManager] Trying to invoke a non-existing functor ${functor}!`);
            return;
        }

        for (let i = 0; i < args.length; i++) {
            if (args[i] in this.objects)
                args[i] = this.app.objects[arg];
        }

        object[functor].apply(object, args);
    }
}