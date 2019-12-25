import Application from './lib/javascript/Application.js'

let __crimson_apps__ = [];

document.addEventListener('DOMContentLoaded', function() {
    const applications = [... document.getElementsByTagName('crimson')]
    applications.forEach(function(application, index){
        __crimson_apps__.push( new Application(application) );
    });
});