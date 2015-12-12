
import luxe.States;
import luxe.Input;
import luxe.utils.Random;

class Main extends luxe.Game {

    static public inline var rope_x:Float = 150;
    static public inline var width:Float = 600;
    static public inline var height:Float = 600;

    
    var machine:States;

    override function config(config:luxe.AppConfig) {

        config.preload.textures.push({ id:'assets/body.gif' });
        config.preload.textures.push({ id:'assets/head.gif' });
        config.preload.textures.push({ id:'assets/rope.gif' });

        return config;

    } //config

    override function ready() {

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

    } //update

    public function resetGame()
    {

    }


} //Main
