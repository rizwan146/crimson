export default class Notifier {
    constructor(app) {
        this.app = app;
        this.handlers = {};
        this.meta = {};

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

    listenTo(id, events, metaList) {
        let me = this;
        let object = me.app.objects[id];

        // remove previous event handlers
        if (me.handlers[id]) {
            let keys = Object.keys(me.handlers[id]);
            for (let i = 0; i < keys.length; i++) {
                let event = keys[i];
                object.removeEventListener(event, me.handlers[id][event]);
            }
        }

        me.handlers[id] = {};

        if (!metaList)
            metaList = [];
            
        me.meta[id] = metaList;

        // add new handlers
        for (let i = 0; i < events.length; i++) {
            let event = events[i];
            me.handlers[id][event] = function(e) {
                let meta = {};                
                for (let i = 0; i < me.meta[id].length; i++) {
                    let key = me.meta[id][i];
                    meta[key] = object[key];
                }
                meta.event = JSON.parse(me.stringifyEvent(e));
                me.notify(id, event, meta);
            };
            object.addEventListener(event, me.handlers[id][event]);
        }
    }

    notify(id, event, meta) {
        this.app.serverInteractor.send({
            id: id,
            event: event,
            meta: meta,
            action: 'notify'
        });
    }

    stringifyEvent(e) {
        const obj = {};
        for (let k in e) {
          obj[k] = e[k];
        }
        return JSON.stringify(obj, (k, v) => {
          if (v instanceof Node) return 'Node';
          if (v instanceof Window) return 'Window';
          return v;
        }, ' ');
      }
}