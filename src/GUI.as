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
import flash.geom.Point;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.text.TextField;
import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
import flash.utils.ByteArray;

import objects.GameObject;

public class GUI extends Sprite
	{
		public var delegate:Object;
        private var _stage:Stage;
        private var _currentWindow:Window;
		
		public function GUI(stg:Stage)
		{
			super();
            _stage = stg;
			stg.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

        public function onClickLoad():void {
            delegate.loadMap();
        }

        public function onClickSerialize():void {
            delegate.saveMap();
        }

        public function onClickDelete():void {
             delegate.deleteSelected();
        }

        public function onClickScale():void {
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
		
		public function onClickRotate():void
		{
			delegate.rotateSelected();
		}

    private function onMapClick(event:MouseEvent):void {
        _stage.stageWidth = 100;
        _stage.stageHeight = 100;
        updateButtons();
        _stage.removeChild(_currentWindow);
    }

    private function updateButtons():void {

    }
}
}