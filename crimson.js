import ServerInteractor from './lib/javascript/ServerInteractor.js'

class CrimsonApplication {
    constructor(root) {
        this.uri = root.attributes.src.value;
        this.root = root;
        this.objects = {};
        this.serverInteractor = new ServerInteractor(this.uri);
    }
}

let crimsonApplications = [];

document.addEventListener('DOMContentLoaded', function() {
    let applications = document.getElementsByTagName('crimson');

    for(let i = 0; i < applications.length; i++) {
        let application = applications[i];
        crimsonApplications.push( new CrimsonApplication(application) );
    }
});