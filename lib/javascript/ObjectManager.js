export default class ObjectManager {
    constructor(root, logger) {
        this.logger = logger;
        this.objects = {
            "root": root
        };
    }

    get(id) {
        if (this.contains(id)) {
            return this.objects[id];
        }

        throw `[ObjectManager] Attempting to get unknown object ${id}!`
    }

    insert(id, object) {
        if (!this.contains(id)) {
            object.id = id
            this.objects[id] = object;
        }

        throw `[ObjectManager] Attempting to set already existing object ${id}!`
    }

    contains(id) {
        return id in this.objects;
    }

    remove(id) {
        delete this.objects[id];
    }
}