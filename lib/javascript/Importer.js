export default class Importer {
    constructor(app) {
        this.app = app;
        this.scriptsToLoad = [];
        this.isLoadingScript = false;
    }

    import(message) {
        let me = this;
        let head = document.getElementsByTagName('head')[0];
        let stylesheets = this.getStyleSheets();
        let scripts = this.getScripts();

        if (message.type === 'text/css' && !stylesheets.includes(message.href)) {
            let linkTag = document.createElement('link');
            
            linkTag.setAttribute('type', message.type);
            linkTag.setAttribute('rel', message.rel);
            linkTag.setAttribute('href', message.href);
            
            head.appendChild(linkTag);
        } else if (message.type === 'text/javascript' && !scripts.includes(message.src)) {
            // we need to load the scripts synchronously because there is
            // a possibility that one script depends on the other.
            let script = document.createElement('script');
            let scriptToLoad = {
                element: script,
                type: message.type,
                src: message.src
            };

            me.scriptsToLoad.push( scriptToLoad );

            if (!me.isLoadingScript)
                me.loadNextScript();
        }
    }

    loadNextScript() {
        let me = this;
        me.isLoadingScript = true;

        if (me.scriptsToLoad.length == 0) {
            me.isLoadingScript = false;
            return; // no scripts to load
        }

        // otherwise load the first script in the list
        let scriptToLoad = me.scriptsToLoad.shift();
        let head = document.getElementsByTagName('head')[0];

        scriptToLoad.element.onload = function() {
            // once this script is loaded, load the next script (if possible)
            me.loadNextScript();
        };

        scriptToLoad.element.setAttribute('type', scriptToLoad.type);
        scriptToLoad.element.setAttribute('src', scriptToLoad.src);

        head.appendChild(scriptToLoad.element);
    }

    getStyleSheets() {
        let stylesheets = [];
        let linkTags = document.getElementsByTagName('link');

        for( let i = 0; i < linkTags.length; i++ ) {
            let linkTag = linkTags[i];
            if (linkTag.href)
                stylesheets.push(linkTag.href);
        }

        return stylesheets;
    }

    getScripts() {
        let scripts = [];
        let scriptTags = document.getElementsByTagName('script');

        for( let i = 0; i < scriptTags.length; i++ ) {
            let scriptTag = scriptTags[i];
            if (scriptTag.src)
                scripts.push(scriptTag.src);
        }

        return scripts;
    }
}