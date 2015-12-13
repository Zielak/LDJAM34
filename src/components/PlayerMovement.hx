package components;

import luxe.Component;
import luxe.Vector;

class PlayerMovement extends Component
{

    var jumping:Bool = false;
    var dying:Bool = false;

    var target_x:Float = 0;
    var target_y:Float = 0;

    var jump_speed:Float = 70;

    var velocity:Vector;

    override function init()
    {
        target_y = entity.pos.y;

        velocity = new Vector(0,0);

        entity.events.listen('input.left', function(_){
            if(!jumping && Game.playing){
                jumping = true;
                target_x = entity.pos.x - Game.rope_x;
                velocity.x = -jump_speed;
                velocity.y = -40;
            }
        });

        entity.events.listen('input.right', function(_){
            if(!jumping && Game.playing){
                jumping = true;
                target_x = entity.pos.x + Game.rope_x;
                velocity.x = jump_speed;
                velocity.y = -40;
            }
        });

        Luxe.events.listen('game.over.*', function(_){
            velocity.y = -60;
            velocity.x = 0;
            jumping = false;
            dying = true;
        });
    }



    override function onfixedupdate(rate:Float)
    {
        if( jumping || dying ){
            entity.pos.x += velocity.x*rate;
            entity.pos.y += velocity.y*rate;
            velocity.y += 3;
        }
        else
        {
            if(entity.pos.y > target_y)
            {
                entity.pos.y -= Math.abs(entity.pos.y - target_y) * 0.1;
            }
            else if(entity.pos.y < target_y)
            {
                entity.pos.y += Math.abs(entity.pos.y - target_y) * 0.1;
            }
        }

        if(!dying){

            if(velocity.x > 0){
                if(entity.pos.x >= target_x){
                    stop_jumping();
                }
            }
            else if(velocity.x < 0){
                if(entity.pos.x <= target_x){
                    stop_jumping();
                }
            }

            // Off screen
            if(entity.pos.x <= 0 + Game.rope_x/2 || entity.pos.x >= Main.width - Game.rope_x/2){
                
                Game.game_over('no_rope');
            }
        }



        
    }


    function stop_jumping()
    {
        entity.pos.x = target_x;

        velocity.x = 0;
        velocity.y = 0;

        jumping = false;
    }

}
