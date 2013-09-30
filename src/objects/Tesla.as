package objects
{
	import flash.text.TextField;

	public class Tesla extends GameObject
	{
		public function Tesla(objType:String, width:int=40, height:int=40)
		{
			super(objType, width, height);
		}
		
		override public function draw(width, height):void{
			graphics.beginFill(0x000099);
			graphics.drawCircle(-width/2,-height/2,width/2);
            textfield = new TextField();
			textfield.text = "TESLA";
			textfield.textColor = 0xffffff;
			textfield.y = height/2 - 7;
			textfield.width = width;
			textfield.height = 14;
			textfield.mouseEnabled = false;
			addChild(textfield);
		}
	}
}