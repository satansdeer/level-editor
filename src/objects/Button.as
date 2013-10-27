package objects
{
	import flash.text.TextField;
import flash.ui.GameInput;

public class Button extends GameObject
	{

		public function Button(objType:String, width:int=40, height:int=40)
		{
			super(objType, width, height);
            canHaveConnectedObject = true;
		}
		
		override public function draw(width, height):void{
            view.graphics.beginFill(0x009900);
            view.graphics.drawCircle(0,0,width/2);
            textfield = new TextField();
			textfield.text = "BUTTON";
            textfield.textColor = 0xffffff;
            textfield.y = - 10;
            textfield.width = width;
            textfield.x = -width/2;
            textfield.height = 14;
            textfield.mouseEnabled = false;
            view.addChild(textfield);
		}
	}
}