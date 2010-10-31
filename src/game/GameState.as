package game
{
	import flash.display.Sprite;
	
	import org.flixel.*;
	
	public class GameState extends FlxState 
	{
		public var map:FlxTilemap;
		public var players:FlxGroup = new FlxGroup;
		public var background:FlxSprite;
		public var focus:FlxObject = new FlxObject;
		
		[Embed (source = "../data/images/bg.png")] private var backgroundImage:Class;
		[Embed (source = "../data/tilesets/tiles.png")] private var tiles:Class;
		[Embed (source = "../data/maps/level.tmx", mimeType = "application/octet-stream")] private var mapData:Class;
		
		public function GameState()
		{
			
			var xml:XML = new XML( new mapData );
			var mapxml:XMLList = xml.*;
			
			
			map = new FlxTilemap();
			map.startingIndex = 1;
			map.collideIndex = 1;
			map.loadMap(
				mapxml.(@name=="PlayingField").data,
				tiles,
				16, 16
			);
			
			background = new FlxSprite(0, 0, backgroundImage);
			background.scrollFactor.x = 0.5;
			add(background);
			
			add(map);
			
			players.add(new Player(4*16,9*16,1));
			players.add(new Player(6*16,9*16,3));
			
			add(players);
		}
	
		override public function update(): void {
			FlxU.collide(players, map);
			FlxU.collide(players, players);
			
			super.update();
			
			
			focus.x = (players.members[0].x+players.members[1].x) / 2
			focus.y = (players.members[0].y+players.members[1].y) / 2
			
			map.follow();
			FlxG.follow(focus);
		}
	}
}