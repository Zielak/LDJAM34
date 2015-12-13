package components;

import luxe.Component;

class Belly extends Component{
    
    public var value:Float = 0.5;
    public var hunger:Float = 0.05;

    var time:Float = 0;

    override function init()
    {
        entity.events.listen('player.item.ate', function(_){
            value += 0.2;
        });
    }

    override function onfixedupdate(rate:Float)
    {
        if(Game.playing){
            value -= hunger*rate;

            if(value <= 0){
                Game.game_over('hunger');
            }
            else if(value > 1.5)
            {
                Game.game_over('belly_pop');
                entity.destroy();
            }
            else
            {
                update_belly();
            }

            // time += rate;
            // value = (Math.sin(time)+1) / 2;
        }

    }

    function update_belly()
    {
        entity.scale.x = value;
    }

}
