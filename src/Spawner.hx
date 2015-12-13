package ;

import luxe.Entity;
import luxe.Rectangle;
import luxe.Sprite;
import luxe.utils.Random;
import luxe.Vector;
import luxe.components.sprite.SpriteAnimation;

class Spawner extends Entity
{
    
    var time_ropes:Float = 32;

    var choose:Float = 0;

    override function init() {

        fixed_rate = 1/60;

        for(i in -1...5){
            place_rope(0, i*32);
            place_rope(1, i*32);
            place_rope(2, i*32);
        }

        Luxe.events.listen('game.init', function(_){
            time_ropes = 0;
        });

    } //ready


    override function onfixedupdate(rate:Float){


        if(Game.playing){

            time_ropes -= Game.speed * rate;

            if(time_ropes <= 0){

                spawn_ropes(-time_ropes);

                choose = Game.rnd.float(0,1);

                if(choose >= 0 && choose < 0.3){

                    place_item(Game.rnd.int(0,2));

                }else if(choose < 0.4){

                    place_spike(Game.rnd.int(0,2));

                }

            }
        }

    }


    function spawn_ropes(diff:Float) {

        time_ropes = 32 + diff;

        place_rope(0, -32 - diff);
        place_rope(1, -32 - diff);
        place_rope(2, -32 - diff);
    }

    function place_rope(row:Int, ?_y:Float = -32) {

        var frame = Game.rnd.int(0,5);

        var rope = new Sprite({
            name: 'rope',
            name_unique: true,
            centered: false,
            texture: Luxe.resources.texture('assets/rope.gif'),
            pos: new Vector(Game.rope_x + row * Game.rope_x - 8, _y),
            uv: new Rectangle(frame*16, 0, 16, 32),
            depth: 1,
            size: new Vector(16,32),
        });

        rope.texture.filter_mag = nearest;
        rope.texture.filter_min = nearest;

        rope.add( new components.Mover() );
        rope.add( new components.DestroyOffScreen() );

    }

    function place_item(row:Int) {

        var frame = Game.rnd.int(0,3);

        var item = new Sprite({
            name: 'item',
            name_unique: true,
            centered: false,
            texture: Luxe.resources.texture('assets/items.gif'),
            pos: new Vector(Game.rope_x + row * Game.rope_x - 16, -32),
            uv: new Rectangle(frame*32, 0, 32, 32),
            depth: 3,
            size: new Vector(32,32),
        });
        item.texture.filter_mag = nearest;
        item.texture.filter_min = nearest;

        item.add( new components.Mover() );
        item.add( new components.Collider({
            shape: luxe.collision.shapes.Polygon.rectangle(0, 0, 16, 16, false),
            offset: new Vector(8,3),
        }) );
        item.add( new components.DestroyOffScreen() );

    }


    function place_spike(row:Int) {


        var spike = new Sprite({
            name: 'obstacle.spike',
            name_unique: true,
            centered: false,
            texture: Luxe.resources.texture('assets/spike.gif'),
            pos: new Vector(Game.rope_x + row * Game.rope_x - 16, -48),
            depth: 10,
            size: new Vector(32,32),
        });
        spike.texture.filter_mag = nearest;
        spike.texture.filter_min = nearest;
        spike.add( new components.Mover() );
        spike.add( new components.Collider({
            shape: luxe.collision.shapes.Polygon.rectangle(0, 0, 8, 8, false),
            offset: new Vector(16,16),
        }) );
        spike.add( new components.DestroyOffScreen() );

        var anim = new SpriteAnimation({ name:'anim' });
        spike.add( anim );

        var animation_json = '
            {
                "idle" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": [1],
                    "pingpong":"false",
                    "loop": "true",
                    "speed": "4"
                },
                "dead" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["2-3"],
                    "pingpong":"false",
                    "loop": "true",
                    "speed": "15"
                }
            }
        ';

        anim.add_from_json( animation_json );
        anim.animation = 'idle';
        anim.play();

        spike.events.listen('collider.hit', function(_){
            anim.animation = 'dead';
            anim.play();
        });

        var branch = new Sprite({
            name: 'branch',
            name_unique: true,
            centered: false,
            texture: Luxe.resources.texture('assets/branch.gif'),
            pos: new Vector(0, -32),
            depth: 9,
            size: new Vector(150,32),
        });
        branch.texture.filter_mag = nearest;
        branch.texture.filter_min = nearest;
        branch.add( new components.Mover() );
        branch.add( new components.DestroyOffScreen() );

    }

}