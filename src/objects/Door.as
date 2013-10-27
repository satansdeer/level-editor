package objects
{
	import flash.text.TextField;

	public class Door extends GameObject
	{
		public function Door(objType:String, width:int=40, height:int=40)
		{
			super(objType, width, height);
            canHaveConnectedObject = true;
		}
		
		override public function draw(width, height):void{
			graphics.beginFill(0x009900);
            graphics.drawRect(-width/2,-height/2,width, height);
            textfield = new TextField();
			textfield.text = "DOOR";
			textfield.textColor = 0xffffff;
			textfield.y = -10;
            textfield.x = -width/2;
			textfield.width = width;
			textfield.height = 14;
			textfield.mouseEnabled = false;
			addChild(textfield);
		}

	}
}