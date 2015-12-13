
package ;

import luxe.options.EntityOptions;
import luxe.Entity;
import luxe.Input;
import luxe.Rectangle;
import luxe.Sprite;
import luxe.Text;
import luxe.tween.Actuate;
import luxe.utils.Maths;
import luxe.Vector;
import luxe.Visual;
import luxe.Color;
import luxe.components.sprite.SpriteAnimation;

import phoenix.Batcher;
import phoenix.Camera;
import phoenix.Texture.ClampType;
import phoenix.Texture.FilterType;


class Hud extends Entity
{

    @:isVar public var hud_batcher(default, null):Batcher;

    var camera:Camera;

    var level_txt:Text;
    var levelup_time_txt:Text;
    var score_txt:Text;
    

    var padding:Int = 3;
    
    override public function init():Void
    {
        camera = new Camera({
            camera_name: 'hud_camera',
        });
        camera.zoom = Luxe.camera.zoom;
        camera.center.set_xy( Luxe.camera.center.x, Luxe.camera.center.y );

        // Check if we don't already have our batcher
        for(b in Luxe.renderer.batchers){
            if(b.name == 'hud_batcher'){
                trace('found hud_batcher');
                hud_batcher = b;
            }
        }
        if(hud_batcher == null){
            trace('couldnt find hud_batcher' );
            hud_batcher = Luxe.renderer.create_batcher({
                name : 'hud_batcher',
                layer : 5,
                no_add : false,
                camera: camera,
            });
        }

        setup_text();

        initEvents();

    }

    override function ondestroy()
    {
        level_txt.destroy();
        levelup_time_txt.destroy();
        score_txt.destroy();

        // hud_batcher.destroy();
        // camera = null;
    }

    function initEvents()
    {
        Luxe.events.listen('player.item.ate', function(_)
        {
            Luxe.camera.shake(2);
        });

    }

    function setup_text()
    {
        level_txt = new Text({
            bounds: new Rectangle(padding, padding + Main.height/3, 90, 4),
            batcher: hud_batcher,
            color: new Color(1,1,1,1),
            point_size: 8,
        });

        levelup_time_txt = new Text({
            bounds: new Rectangle(padding, padding*2 + level_txt.bounds.y + level_txt.bounds.h, 90, 4),
            batcher: hud_batcher,
            color: new Color(1,1,1,1),
            point_size: 8,
        });

        score_txt = new Text({
            bounds: new Rectangle(padding, padding*2 + levelup_time_txt.bounds.y + levelup_time_txt.bounds.h, 90, 4),
            batcher: hud_batcher,
            color: new Color(1,1,1,1),
            point_size: 8,
        });
        
    }


    function update_text()
    {
        level_txt.text = 'level: ${Game.level}';
        levelup_time_txt.text = 'time: ${Math.floor( Game.levelup_time )}';
        score_txt.text = 'SCORE:\n${Game.score}';
    }


    override function update(dt:Float):Void
    {

        if(Game.playing)
        {
            update_text();
        }
    }

}
