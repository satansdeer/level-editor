/**
 * Created with IntelliJ IDEA.
 * User: satansdeersatansdeer
 * Date: 06/11/13
 * Time: 21:47
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Point;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.utils.ByteArray;

import objects.GameObject;

public class MapLoader {

    private var fileR:FileReference;
    private const MY_DEFAULT_EXTENSION:String = "json";
    private const VALID_EXTENSIONS_LIST:Array = ["json"];
    private var docsDir:File;
    public var delegate:Object;

    public function MapLoader() {
    }

    public function saveFile():void{
        docsDir = File.desktopDirectory; docsDir.browseForSave("Save As");
        docsDir.addEventListener(Event.SELECT, mySaveHandler);
    }

    private function mySaveHandler(event:Event):void {
        docsDir.removeEventListener(Event.SELECT, mySaveHandler);
        var tmpArr:Array = File(event.target).nativePath.split(File.separator);
        var fileName:String = tmpArr.pop();
        var conformedFileDef:String = conformExtension(fileName);
        tmpArr.push(conformedFileDef);
        var conformedFile:File = new File("file:///" + tmpArr.join(File.separator));
        var stream:FileStream = new FileStream();
        stream.open(conformedFile, FileMode.WRITE);
        stream.writeUTFBytes(getStringMapDescription());
        stream.close();
    }

    public function loadFile():void{
        fileR = new FileReference();
        var imageFilter = new FileFilter("JSON", "*.json");
        fileR.browse([imageFilter]);
        fileR.addEventListener(Event.CANCEL, cancelHandler);
        fileR.addEventListener(Event.SELECT, selectHandler);
        fileR.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        fileR.addEventListener(Event.COMPLETE, completeHandler);
    }

    function selectHandler(e:Event):void{ // file selected
        trace("selectHandler: "+fileR.name);
        fileR.load(); // load it
    }
    function cancelHandler(e:Event):void { // file select canceled
        trace("cancelHandler");
    }
    function progressHandler(e:ProgressEvent):void{ // progress event
        trace("progressHandler: loaded="+e.bytesLoaded+" total="+e.bytesTotal);
    }
    function completeHandler(e:Event):void{ // file loaded
        trace("completeHandler: " + fileR.name);
        var mapString:String = fileR.data.toString();
        delegate.loadFromString(mapString);
    }

    private function getStringMapDescription():String {
        var mapWidth:int = delegate.stage.stageWidth;
        var mapHeight:int = delegate.stage.stageHeight;
        var isFirstElement:Boolean = true;
        var mapString:String = '{ "map":{"width":' +mapWidth+ ', "height":' +mapHeight+ '}, "objects":[';
        for each (var object:GameObject in delegate.mapObjects){
            var objWidth:int = Math.ceil(object.width* object.scaleX);
            var objHeight:int = Math.ceil(object.height* object.scaleY);
            if(!isFirstElement){
                mapString += ",";
            }
            isFirstElement = false;
            mapString += '{"type":"'+object.oType+'", "x":'+object.x+',"y":'+object.y+',"width":'+objWidth+
                    ',"height":'+objHeight+',"rotation":'+object.rotation + ', "id":'+object.id;
            if(object.connectedObject){
                mapString+=', "friend":'+object.connectedObject.id;
            }
            if(object.canHavePath && object.pathVector){
                mapString+=', "walking_path":[';
                var isFirstPoint = true;
                for each (var point:Point in object.pathVector){
                    if(!isFirstPoint){mapString+=", "}
                    mapString+='{'+'"x":'+point.x+', "y":'+point.y+'}';
                    isFirstPoint = false;
                }
                mapString+="]"
            }
            mapString+='}';
        }
        mapString+=']}';
        return mapString;
    }

    private function conformExtension(fileDef:String):String {
        var fileExtension:String = fileDef.split(".")[1];
        for each(var it:String in VALID_EXTENSIONS_LIST){
            if( fileExtension == it){
                return fileDef;
            }
        }
        return fileDef.split(".")[0] + "." + MY_DEFAULT_EXTENSION;
    }

    public static function encode(ba:ByteArray):String {
        var origPos:uint = ba.position;
        var result:Array = new Array();

        for (ba.position = 0; ba.position < ba.length - 1; )
            result.push(ba.readShort());

        if (ba.position != ba.length)
            result.push(ba.readByte() << 8);

        ba.position = origPos;
        return String.fromCharCode.apply(null, result);
    }
}
}
