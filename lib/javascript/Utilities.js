export default class Utilities {
    static insertAt(parent, child, index) {
        if (!index) {
            index = 0
        }

        if (index >= parent.children.length) {
            parent.appendChild(child)
        } else {
            parent.insertBefore(child, this.children[index])
        }
    }

    static stringifyEvent(e) {
        const obj = {};
        for (let k in e) {
            obj[k] = e[k];
        }

        return JSON.stringify(obj, (k, v) => {
            if (v instanceof Node) return v.id;
            if (v instanceof Window) return "Window";
            return v;
        }, ' ');
    }
}