export default class Utilities {
    static insertAt(parent, child, index) {
        if (!index) {
            index = 0
        }

        if (index >= parent.children.length) {
            parent.appendChild(child)
        } else {
            parent.insertBefore(child, this.children[index])
        }
    }

    static stringifyEvent(e) {
        const obj = {};
        for (let k in e) {
            obj[k] = e[k];
        }

        return JSON.stringify(obj, (k, v) => {
            if (v instanceof Node) return "Node";
            if (v instanceof Window) return "Window";
            return v;
        }, ' ');
    }

    static allEvents = [
        "abort",
        "afterprint",
        "animationend",
        "animationiteration",
        "animationstart",
        "beforeprint",
        "beforeupload",
        "blur",
        "canplay",
        "canplaythrough",
        "change",
        "click",
        "contextmenu",
        "copy",
        "cut",
        "dblclick",
        "drag",
        "dragend",
        "dragenter",
        "dragleave",
        "dragover",
        "dragstart",
        "drop",
        "durationchange",
        "ended",
        "error",
        "focus",
        "focusin",
        "focusout",
        "fullscreenchange",
        "fullscreenerror",
        "hashchange",
        "input",
        "invalid",
        "keydown",
        "keypress",
        "keyup",
        "load",
        "loadeddata",
        "loadedmetadata",
        "loadstart",
        "message",
        "mousedown",
        "mouseenter",
        "mouseleave",
        "mousemove",
        "mouseover",
        "mouseout",
        "mouseup",
        "offline",
        "online",
        "open",
        "pagehide",
        "pageshow",
        "paste",
        "pause",
        "play",
        "playing",
        "popstate",
        "progress",
        "ratechange",
        "resize",
        "reset",
        "scroll",
        "search",
        "seeked",
        "seeking",
        "select",
        "show",
        "stalled",
        "storage",
        "submit",
        "suspend",
        "timeupdate",
        "toggle",
        "touchcancel",
        "touchend",
        "touchmove",
        "touchstart",
        "transitionend",
        "unload",
        "volumechange",
        "waiting",
        "wheel"
    ];
}