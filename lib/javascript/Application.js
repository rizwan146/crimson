import ServerInteractor from './ServerInteractor.js'
import Creater from './Creater.js'
import Updater from './Updater.js';
import Destroyer from './Destroyer.js';

export default class CrimsonApplication {
    constructor(root) {
        this.uri = root.attributes.src.value;
        this.root = root;
        this.objects = {};
        this.serverInteractor = new ServerInteractor(this);
        this.creater = new Creater(this);
        this.updater = new Updater(this);
        this.destroyer = new Destroyer(this);
    }
}