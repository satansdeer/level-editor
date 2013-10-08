package
{
	import com.bit101.components.PushButton;
import com.bit101.components.TextArea;
import com.bit101.components.Window;

import flash.display.Sprite;
	import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.text.TextField;
import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
import flash.utils.ByteArray;

import objects.GameObject;

public class GUI extends Sprite
	{
		
		private var rotateButton:PushButton;
        private var scaleButton:PushButton;
        private var deleteButton:PushButton;
        private var serializeButton:PushButton;
        private var loadFromFileButton:PushButton;

        private var fileR:FileReference;

        private const MY_DEFAULT_EXTENSION:String = "json";
        private const VALID_EXTENSIONS_LIST:Array = ["json"];
        private var docsDir:File;

		public var delegate:Object;
        private var _stage:Stage;
        private var _currentWindow:Window;
		
		public function GUI(stg:Stage)
		{
			super();
            _stage = stg;
			stg.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			rotateButton = new PushButton(this, 0,0,"Rotate",onClickRotate);
            scaleButton = new PushButton(this, 100,0,"Scale",onClickScale);
            deleteButton = new PushButton(this, 200,0,"Delete",onClickDelete);
            serializeButton = new PushButton(this, 300,0,"Serialize",onClickSerialize);
            loadFromFileButton = new PushButton(this, 400, 0, "Load File", onClickLoad);
			addChild(rotateButton);
            addChild(scaleButton);
            addChild(deleteButton);
            addChild(serializeButton);
            addChild(loadFromFileButton);
		}

        private function onClickLoad(event:Event):void {
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

        private function onClickSerialize(event:Event):void {
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

        private function getStringMapDescription():String {
            var mapWidth:int = 100;
            var mapHeight:int = 100;
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

        private function onClickDelete(event:MouseEvent):void {
             delegate.deleteSelected();
        }

        private function onClickScale(event:MouseEvent):void {
            delegate.scaleSelected();
        }
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.RIGHT){
				delegate.makeActionRight()
			}else{
				if(event.keyCode == Keyboard.LEFT){
                    delegate.makeActionLeft();
				}else{
                    if(event.keyCode == Keyboard.UP){
                        delegate.makeActionUp();
                    }else{
                        if(event.keyCode == Keyboard.DOWN){
                            delegate.makeActionDown();
                        }
                    }
                }
			}
		}
		
		private function onClickRotate(event:MouseEvent):void
		{
			delegate.rotateSelected();
		}

    public function openMapWindow():void {
        var mapWindow:Window = new Window(this);
        var mW = _stage.stageWidth;
        var mH = _stage.stageHeight;
        var mapWidth:TextArea = new TextArea(mapWindow,0,0,mW.toString());
        var mapHeight:TextArea = new TextArea(mapWindow,0,30,mH.toString());
        var mapButton:PushButton = new PushButton(mapWindow,0,60,"ok");
        mapButton.addEventListener(MouseEvent.CLICK, onMapClick);
        mapWindow.x = _stage.stageWidth/2 - mapWindow.width/2;
        mapWindow.y = _stage.stageHeight/2 - mapWindow.height/2;
        _currentWindow = mapWindow;
    }

    private function onMapClick(event:MouseEvent):void {
        removeChild(_currentWindow);
    }
}
}