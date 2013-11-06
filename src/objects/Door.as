package objects
{
	import flash.text.TextField;

	public class Door extends GameObject
	{
		public function Door()
		{
			super();
            canHaveConnectedObject = true;
            initTextField();
            oType = "door";
		}

        protected function initTextField():void{
            textfield = new TextField();
            textfield.text = "BUTTON";
            textfield.textColor = 0xffffff;
            textfield.y = - 10;
            textfield.width = width;
            textfield.x = -width/2;
            textfield.height = 14;
            textfield.mouseEnabled = false;
            textView.addChild(textfield);
        }
		
		override public function draw(width, height):void{
            view.graphics.clear();
            view.graphics.beginFill(0x009900);
            view.graphics.drawRect(-width/2,-height/2,width, height);
		}

	}
}