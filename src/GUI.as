package
{
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.ui.KeyLocation;
	import flash.ui.Keyboard;

import objects.GameObject;

public class GUI extends Sprite
	{
		
		private var rotateButton:PushButton;
        private var scaleButton:PushButton;
        private var deleteButton:PushButton;
        private var serializeButton:PushButton;

        private const MY_DEFAULT_EXTENSION:String = "json";
        private const VALID_EXTENSIONS_LIST:Array = ["json"];
        private var docsDir:File;

		public var delegate:Object;
		
		public function GUI(stg:Stage)
		{
			super();
			stg.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			rotateButton = new PushButton(this, 0,0,"Rotate",onClickRotate);
            scaleButton = new PushButton(this, 100,0,"Scale",onClickScale);
            deleteButton = new PushButton(this, 200,0,"Delete",onClickDelete);
            serializeButton = new PushButton(this, 300,0,"Serialize",onClickSerialize);
			addChild(rotateButton);
            addChild(scaleButton);
            addChild(deleteButton);
            addChild(serializeButton);
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
            var mapString:String = '{ "map":{"width":' +mapWidth+ ', "height":' +mapHeight+ '}';
            for each (var object:GameObject in delegate.mapObjects){
                var objWidth:int = Math.ceil(object.width* object.scaleX);
                var objHeight:int = Math.ceil(object.height* object.scaleY);
                mapString += ',"'+object.oType+'":'+'{"x":'+object.x+',"y":'+object.y+',"width":'+objWidth+
                        ',"height":'+objHeight+',"rotation":'+object.rotation;
                mapString+='}';
            }
            mapString+='}';
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
	}
}