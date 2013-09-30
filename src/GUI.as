package
{
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	
	public class GUI extends Sprite
	{
		
		private var rotateButton:PushButton;
        private var scaleButton:PushButton;
        private var deleteButton:PushButton;
		public var delegate:Object;
		
		public function GUI(stg:Stage)
		{
			super();
			stg.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			rotateButton = new PushButton(this, 0,0,"Rotate",onClickRotate);
            scaleButton = new PushButton(this, 100,0,"Scale",onClickScale);
            deleteButton = new PushButton(this, 200,0,"Delete",onClickDelete);
			addChild(rotateButton);
            addChild(scaleButton);
            addChild(deleteButton);
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