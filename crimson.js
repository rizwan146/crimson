import ServerInteractor from './lib/javascript/ServerInteractor'

class CrimsonApplication {
    constructor(root) {
        this.uri = root.src;
        this.root = root;
        this.objects = {};
        this.serverInteractor = new ServerInteractor(this.uri);
    }
}

crimsonApplications = []

document.addEventListener('DOMContentLoaded', function() {
    let applications = document.getElementsByTagName('crimson');
    applications.forEach(function(application) {
        crimsonApplications.push( new CrimsonApplication(application) );
    });
});