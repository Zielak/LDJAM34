
import luxe.collision.ShapeDrawerLuxe;
import luxe.Color;
import luxe.Rectangle;
import luxe.Sprite;
import luxe.States;
import luxe.components.sprite.SpriteAnimation;
import luxe.Text;
import luxe.utils.Random;
import luxe.Vector;
import luxe.Visual;


class Game extends State {

    static public var rnd:Random;
    static public var shape_drawer:ShapeDrawerLuxe;

    static public inline var rope_x:Float = 37;

    public static var level:Int;
    public static var time:Float;
    public static var levelup_time:Float;
    public static var distance:Float;
    public static var speed:Float;
    public static var difficulty:Float;
    public static var score:Int;


    public static var playing:Bool = false;
    public static var gameover:Bool = false;



    var player:Sprite;

    var spawner:Spawner;
    var hud:Hud;

    public static var gameover_text:Text;

    public function new()
    {
        super({ name:'game' });

        Game.shape_drawer = new ShapeDrawerLuxe({
            depth: 20,
        });

        
        Game.rnd = new Random(Math.random());
        Game.score = 0;
        Game.level = 0;
        Game.time = 0;
        Game.levelup_time = 0;
        Game.distance = 0;
        Game.speed = 38;
    }



    override function onenter<T>(_:T) 
    {
        reset();

        create_player();

        init_events();

        spawner = new Spawner({name: 'spawner'});
        hud = new Hud({name:'hud'});


        Luxe.timer.schedule(2, function(){
            Game.playing = true;
            Luxe.events.fire('game.start');
            trace('Game.playing: '+Game.playing);
        });


        Luxe.events.fire('game.init');
    }



    override function onleave<T>(_:T) 
    {
        player.destroy();
        spawner.destroy();
        hud.destroy();
        if(Game.gameover_text != null) Game.gameover_text.destroy();

        Luxe.scene.empty();
    }




    function reset()
    {
        Game.score = 0;
        Game.level = 0;
        Game.levelup_time = 0;
        Game.difficulty = 0;
        Game.time = 0;
        Game.distance = 0;
        Game.speed = 38;

        Game.playing = false;
        Game.gameover = false;

        Luxe.events.fire('game.reset');
    }

    public static function game_over(reason:String)
    {
        Game.playing = false;
        Game.gameover = true;
        Luxe.events.fire('game.over.${reason}');

        Game.gameover_text = new Text({
            bounds: new Rectangle(10, Main.height/3, Main.width - 20, Main.height/3),
            color: new Color(1,1,1,1),
            point_size: 12,
            align: center,
            align_vertical: center,
            depth: 20,
        });

        switch(reason){
            case 'obstacle':
                gameover_text.text = 'GAME OVER\nYou were attacked\nby SPIKES';
            case 'hunger':
                gameover_text.text = 'GAME OVER\nYou died of hunger';
            case 'belly_pop':
                gameover_text.text = 'GAME OVER\nYou ate TOO MUCH';
            case 'no_rope':
                gameover_text.text = 'GAME OVER\nStay on the ropes, silly';
            default:
                gameover_text.text = 'GAME OVER\nfor no reason...';
        }

        gameover_text.text += '\n\npress [R] to restart';
    }

    public static function levelup()
    {
        trace('levelup!');
        Game.level ++;
        Game.levelup_time = 10;
        Game.speed *= 1.2;
    }






    function create_player()
    {

        // Player and head

        player = new Sprite({
            name: 'player',
            texture: Luxe.resources.texture('assets/head.gif'),
            size: new Vector(32,32),
            pos: new Vector(Main.width/2, Main.height/4*3),
            centered: true,
            depth: 5.7,
        });
        player.texture.filter_mag = nearest;
        player.texture.filter_min = nearest;
        player.fixed_rate = 1/60;

        var collider = new components.Collider({
            testAgainst: ['item', 'obstacle'],
            shape: luxe.collision.shapes.Polygon.rectangle(0, 0, 16, 16, true),
        });

        player.add(collider);


        var anim_h = new SpriteAnimation({ name:'anim' });
        player.add( anim_h );

        var animation_json = '
            {
                "idle" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["5-6"],
                    "pingpong":"false",
                    "loop": "true",
                    "speed": "4"
                },
                "chomp" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["1-4"],
                    "events" : [{"frame":4, "event":"stop_chomp"}],
                    "pingpong":"false",
                    "loop": "false",
                    "speed": "10"
                },
                "dead" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": [7],
                    "pingpong":"false",
                    "loop": "false",
                    "speed": "6"
                }
            }
        ';

        anim_h.add_from_json( animation_json );
        anim_h.animation = 'idle';
        anim_h.play();

        player.events.listen('stop_chomp', function(e){
            anim_h.animation = 'idle';
            anim_h.play();
        });


        // Body

        var body = new Sprite({
            name: 'player_body',
            texture: Luxe.resources.texture('assets/body.gif'),
            size: new Vector(32,32),
            pos: new Vector(16, 34),
            parent: player,
            centered: true,
            depth: 5.3,
        });
        body.texture.filter_mag = nearest;
        body.texture.filter_min = nearest;
        body.fixed_rate = 1/60;

        var anim_b = new SpriteAnimation({ name:'anim' });
        body.add( anim_b );

        var animation_json2 = '
            {
                "climb" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["1-4"],
                    "pingpong":"false",
                    "loop": "true",
                    "speed": "8"
                },
                "dead" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["5"],
                    "pingpong":"false",
                    "loop": "false",
                    "speed": "1"
                },
                "pop" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["6"],
                    "pingpong":"false",
                    "loop": "false",
                    "speed": "1"
                }
            }
        ';

        anim_b.add_from_json( animation_json2 );
        anim_b.animation = 'climb';
        anim_b.play();

        // Belly

        var belly = new Visual({
            name: 'player_belly',
            geometry: Luxe.draw.ngon({
                x: 0, y: 0,
                sides: 20,
                solid: true,
                r: 10,
                color: new Color(1,1,1,1),
            }),
            pos: new Vector(16, 38),
            depth: 5.5,
            scale: new Vector(0.3, 1),
            parent: player,
        });
        belly.fixed_rate = 1/60;
        belly.add(new components.Belly());

        // Input

        player.add(new components.PlayerInput());
        player.add(new components.PlayerMovement());


        // Events

        Luxe.events.listen('game.over.*', function(_){
            anim_h.animation = 'dead';
            anim_h.play();

            anim_b.stop();
        });

        Luxe.events.listen('game.over.hunger', function(_){
            anim_b.animation = 'dead';
            anim_b.play();
        });
        Luxe.events.listen('game.over.belly_pop', function(_){
            anim_b.animation = 'pop';
            anim_b.play();

            // TODO, belly particles
            var part:Visual;
            var rnd_col:Float;
            for(i in 0...60){
                rnd_col = Math.random()*0.5 + 0.5;
                part = new Visual({
                    pos: player.pos.clone(),
                    geometry: Luxe.draw.ngon({
                        x: 0, y:0,
                        sides: 8,
                        solid: true,
                        r: Math.random()*2+1
                    }),
                    color: new Color(1,rnd_col,rnd_col,0.8),
                });
                part.add(new components.Particle());
                part.add(new components.DestroyOffScreen());
            }
        });


        player.events.listen('collider.hit', function(e:components.Collider.ColliderEvent)
        {
            if( StringTools.startsWith(e.other.name, 'item') ){
                anim_h.animation = 'chomp';
                anim_h.play();

                belly.events.fire('player.item.ate');
                Game.score += 10;

                e.other.destroy();
            }
            else if( StringTools.startsWith(e.other.name, 'obstacle') ){
                Game.game_over('obstacle');
            }

        });

        player.events.listen('jump.start', function(_){
            collider.enabled = false;
        });
        player.events.listen('jump.stop', function(_){
            collider.enabled = true;
        });

    }


    function init_events()
    {
        // Luxe.events.listen('game.over.hunger', function(_){

        // });

    }





    override function update(dt:Float)
    {

        if(Game.playing)
        {
            Game.distance += Game.speed * dt;
            Game.time += dt;
            Game.levelup_time -= dt;

            if(levelup_time <= 0){
                Game.levelup();
            }
        }

    }

}
