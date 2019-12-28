export default class Utilities {
    insertAt(parent, child, index) {
        if (!index) {
            index = 0
        }

        if (index >= parent.children.length) {
          parent.appendChild(child)
        } else {
          parent.insertBefore(child, this.children[index])
        }
    }
}