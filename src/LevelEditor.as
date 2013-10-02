package
{
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		
		public function LevelEditor()
		{
			mapObjects = new Array();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
                createObject(obj);
            }
        }

        protected function createObject(obj:Object):void{
            switch(obj["type"]){
                case "wall":
                    addWall(obj["id"],obj["x"], obj["y"], obj["rotation"], obj["width"]/constSize);
                    break;
                case "maul":
                    addMaul(obj["id"],obj["x"], obj["y"], obj["rotation"], obj["width"]/constSize);
                    break;
                case "tesla":
                    addTesla(obj["id"],obj["x"], obj["y"], obj["rotation"], obj["width"]/constSize);
                    break;
                case "saw":
                    addSaw(obj["id"],obj["x"], obj["y"], obj["rotation"], obj["width"]/constSize);
                    break;
                case "door":
                    addDoor(obj["id"],obj["x"], obj["y"], obj["rotation"], obj["width"]/constSize);
                    break;
                case "button":
                    addButton(obj["id"],obj["x"], obj["y"], obj["rotation"], obj["width"]/constSize);
                break;
                default:
                break;
            }
        }

		protected function onAddedToStage(event:Event):void
		{
			objectsLayer = new Sprite();
			guiLayer = new Sprite();
			addChild(objectsLayer);
			addChild(guiLayer);
			
			var gui:GUI = new GUI(stage);
			gui.delegate = this;
			guiLayer.addChild(gui);
			
			
			contextMenu = new ContextMenu();
			contextMenu.items = [
				new ContextMenuItem("Set map size"),
				new ContextMenuItem("Add wall",true),
				new ContextMenuItem("Add maul"),
				new ContextMenuItem("Add saw"),
				new ContextMenuItem("Add door"),
				new ContextMenuItem("Add button"),
				new ContextMenuItem("Add tesla"),
			]
			for each (var obj:ContextMenuItem in contextMenu.items) 
			{
				obj.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onItemSelect);
			}
			
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
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
					addWall(uniqueId(),stage.mouseX, stage.mouseY);
					break;
				case "Add maul":
					addMaul(uniqueId(),stage.mouseX, stage.mouseY);
					break;
				case "Add saw":
					addSaw(uniqueId(),stage.mouseX, stage.mouseY);
					break;
				case "Add door":
					addDoor(uniqueId(),stage.mouseX, stage.mouseY);
					break;
				case "Add button":
					addButton(uniqueId(),stage.mouseX, stage.mouseY);
					break;
				case "Add tesla":
					addTesla(uniqueId(),stage.mouseX, stage.mouseY);
					break;
				default:
					break;
			}
		}
		
		private function addTesla(id:int, mouseX:Number, mouseY:Number, rot:Number = 0, objSize:Number = 1):void
		{
			var tesla:Tesla = new Tesla("tesla");
			tesla.x = mouseX;
			tesla.y = mouseY;
            tesla.rotation = rot;
			tesla.delegate = this;
			mapObjects.push(tesla);
			objectsLayer.addChild(tesla);
		}
		
		private function addButton(id:int, mouseX:Number, mouseY:Number, rot:Number = 0, objSize:Number = 1):void
		{
			var button:Button = new Button("button");
			button.x = mouseX;
			button.y = mouseY;
            button.rotation = rot;
			button.delegate = this;
			mapObjects.push(button);
			objectsLayer.addChild(button);
		}
		
		private function addDoor(id:int, mouseX:Number, mouseY:Number, rot:Number = 0, objSize:Number = 1):void
		{
			var door:Door = new Door("door");
			door.x = mouseX;
			door.y = mouseY;
            door.rotation = rot;
			door.delegate = this;
			mapObjects.push(door);
			objectsLayer.addChild(door);
		}
		
		private function addSaw(id:int, mouseX:Number, mouseY:Number, rot:Number = 0, objSize:Number = 1):void
		{
			var saw:Saw = new Saw("saw");
			saw.x = mouseX;
			saw.y = mouseY;
            saw.rotation = rot;
			saw.delegate = this;
			mapObjects.push(saw);
			objectsLayer.addChild(saw);
		}
		
		private function addMaul(id:int, mouseX:Number, mouseY:Number, rot:Number = 0, objSize:Number = 1):void
		{
			var maul:Maul = new Maul("maul");
			maul.x = mouseX;
			maul.delegate = this;
			maul.y = mouseY;
            maul.rotation = rot;
            maul.id = id;
			mapObjects.push(maul);
			objectsLayer.addChild(maul);
		}
		
		private function addWall(id:int, mouseX:Number, mouseY:Number, rot:Number = 0, objSize:Number = 1):void
		{
			var wall:Wall = new Wall("wall");
			wall.x = mouseX;
			wall.y = mouseY;
            wall.id = id;
            wall.rotation = rot;
            wall.scaleX = wall.scaleY = objSize;
			wall.delegate = this;
			mapObjects.push(wall);
			objectsLayer.addChild(wall);
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
			contextMenu.display(stage, stage.mouseX, stage.mouseY);
		}
	}
}