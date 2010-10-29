package {
	
	import org.flixel.*;
	import game.GameState;
	
	[SWF(width="640", height="480", backgroundColor="#FFFFFF")]
	
	public class Timebomb extends FlxGame {
		public function Timebomb() {
			super(256,256, GameState, 2);
		}
	}
}