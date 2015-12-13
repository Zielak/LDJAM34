
package components;

import luxe.Color;
import luxe.Component;
import luxe.Input;
import luxe.Vector;

class PlayerInput extends Component
{

    public var left:Bool    = false;
    public var right:Bool   = false;

    override function init():Void
    {
        Luxe.input.bind_key('left', Key.key_a);
        Luxe.input.bind_key('right', Key.key_d);

        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('right', Key.right);
    }

    override function update(dt:Float):Void
    {
        updateKeys();
    }


    function updateKeys():Void
    {
        left  = Luxe.input.inputpressed('left');
        right = Luxe.input.inputpressed('right');

        if(left && right){
            left = right = false;
        }
        if(left){
            entity.events.fire('input.left');
        }
        if(right){
            entity.events.fire('input.right');
        }

    }


}
