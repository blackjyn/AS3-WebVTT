/**
 * Created by joseph.labrecque on 12/9/2014.
 */
package edu.du.captions.data {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class CaptionsParser {
    private var rawArray:Array;
    private var captionsLoader:URLLoader;
    private var _captionsArray:Array;

    public function CaptionsParser() {
        captionsLoader = new URLLoader();
        _captionsArray = new Array();
        rawArray = new Array();
    }
    public function loadCaptions(f:String):void {
        captionsLoader.addEventListener(Event.COMPLETE, captionsLoaded);
        captionsLoader.addEventListener(IOErrorEvent.IO_ERROR, captionsError);
        captionsLoader.load(new URLRequest(f));
    }
    private function parseCaptions(r:Array):void {
        var l:int = r.length;
        for (var i:int = 1; i < l; i++) {
            var caption:Object = new Object();
            var startTime:String = r[i].substr(0, 12);
            var stopTime:String = r[i].substr(17, 12);
            var textIndex:int = r[i].indexOf("\r\n");
            var captionText:String = r[i].substr(textIndex + 2);
            caption.startTime = startTime;
            caption.stopTime = stopTime;
            caption.captionText = captionText.replace("\r\n", "<br>");
            _captionsArray.push(caption);
        }
    }
    private function captionsError(e:IOErrorEvent):void {}
    public function captionsLoaded(e:Event):void {
        rawArray = e.target.data.split("\r\n\r\n");
        parseCaptions(rawArray);
        captionsLoader.removeEventListener(Event.COMPLETE, captionsLoaded);
    }
    public function get captionsArray():Array {
        return _captionsArray;
    }
}
}