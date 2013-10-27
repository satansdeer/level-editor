package objects
{
	import flash.text.TextField;
	
	public class Saw extends GameObject
	{
		public function Saw(objType:String, width:int=40, height:int=40)
		{
			super(objType, width, height);
            canHavePath = true;
		}
		
		override public function draw(width, height):void{
            view.graphics.beginFill(0x990099);
            view.graphics.drawCircle(0,0,width/2);
            textfield = new TextField();
			textfield.text = "SAW";
			textfield.textColor = 0xffffff;
			textfield.y = - 7;
			textfield.width = width;
            textfield.x = -width/2;
			textfield.height = 14;
			textfield.mouseEnabled = false;
            view.addChild(textfield);
		}
	}
}