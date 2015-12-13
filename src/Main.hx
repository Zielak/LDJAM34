
import luxe.Color;
import luxe.States;
import luxe.Input;
import luxe.utils.Random;
import snow.types.Types.SystemEvent;

class Main extends luxe.Game {

    var time:Float = 0;

    static public inline var width:Float = 150;
    static public inline var height:Float = 150;


    var machine:States;

    override function config(config:luxe.AppConfig) {

        config.preload.textures.push({ id:'assets/body.gif' });
        config.preload.textures.push({ id:'assets/head.gif' });
        
        config.preload.textures.push({ id:'assets/rope.gif' });

        config.preload.textures.push({ id:'assets/items.gif' });

        config.preload.textures.push({ id:'assets/branch.gif' });
        config.preload.textures.push({ id:'assets/spike.gif' });

        return config;

    } //config

    override public function onevent( event:SystemEvent ) {

        if(event.window != null){

            if(event.window.type == focus_lost){
                trace('focus_lost');
                Game.playing = false;
                // Luxe.snow.freeze = true;
            }else if(event.window.type == focus_gained){
                trace('focus_gained');
                Game.playing = true;
                // Luxe.snow.freeze = false;
            }
        }
    }

    override function ready() {

        // ZOOM
        Luxe.camera.zoom = 4;
        Luxe.camera.center.x = width/2;
        Luxe.camera.center.y = height/2;

        Luxe.draw.rectangle({
            x: 0, y: 0,
            w: width, h: height,
            color: new Color(0.2, 0.3, 0.1, 1),
        });

        // Machines
        machine = new States({ name:'statemachine' });

        // machine.add( new Intro() );
        machine.add( new Game() );
        // machine.add( new GameOver() );
        
        machine.set('game');


    } //ready

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(dt:Float) {

        time += dt;

    } //update

    public function resetGame()
    {

    }


} //Main
