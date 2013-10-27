package objects
{
	import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

public class GameObject extends Sprite
	{
		public var oType:String;
		public var selection:Sprite;
        public var view:Sprite = new Sprite();
		public var delegate:Object;
        public var id:int = 0;
        public var connectedObject:GameObject;
        public var pathVector:Vector.<Point>;

		public var selected:Boolean;

    public var scaling:Boolean;
    public var textfield:TextField;
    public var idTextfield:TextField;
    private var rotating:Boolean;
    public var canHavePath:Boolean = false;
    public var hasRotationSpeed:Boolean = false;
    public var canHaveConnectedObject:Boolean = false;
    public const pathSprite:Sprite = new Sprite();
		
		public function GameObject(objType:String, width:int=40, height:int = 40)
		{
			super();
			selection = new Sprite();
			addChild(selection);
            addChild(pathSprite);
            addChild(view);
			oType = objType;
			draw(width, height);
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightClick);
		}

    public function onRightClick(event:MouseEvent):void {
        event.stopPropagation();
        event.stopImmediatePropagation();
        contextMenu = new ContextMenu();
        contextMenu.items = [];
        if(canHavePath){
            contextMenu.addItem(new ContextMenuItem("create path"));
            contextMenu.addItem(new ContextMenuItem("remove path"));
        }
        if(canHaveConnectedObject){
            contextMenu.addItem(new ContextMenuItem("add connected object"));
            contextMenu.addItem(new ContextMenuItem("remove connected object"));
        }
        if(hasRotationSpeed){
            contextMenu.addItem(new ContextMenuItem("set rotation speed"));
        }
        for each (var obj:ContextMenuItem in contextMenu.items)
        {
            obj.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onItemSelect);
        }
        contextMenu.display(stage, stage.mouseX, stage.mouseY);
    }

    private function onItemSelect(event:ContextMenuEvent):void {
        switch(event.target.caption){
            case "create path":
                delegate.createPathFromObject(this);
                break;
            case "remove path":
                delegate.removePathFromObject(this);
                break;
            case "add connected object":
                delegate.addConnectedObject(this);
                break;
            case "remove connected object":
                delegate.removeConnectedObject(this);
                break;
            case "set rotation speed":
                delegate.setRotationSpeedForObject(this);
                break;
            default:
                break;
        }
    }

    private function onMouseDown(event:MouseEvent):void {
        delegate.selectedObject(this);
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
        delegate.redrawConnections();
    }

        public function deleteSelf():void{
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
		
		private function drawSelection():void
		{
			selection.graphics.endFill();
			selection.graphics.lineStyle(2,0x0000ff);
			selection.graphics.drawRect(-view.width/2/scaleX, -view.height/2/scaleY, view.width/scaleX,view.height/scaleY);
		}

    public function drawChooseFriendObject():void
    {
        selection.graphics.endFill();
        selection.graphics.lineStyle(4,0xff00ff);
        selection.graphics.drawRect(-view.width/2/scaleX, -view.height/2/scaleY, view.width/scaleX,view.height/scaleY);
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
                selection.graphics.drawRect(-view.width/2/scaleX, -view.height/2/scaleY, view.width/scaleX,view.height/scaleY);
                rotating = true;
                scaling = false;
			}
		}

        public function scale():void{
            if(selected || rotating || scaling){
            selection.graphics.clear();
            selection.graphics.endFill();
            selection.graphics.lineStyle(2,0x00ff00);
            selection.graphics.drawRect(-view.width/2/scaleX, -view.height/2/scaleY, view.width/scaleX,view.height/scaleY);
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
            view.graphics.beginFill(0x00ff00);
            view.graphics.drawCircle(0,0,width/2);
		}

    public function setConnectedObject(obj1:GameObject):void {
        connectedObject = obj1;
    }
}
}