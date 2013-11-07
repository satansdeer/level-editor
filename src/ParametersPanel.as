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

public class ParametersPanel extends Sprite{
    public var delegate:Object;
    public function ParametersPanel(delegate:Object, w:int, h:int) {
        draw(w,h);
        delegate.delegate.stage.addEventListener(Event.RESIZE, resizeListener);
        this.delegate = delegate;

    }

    private function resizeListener(event:Event):void {
        draw(200, delegate.delegate.stage.stageHeight);
    }

    private function draw(w:int, h:int):void{
        this.graphics.clear();
        this.graphics.beginFill(0x777777);
        this.graphics.drawRect(0,0,w, h);
    }
}
}
