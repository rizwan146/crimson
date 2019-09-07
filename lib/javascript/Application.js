import ServerInteractor from './ServerInteractor.js'
import Creator from './Creator.js'
import Updater from './Updater.js';
import Destroyer from './Destroyer.js';
import Notifier from './Notifier.js';
import Invoker from './Invoker.js';

export default class CrimsonApplication {
    constructor(root) {
        this.uri = root.attributes.src.value;
        this.root = root;
        this.objects = {};
        this.serverInteractor = new ServerInteractor(this);
        this.creator = new Creator(this);
        this.updater = new Updater(this);
        this.destroyer = new Destroyer(this);
        this.notifier = new Notifier(this);
        this.invoker = new Invoker(this);
    }
}