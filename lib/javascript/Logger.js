export default class Logger {
    constructor(enabled) {
        this.enabled = enabled
    }

    log(message) {
        if(this.enabled) {
            console.log(message);
        }
    }
}