
import luxe.Color;
import luxe.States;
import luxe.Input;
import luxe.utils.Random;

class Main extends luxe.Game {

    var time:Float = 0;

    static public inline var rope_x:Float = 150;
    static public inline var width:Float = 150;
    static public inline var height:Float = 150;


    var machine:States;

    override function config(config:luxe.AppConfig) {

        config.preload.textures.push({ id:'assets/body.gif' });
        config.preload.textures.push({ id:'assets/head.gif' });
        config.preload.textures.push({ id:'assets/rope.gif' });

        return config;

    } //config

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
