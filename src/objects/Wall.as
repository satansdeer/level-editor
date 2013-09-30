package objects
{
	import flash.text.TextField;

	public class Wall extends GameObject
	{
		public function Wall(objType:String, width:int=40, height:int = 40)
		{
			super(objType, width, height);
		}
		
		override public function draw(width, height):void{
			graphics.beginFill(0x999900);
			graphics.drawRect(-width/2,-height/2,width, height);
            textfield = new TextField();
			textfield.text = "WALL";
			textfield.textColor = 0xffffff;
			textfield.y = -7;
            textfield.x = -width/2;
			textfield.width = width;
			textfield.height = 14;
			textfield.mouseEnabled = false;
			addChild(textfield);
		}
	}
}