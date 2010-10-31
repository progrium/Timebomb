package game {
    
    import org.flixel.*;
    
    public class Player extends FlxSprite {
        [Embed (source = "../data/sprites/dude_bottom.png")] private var legsSpritesheet:Class;
		[Embed (source = "../data/sprites/dude_top.png")] private var torsoSpritesheet:Class;
        
        public const MOVE_SPEED:int = 200;
        public const RUN_ACCEL:int = 600;
        public const RUN_DRAG:int = 750;
        
        public const GRAVITY:int = 900;
        public const JUMP_FORCE:int = 1100;
        
        public const JUMP_HOLD_FORCE:int = 150;
        public const MAX_VELOCITY:int = 320;
        
        public const IMPACT_MULTIPLIER:Number = 2; 
        
		public var parts:FlxGroup = new FlxGroup;
		
		public var torso:FlxSprite;
		public var torsoOffset:FlxPoint = new FlxPoint(-5,0);
		
		public var legs:FlxSprite;
		public var legsOffset:FlxPoint = new FlxPoint(-5, 38); 
		
		public var bomb:FlxSprite;
		public var bombOffset:FlxPoint = new FlxPoint(20,16);
		
        public var playerIndex:int; 
        
        public var controls:Object = {
            1:{left:'LEFT', right:'RIGHT', up:'UP', bomb:'SHIFT'},
            3:{left:'A', right:'D', up:'W', bomb:'E'}
        };
        
        public function Player(X:Number=0, Y:Number=0, P:Number=1) {
            super(X, Y);
			width = 22;
			height = 64;
			
			legs = new FlxSprite(X+legsOffset.x, Y+legsOffset.y);
			legs.loadGraphic( 
				legsSpritesheet, 
				true, true,
				32, 26
			);
			parts.add(legs);
            
			torso = new FlxSprite(X+torsoOffset.x, Y+torsoOffset.y);
			torso.loadGraphic( 
				torsoSpritesheet, 
				true, true,
				32, 42
			);
			parts.add(torso);
			
			
            playerIndex = P;
            
            //var f1:Number = {1:0, 2:2, 3:4, 4:6}[P];
            //var f2:Number = (f1+1);
            
            legs.addAnimation("idle", [0]);
			legs.addAnimation("run", [0, 1], 8);
			legs.addAnimation("jump", [1]);
			
			torso.addAnimation("idle", [0]);
			torso.addAnimation("run", [0, 1], 8);
			torso.addAnimation("jump", [1]);
            
			
            maxVelocity.y = MAX_VELOCITY;
            maxVelocity.x = MAX_VELOCITY;
            acceleration.y = GRAVITY;
        }
        
		public function spawnBomb():void {
			bomb = new Bomb(x+bombOffset.x,y+bombOffset.y);
			parts.add(bomb);
		}
		
        public function die(): void {
            this.kill();
			parts.kill();
        }
        
        public function doInput(p:Number): void {
            if (FlxG.keys.justPressed(controls[p].bomb) && bomb == null) {
				spawnBomb();
			}            
			
			
            if( FlxG.keys.pressed(controls[p].left) ) {
                acceleration.x = -RUN_ACCEL;
                drag.x = 0;
            } else if ( FlxG.keys.pressed(controls[p].right) ) {
                acceleration.x = RUN_ACCEL;
                drag.x = 0;
            } else {
                acceleration.x = 0;
                drag.x = RUN_DRAG;
            }
            
            // If you're moving too quickly, stop accelerating
            if (velocity.x <= - MOVE_SPEED) {
                acceleration.x = Math.max(0, acceleration.x);
            } else if (velocity.x >= MOVE_SPEED) {
                acceleration.x = Math.min(0, acceleration.x);
            }
            
            // Jump
            if( FlxG.keys.justPressed(controls[p].up) && onFloor ) {
                velocity.y = - JUMP_FORCE;
            }
            
            // If you hold jump in the air, keep pushing him up a bit to have mario-style jumping
            if( FlxG.keys.pressed(controls[p].up) && velocity.y < 0 ) {
                velocity.y -= JUMP_HOLD_FORCE * FlxG.elapsed;
            }
            
            if( velocity.y > MAX_VELOCITY ) {
                velocity.y = MAX_VELOCITY;
            } else if( velocity.y < -MAX_VELOCITY ) {
                velocity.y = -MAX_VELOCITY;
            } 
            
            if( velocity.x > MAX_VELOCITY ) {
                velocity.x = MAX_VELOCITY;
            } else if( velocity.x < -MAX_VELOCITY ) {
                velocity.x = -MAX_VELOCITY;
            } 
        }
		
		override public function play(AnimName:String, Force:Boolean=false):void {
			legs.play(AnimName, Force);
			torso.play(AnimName, Force);
		} 
        
        public function doAnimation(p:Number): void {
            if( FlxG.keys.pressed(controls[p].left) ) {
                torso.facing = LEFT;
				legs.facing = LEFT;
				bombOffset.x = -4;
            } else if( FlxG.keys.pressed(controls[p].right) ) {
                torso.facing = RIGHT;
				legs.facing = RIGHT;
				bombOffset.x = 16;
            }
            
            if (onFloor) {
                
                if( FlxG.keys.pressed(controls[p].left) || FlxG.keys.pressed(controls[p].right) ) {
                    play("run");
                } else {
					play("idle");
                }
                
            } else {
				play("jump");
            }
        }
        
        override public function update(): void {
            doInput(playerIndex);
            doAnimation(playerIndex);
			
			torso.x = x+torsoOffset.x;
			torso.y = y+torsoOffset.y;
			legs.x = x+legsOffset.x;
			legs.y = y+legsOffset.y;
			
			if (bomb) {
				bomb.x = x+bombOffset.x;
				bomb.y = y+bombOffset.y;
			}
			
            super.update();
			parts.update();
        }
		
		override public function render():void {
			//super.render();
			parts.render();
		}
        
        override public function preCollide(Contact:FlxObject):void {
            
            
            
            super.preCollide(Contact);
        }
    }
}