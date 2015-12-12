package ;

import luxe.Entity;
import luxe.Rectangle;
import luxe.Sprite;
import luxe.utils.Random;
import luxe.Vector;

class Spawner extends Entity
{
    


    override function init() {

        fixed_rate = 1/30;

    } //ready


    override function onfixedupdate(rate:Float){

    }


    function placeRope(row:Int) {

        var frame = Game.rnd.int(0,5);

        var rope = new Sprite({
            name: 'rope',
            name_unique: true,
            texture: Luxe.resources.texture('assets/rope.gif'),
            pos: new Vector(Main.rope_x + row * Main.rope_x),
            uv: new Rectangle(frame*16, 0, 16, 32),
            depth: 1,
            size: new Vector(16,16),
        });

        rope.texture.filter_mag = nearest;
        rope.texture.filter_min = nearest;

        rope.add(new components.Mover() );

    }

}