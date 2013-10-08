package objects
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
import flash.text.TextField;

public class GameObject extends Sprite
	{
		public var oType:String;
		public var selection:Sprite;
		public var delegate:Object;
        public var id:int;

		public var selected:Boolean;

    public var scaling:Boolean;
        public var textfield:TextField;
    private var rotating:Boolean;
		
		public function GameObject(objType:String, width:int=40, height:int = 40)
		{
			super();
			selection = new Sprite();
			addChild(selection);
			oType = objType;
			draw(width, height);
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

    private function onMouseDown(event:MouseEvent):void {
        if(!selected){
            delegate.deselectAll();
            selected = true;
            drawSelection();
        }else{

        }
        startDrag();
    }

    private function onMouseUp(event:MouseEvent):void {
        stopDrag();
        event.stopPropagation();
        event.stopImmediatePropagation();
    }

        public function deleteSelf():void{
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
		
		private function drawSelection():void
		{
			selection.graphics.endFill();
			selection.graphics.lineStyle(2,0x0000ff);
			selection.graphics.drawRect(-width/2, -height/2, width,height);
		}
		
		public function deselect():void{
			selected = false;
            rotating = false;
            scaling = false;
			selection.graphics.clear();
		}
		
		public function rotate():void{
            if(selected || rotating || scaling){
				selection.graphics.clear();
				selection.graphics.endFill();
				selection.graphics.lineStyle(2,0xff0000);
				selection.graphics.drawRect(-width/2, -width/2, width,height);
                rotating = true;
                scaling = false;
			}
		}

        public function scale():void{
            if(selected || rotating || scaling){
            selection.graphics.clear();
            selection.graphics.endFill();
            selection.graphics.lineStyle(2,0x00ff00);
            selection.graphics.drawRect(-width/2, -width/2, width,height);
            scaling = true;
            rotating = false;
            }
        }

    public function makeActionLeft():void{
         if(rotating){
             rotateLeft()
         }else{
             if(scaling){
                 scaleLess();
             }else{
                 if(selected){
                    moveLeft();
                 }
             }
         }
    }

    private function moveLeft():void {
        x--;
    }

    private function moveUp():void {
        y--;
    }

    private function moveDown():void {
        y++;
    }

    public function makeActionDown():void{
                if(selected){
                    moveDown()
                }
    }

    public function makeActionUp():void{
        if(selected){
            moveUp()
        }
    }

    public function makeActionRight():void{
        if(rotating){
            rotateRight()
        }else{
            if(scaling){
                scaleMore();
            }else{
                if(selected){
                moveRight()
                }
            }
        }
    }

    private function moveRight():void {
        x++;
    }

    public function scaleMore():void{
        if(scaling){
            scaleX+=0.1;
            scaleY+=0.1;
        }
    }

    public function scaleLess():void{
        if(scaling){
            scaleX-=0.1;
            scaleY-=0.1;
        }
    }

        public function rotateRight():void{
            if(rotating){
                rotation++;
            }
        }

        public function rotateLeft():void{
            if(rotating){
                rotation--;
            }
        }
		
		public function draw(width, height):void{
			graphics.beginFill(0x00ff00);
			graphics.drawCircle(0,0,width/2);
		} 
	}
}