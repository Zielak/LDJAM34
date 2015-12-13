package components;

import luxe.Vector;

class Particle extends luxe.Component {
    
    var velocity:Vector;

    override function onadded()
    {
        entity.fixed_rate = 1/(Math.random()*80+40);

        velocity = new Vector(Math.random()*40+20,0);
        velocity.angle2D = Math.random()*Math.PI*2 ;
    }

    override function init() {


    } //ready


    override function onfixedupdate(rate:Float) {

        velocity.y += 4;

        entity.pos.x += velocity.x*rate;
        entity.pos.y += velocity.y*rate;

    }

    override function update(dt:Float){

        // if(Game.playing){
        //     entity.pos.y = Math.round(realPos.y);
        // }

    }


}
