package components;

import luxe.Vector;

class Mover extends luxe.Component {
    
    // var realPos:Vector;

    override function onadded()
    {
        // realPos = entity.pos;
    }

    override function init() {

        entity.fixed_rate = 1/60;

    } //ready


    override function onfixedupdate(rate:Float) {

        if(Game.playing){
            
            // realPos.y += Game.speed * rate;
            entity.pos.y += Game.speed * rate;
            
        }

    }

    override function update(dt:Float){

        // if(Game.playing){
        //     entity.pos.y = Math.round(realPos.y);
        // }

    }


}
