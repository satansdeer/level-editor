package objects
{
	import flash.text.TextField;

	public class Tesla extends GameObject
	{
		public function Tesla(objType:String, width:int=40, height:int=40)
		{
			super(objType, width, height);
            canHavePath = true;
            canHaveConnectedObject = true;
		}
		
		override public function draw(width, height):void{
            view.graphics.beginFill(0x000099);
            view.graphics.drawCircle(0,0,width/2);
            textfield = new TextField();
			textfield.text = "TESLA";
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