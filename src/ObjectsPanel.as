/**
 * Created with IntelliJ IDEA.
 * User: satansdeersatansdeer
 * Date: 06/11/13
 * Time: 22:11
 * To change this template use File | Settings | File Templates.
 */
package {
import com.bit101.components.PushButton;

import flash.display.Sprite;
import flash.events.Event;

public class ObjectsPanel extends Sprite{
    public var delegate:Object;
    private var rightButton:PushButton;
    private var leftButton:PushButton;
    public function ObjectsPanel(delegate:Object, w:int, h:int) {
        draw(w,h);
        rightButton = new PushButton(this,w-30,0,">");
        leftButton = new PushButton(this,0,0,"<");
        leftButton.width = rightButton.width = 30;
        rightButton.height = leftButton.height = h;
        delegate.delegate.stage.addEventListener(Event.RESIZE, resizeListener);
        this.delegate = delegate;

    }

    private function resizeListener(event:Event):void {
        y = delegate.delegate.stage.stageHeight - 100;
        draw(delegate.delegate.stage.stageWidth-200, 100);
        rightButton.x = delegate.delegate.stage.stageWidth-230;
    }

    private function draw(w:int, h:int):void{
        this.graphics.clear();
        this.graphics.beginFill(0x777777);
        this.graphics.drawRect(0,0,w, h);
    }
}
}
