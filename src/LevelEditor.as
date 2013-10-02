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
	
	public class LevelEditor extends Sprite
	{
		public var mapObjects:Array;
		private var objectsLayer:Sprite;
		private var guiLayer:Sprite;
		
		public function LevelEditor()
		{
			mapObjects = new Array();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

        public function loadFromString(str:String):void{
            var jsonMap:Object = JSON.parse(str);
            var objects:Array = jsonMap["objects"];
            for each (var obj:Object in objects){
                createObject(obj);
            }
        }

        protected function createObject(obj:Object):void{
            switch(obj["type"]){
                case "wall":
                    addWall(obj["x"], obj["y"]);
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
		
		protected function onItemSelect(event:ContextMenuEvent):void
		{
			switch(event.target.caption){
				case "Add wall":
					addWall(stage.mouseX, stage.mouseY);
					break;
				case "Add maul":
					addMaul(stage.mouseX, stage.mouseY);
					break;
				case "Add saw":
					addSaw(stage.mouseX, stage.mouseY);
					break;
				case "Add door":
					addDoor(stage.mouseX, stage.mouseY);
					break;
				case "Add button":
					addButton(stage.mouseX, stage.mouseY);
					break;
				case "Add tesla":
					addTesla(stage.mouseX, stage.mouseY);
					break;
				default:
					break;
			}
		}
		
		private function addTesla(mouseX:Number, mouseY:Number):void
		{
			var tesla:Tesla = new Tesla("tesla");
			tesla.x = mouseX;
			tesla.y = mouseY;
			tesla.delegate = this;
			mapObjects.push(tesla);
			objectsLayer.addChild(tesla);
		}
		
		private function addButton(mouseX:Number, mouseY:Number):void
		{
			var button:Button = new Button("button");
			button.x = mouseX;
			button.y = mouseY;
			button.delegate = this;
			mapObjects.push(button);
			objectsLayer.addChild(button);
		}
		
		private function addDoor(mouseX:Number, mouseY:Number):void
		{
			var door:Door = new Door("door");
			door.x = mouseX;
			door.y = mouseY;
			door.delegate = this;
			mapObjects.push(door);
			objectsLayer.addChild(door);
		}
		
		private function addSaw(mouseX:Number, mouseY:Number):void
		{
			var saw:Saw = new Saw("saw");
			saw.x = mouseX;
			saw.y = mouseY;
			saw.delegate = this;
			mapObjects.push(saw);
			objectsLayer.addChild(saw);
		}
		
		private function addMaul(mouseX:Number, mouseY:Number):void
		{
			var maul:Maul = new Maul("maul");
			maul.x = mouseX;
			maul.delegate = this;
			maul.y = mouseY;
			mapObjects.push(maul);
			objectsLayer.addChild(maul);
		}
		
		private function addWall(mouseX:Number, mouseY:Number):void
		{
			var wall:Wall = new Wall("wall");
			wall.x = mouseX;
			wall.y = mouseY;
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