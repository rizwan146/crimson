import ServerInteractor from './ServerInteractor.js'
import ObjectManager from './ObjectManager.js'
import Logger from './Logger.js'

export default class Application {
    constructor(root) {
        this.uri = root.attributes.src.value;
        this.root = root;
        this.logger = new Logger(true);
        this.objectManager = new ObjectManager(this.logger);
        this.serverInteractor = new ServerInteractor(this.uri, this.objectManager, this.logger);
    }
}