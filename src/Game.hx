import luxe.Color;
import luxe.Sprite;
import luxe.States;
import luxe.components.sprite.SpriteAnimation;
import luxe.utils.Random;
import luxe.Vector;
import luxe.Visual;


class Game extends State {

    static public var rnd:Random;


    public static var level:Int;
    public static var time:Float;
    public static var distance:Float;
    public static var speed:Float;
    public static var difficulty:Float;

    public static var playing:Bool = false;
    public static var gameover:Bool = false;



    var player:Sprite;

    var spawner:Spawner;

    public function new()
    {
        super({ name:'game' });
        
        Game.rnd = new Random(1);
        Game.level = 1;
        Game.time = 0;
        Game.distance = 0;
        Game.speed = 5;
    }



    override function onenter<T>(_:T) 
    {
        reset();

        create_player();

        init_events();

        spawner = new Spawner({name: 'spawner'});


        Luxe.timer.schedule(3, function(){
            playing = true;
            Luxe.events.fire('game.start');
        });


        Luxe.events.fire('game.init');

    }






    function reset()
    {
        Game.difficulty = 0;
        Game.time = 0;
        Game.distance = 0;

        Game.playing = false;
        Game.gameover = false;

        Luxe.events.fire('game.reset');
    }

    function game_over(reason:String)
    {
        Game.playing = false;
        Game.gameover = true;
        Luxe.events.fire('game.over.${reason}');
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
        player.fixed_rate = 1/30;


        var anim_h = new SpriteAnimation({ name:'anim' });
        player.add( anim_h );

        var animation_json = '
            {
                "idle" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": ["3-4"],
                    "pingpong":"false",
                    "loop": "true",
                    "speed": "4"
                },
                "chomp" : {
                    "frame_size":{ "x":"32", "y":"32" },
                    "frameset": [2,1,2],
                    "pingpong":"false",
                    "loop": "false",
                    "speed": "6"
                }
            }
        ';

        anim_h.add_from_json( animation_json );
        anim_h.animation = 'idle';
        anim_h.play();


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
        body.fixed_rate = 1/30;

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
                sides: 10,
                solid: true,
                r: 28/2,
                color: new Color(1,1,1,1),
            }),
            pos: new Vector(16, 34),
            depth: 5.5,
            scale: new Vector(0.3, 1),
            parent: player,
        });

    }


    function init_events()
    {

    }





    override function update(dt:Float)
    {

        // player.pos.x += 0.1;

    }

}
