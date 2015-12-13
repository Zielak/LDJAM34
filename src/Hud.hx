
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
    var leveltime_txt:Text;
    

    var padding:Int = 10;
    
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

        setup_level();
        setup_leveltime();

        initEvents();

    }

    override function ondestroy()
    {
        level_txt.destroy();
        leveltime_txt.destroy();

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

    function setup_level()
    {
        level_txt = new Text({
            bounds: new Rectangle(Game.width/2-90, top_padding+10, 90, 10),
            batcher: hud_batcher,
            color: new Color().rgb(C.c4),
            point_size: 8,
        });
        
    }
    function update_lovetext()
    {
        distance_txt.text = 'distance: ${Math.round(Game.distance)}';
    }

    function setup_distancetxt()
    {
        distance_txt = new Text({
            bounds: new Rectangle(Game.width/2 + 20, top_padding+10, 90 - 20, 10),
            batcher: hud_batcher,
            color: new Color().rgb(C.c4),
            point_size: 8,
        });
    }
    function update_distancetxt()
    {
        distance_txt.text = 'love: ${Math.round(Game.love)}';
    }

    override function update(dt:Float):Void
    {

        if(Game.playing)
        {
            if(hearth != null) choose_hearth_animation();

            if(hope_bar_bg != null) update_hope_bar();
            if(dist_bar_bg != null) update_distance_bar();

            // update_lovetext();
            // update_distancetxt();
        }
    }


    function choose_hearth_animation()
    {
        if( Game.hope > 0.8 && hearth_anim.animation != 'beat')
        {
            hearth_anim.animation = 'beat';
            hearth_anim.play();
        }
        else if( (Game.hope > 0.6 && Game.hope <= 0.8) && hearth_anim.animation != 'beat_low')
        {
            hearth_anim.animation = 'beat_low';
            hearth_anim.play();
        }
        else if( (Game.hope > 0.3 && Game.hope <= 0.6) && hearth_anim.animation != 'beat_medium')
        {
            hearth_anim.animation = 'beat_medium';
            hearth_anim.play();
        }
        else if( Game.hope <= 0.3 && hearth_anim.animation != 'beat_hard')
        {
            hearth_anim.animation = 'beat_hard';
            hearth_anim.play();
        }
    }

    function update_hope_bar()
    {
        hope_bar_line.size.x = Math.round( hp_size * Maths.clamp(Game.hope, 0, 1) / 2 ) * 2;
        hope_bar_line.uv.w = Math.round( hp_size * Maths.clamp(Game.hope, 0, 1) / 2 ) * 2;
    }

    function update_distance_bar()
    {
        dist_me.pos.x = Maths.lerp( Game.width/2 + dist_bar_bg.size.x/2 - 6, Game.width/2 - dist_bar_bg.size.x/2, Game.gal_distance );
        dist_me.pos.x = Math.round( dist_me.pos.x );
    }






}
