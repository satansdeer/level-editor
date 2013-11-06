package objects
{
	import flash.text.TextField;

	public class Tesla extends GameObject
	{
		public function Tesla()
		{
			super();
            canHavePath = true;
            canHaveConnectedObject = true;
            initTextField();
            oType = "tesla";
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
            view.graphics.beginFill(0x000099);
            view.graphics.drawCircle(0,0,width/2);
		}
	}
}