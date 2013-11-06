package
{
	import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import objects.Button;
	import objects.Door;
	import objects.GameObject;
	import objects.Maul;
	import objects.Saw;
	import objects.Tesla;
	import objects.Wall;

    [SWF(backgroundColor="#000000", frameRate="100")]
	public class LevelEditor extends Sprite
	{
		public var mapObjects:Array;
		private var objectsLayer:Sprite;
		private var guiLayer:Sprite;
        private const constSize:Number = 40;
        private var gui:GUI;

        private var obj1:GameObject;
        private var objectForPath:GameObject;
        private var biggestId:int = 0;
        private var mapLoader:MapLoader;
		
		public function LevelEditor()
		{
			mapObjects = new Array();
            mapLoader = new MapLoader();
            mapLoader.delegate = this;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

        public function saveMap():void{
            mapLoader.saveFile();
        }

        public function loadMap():void{
            mapLoader.loadFile();
        }

        public function loadFromString(str:String):void{
            for each(var object:GameObject in mapObjects){
                object.deleteSelf();
                this.objectsLayer.removeChild(object);
            }
            mapObjects = new Array;
            var jsonMap:Object = JSON.parse(str);
            var objects:Array = jsonMap["objects"];
            for each (var obj:Object in objects){
                createObjectFromJson(obj);
            }
        }

        protected function createObjectFromJson(obj:Object):void{
            var mapObj:GameObject = GameObject.getGameObjByType(obj["type"]);
            mapObj.initFromJSON(obj);
            mapObj.delegate = this;
            mapObjects.push(mapObj);
            objectsLayer.addChild(mapObj);
        }

        protected function makeNewObject(type:String):void{
            var mapObj:GameObject = GameObject.getGameObjByType(type);
            mapObj.id = uniqueId();
            mapObj.x = stage.mouseX;
            mapObj.y = stage.mouseY;
            mapObj.delegate = this;
            mapObjects.push(mapObj);
            objectsLayer.addChild(mapObj);
        }

		protected function onAddedToStage(event:Event):void
		{
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			objectsLayer = new Sprite();
			guiLayer = new Sprite();
			addChild(objectsLayer);
			addChild(guiLayer);
			gui = new GUI(stage);
			gui.delegate = this;
			guiLayer.addChild(gui);
            stage.addEventListener(MouseEvent.MOUSE_UP, onStageClick);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightClick);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

        public function onEnterFrame(event:Event):void{
            for (var i:int = 0; i< mapObjects.length; i++){
                (mapObjects[i] as GameObject).update();
            }
            redrawConnections();
        }

        private function onStageClick(event:MouseEvent):void {
            if(!objectForPath){
                deselectAll();
            }else{
                objectForPath.pathSprite.graphics.lineStyle(2,0x00ffff);
                objectForPath.pathSprite.graphics.lineTo(objectForPath.pathSprite.mouseX, objectForPath.pathSprite.mouseY);
                objectForPath.pathVector.push(new Point(objectForPath.pathSprite.mouseX, objectForPath.pathSprite.mouseY));
            }
        }

        protected function uniqueId():int{
            var result:int = mapObjects.length;
            while(isIdAlreadyUsed(result)){
                result++;
            }
            return result;
        }

        protected function isIdAlreadyUsed(id:int):Boolean{
            for each (var obj:GameObject in mapObjects){
                if(obj.id == id){
                    return true;
                }
            }
            return false;
        }

		protected function onItemSelect(event:ContextMenuEvent):void
		{
			switch(event.target.caption){
				case "Add wall":
					makeNewObject("wall");
					break;
				case "Add maul":
                    makeNewObject("maul");
					break;
				case "Add saw":
                    makeNewObject("saw");
					break;
				case "Add door":
                    makeNewObject("door");
					break;
				case "Add button":
                    makeNewObject("button");
					break;
				case "Add tesla":
                    makeNewObject("tesla");
					break;
                case "rotate":
                    gui.onClickRotate();
                    break;
                case "scale":
                    gui.onClickScale();
                    break;
                case "delete":
                    gui.onClickDelete();
                    break;
                case "save":
                    gui.onClickSerialize();
                    break;
                case "load":
                    gui.onClickLoad();
                    break;
				default:
					break;
			}
		}
		
		public function deselectAll():void{
			for (var i:int = 0; i < mapObjects.length; i++){
				mapObjects[i].deselect();
			}
		}
		
		public function rotateSelected():void{
			for (var i:int = 0; i < mapObjects.length; i++){
				mapObjects[i].rotate();
			}
		}

        public function scaleSelected():void{
            for (var i:int = 0; i < mapObjects.length; i++){
                mapObjects[i].scale();
            }
        }

        public function makeActionRight():void{
            for (var i:int = 0; i < mapObjects.length; i++){
                mapObjects[i].makeActionRight();
            }
        }

        public function makeActionLeft():void{
            for (var i:int = 0; i < mapObjects.length; i++){
                mapObjects[i].makeActionLeft();
            }
        }

        public function makeActionUp():void{
            for (var i:int = 0; i < mapObjects.length; i++){
                mapObjects[i].makeActionUp();
            }
        }

        public function makeActionDown():void{
            for (var i:int = 0; i < mapObjects.length; i++){
                mapObjects[i].makeActionDown();
            }
        }

        public function deleteSelected():void{
            for (var i:int = 0; i < mapObjects.length; i++){
                if(mapObjects[i].selected){
                    mapObjects[i].deleteSelf();
                    objectsLayer.removeChild(mapObjects[i]);
                    mapObjects.splice(i,1);
                }
            }
        }
		
		protected function onRightClick(event:Event):void
		{
            contextMenu = new ContextMenu();
            contextMenu.items = [
                new ContextMenuItem("Set map size"),
                new ContextMenuItem("Add wall",true),
                new ContextMenuItem("Add maul"),
                new ContextMenuItem("Add saw"),
                new ContextMenuItem("Add door"),
                new ContextMenuItem("Add button"),
                new ContextMenuItem("Add tesla"),
                new ContextMenuItem("rotate", true),
                new ContextMenuItem("scale"),
                new ContextMenuItem("delete"),
                new ContextMenuItem("save"),
                new ContextMenuItem("load"),
            ]
            for each (var obj:ContextMenuItem in contextMenu.items)
            {
                obj.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onItemSelect);
            }
			contextMenu.display(stage, stage.mouseX, stage.mouseY);
        }

        public function createPathFromObject(obj:GameObject):void{
             if(!obj.pathVector){
                 obj.pathVector = new Vector.<Point>();
             }
             objectForPath = obj;
            graphics.moveTo(obj.x, obj.y);
        }

        public function removePathFromObject(obj:GameObject):void{


    }

        public function addConnectedObject(obj:GameObject):void{
            obj.drawChooseFriendObject();
            obj1 = obj;
    }

        public function removeConnectedObject(obj:GameObject):void{
            if(obj.connectedObject){
                graphics.clear();
                obj.connectedObject.connectedObject = null;
                obj.connectedObject = null;
                redrawConnections();
            }
    }

        public function redrawConnections():void {
            graphics.clear();
            for each (var obj:GameObject in mapObjects){
                if(obj.connectedObject){
                    graphics.lineStyle(2,0xffffff);
                    graphics.moveTo(obj.x, obj.y);
                    graphics.lineTo(obj.connectedObject.x, obj.connectedObject.y);
                }
            }
        }

        public function setRotationSpeedForObject(obj:GameObject):void{

        }

        public function selectedObject(obj:GameObject):void{
            if(obj1 && obj.canHaveConnectedObject){
                graphics.lineStyle(2,0xffffff);
                graphics.moveTo(obj.x, obj.y);
                graphics.lineTo(obj1.x, obj1.y);
                obj.setConnectedObject(obj1);
                obj1.setConnectedObject(obj);
                obj1 = null;
                deselectAll();
            }else{
                if(objectForPath){
                    objectForPath.pathSprite.graphics.lineStyle(2,0x00ffff);
                    objectForPath.pathSprite.graphics.lineTo(objectForPath.pathSprite.mouseX, objectForPath.pathSprite.mouseY);
                    objectForPath.pathVector.push(new Point(objectForPath.pathSprite.mouseX, objectForPath.pathSprite.mouseY))
                    objectForPath = null;
                }
            }
        }
	}
}