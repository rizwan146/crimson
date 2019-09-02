export default class Notifier {
    constructor(app) {
        this.app = app;
        this.handlers = {};

        // Set event descriptions @ https://www.w3schools.com/jsref/dom_obj_event.asp
        this.events = [
            'abort',
            'afterprint',
            'animationend',
            'animationiteration',
            'animationstart',
            'beforeprint',
            'beforeupload',
            'blur',
            'canplay',
            'canplaythrough',
            'change',
            'click',
            'contextmenu',
            'copy',
            'cut',
            'dblclick',
            'drag',
            'dragend',
            'dragenter',
            'dragleave',
            'dragover',
            'dragstart',
            'drop',
            'durationchange',
            'ended',
            'error',
            'focus',
            'focusin',
            'focusout',
            'fullscreenchange',
            'fullscreenerror',
            'hashchange',
            'input',
            'invalid',
            'keydown',
            'keypress',
            'keyup',
            'load',
            'loadeddata',
            'loadedmetadata',
            'loadstart',
            'message',
            'mousedown',
            'mouseenter',
            'mouseleave',
            'mousemove',
            'mouseover',
            'mouseout',
            'mouseup',
            'offline',
            'online',
            'open',
            'pagehide',
            'pageshow',
            'paste',
            'pause',
            'play',
            'playing',
            'popstate',
            'progress',
            'ratechange',
            'resize',
            'reset',
            'scroll',
            'search',
            'seeked',
            'seeking',
            'select',
            'show',
            'stalled',
            'storage',
            'submit',
            'suspend',
            'timeupdate',
            'toggle',
            'touchcancel',
            'touchend',
            'touchmove',
            'touchstart',
            'transitionend',
            'unload',
            'volumechange',
            'waiting',
            'wheel'
        ];
    }

    listenTo(id, events) {
        let me = this;
        let object = me.app.objects[id];

        // remove previous event handlers
        if (me.handlers[id]) {
            keys = Object.keys(me.handlers[id]);
            for (let i = 0; i < keys.length; i++) {
                let event = keys[i];
                object.removeEventListener(event, me.handlers[id][event]);
            }
        }
        me.handlers[id] = {};

        // add new handlers
        for (let i = 0; i < events.length; i++) {
            let event = events[i];
            me.handlers[id][event] = function(e) { me.notify(id, event); };
            object.addEventListener(event, me.handlers[id][event]);
        }
    }

    notify(id, event) {
        this.app.serverInteractor.send({
            id: id,
            event: event,
            action: 'notify'
        });
    }
}