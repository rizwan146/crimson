import CrimsonApplication from './lib/javascript/Application.js'

let crimsonApplications = [];

document.addEventListener('DOMContentLoaded', function() {
    let applications = document.getElementsByTagName('crimson');

    for (let i = 0; i < applications.length; i++) {
        let application = applications[i];
        crimsonApplications.push( new CrimsonApplication(application) );
    }
});