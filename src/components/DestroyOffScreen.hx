
package components;

import luxe.Component;
import luxe.Rectangle;
import luxe.Sprite;
import luxe.Vector;

class DestroyOffScreen extends Component
{


    override function onfixedupdate(rate:Float)
    {
        var _v = Vector.Subtract( entity.pos, Luxe.camera.center );

        if(_v.length > Main.height)
        {
            // entity.events.fire('destroy.bydistance');
            // trace('${entity.name} destroyed');
            entity.destroy();
            // entity = null;
        }
    }


}
