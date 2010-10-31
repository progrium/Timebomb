package game
{
	import org.flixel.*;
	
	public class Bomb extends FlxSprite
	{
		[Embed (source = "../data/sprites/bomb.png")] private var bombSpritesheet:Class;
		
		public function Bomb(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(bombSpritesheet, true, true, 12, 12);
		}
	}
}