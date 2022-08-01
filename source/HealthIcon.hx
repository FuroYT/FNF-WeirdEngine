package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef IconProperties = {
	var normal:Array<Dynamic>;
	var lose:Array<Dynamic>;
	var win:Array<Dynamic>;
}

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var isOldIcon:Bool = false;
	public var isPlayer:Bool = false;
	public var char:String = '';
	public var hasWinIcon:Bool = false;

	public var curPlayedAnim:String = null;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		animOffsets = new Map<String, Array<Dynamic>>();
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon

			curPlayedAnim = null;
				
			//[loop, offsetX, offsetY]
			var normalProperties:Array<Dynamic> = [true, 0, 0];
			var loseProperties:Array<Dynamic> = [true, 0, 0];
			var winProperties:Array<Dynamic> = [true, 0, 0];
				
			if (Paths.fileExists('images/' + name + '.json', TEXT)){
				#if MODS_ALLOWED
				var path:String = Paths.modFolders('images/' + name + '.json');
				if (!FileSystem.exists(path)) {
					path = Paths.getPreloadPath('images/' + name + '.json');
				}
				var rawJson = File.getContent(path);
				#else
				var path:String = Paths.getPreloadPath('images/' + name + '.json');
				var rawJson = Assets.getText(path);
				#end

				var json:IconProperties = cast Json.parse(rawJson);

				normalProperties = json.normal;
				loseProperties = json.lose;
				if (json.win != null)
				{
					winProperties = json.win;
					hasWinIcon = true;
				}
			}

			if (Paths.fileExists('images/' + name + '.xml', TEXT))
			{	
				frames = Paths.getSparrowAtlas(name);

				animation.addByPrefix('normal', 'normal', 24, normalProperties[0], isPlayer);
				animation.addByPrefix('lose', 'lose', 24, loseProperties[0], isPlayer);
				animation.addByPrefix('win', 'win', 24, winProperties[0], isPlayer);

				addOffset('normal', (width - 150) / 2 + normalProperties[1], (width - 150) / 2 + normalProperties[2]);
				addOffset('lose', (width - 150) / 2 + loseProperties[1], (width - 150) / 2 + loseProperties[2]);
				
				if (animation.getByName('win') == null)
				{
					hasWinIcon = false;
					animation.remove('win');
				}
				else
				{
					hasWinIcon = true;
					addOffset('win', (width - 150) / 2 + winProperties[1], (width - 150) / 2 + winProperties[2]);
				}
			}
			else if(hasWinIcon) {
				var file:Dynamic = Paths.image(name);
				loadGraphic(file); //Load stupidly first for getting the file size
				loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); //Then load it fr
	
				animation.add('normal', [0], 0, false, isPlayer);
				animation.add('lose', [1], 0, false, isPlayer);
				animation.add('win', [2], 0, false, isPlayer);
				addOffset('normal', (width - 150) / 2 + normalProperties[1], (width - 150) / 2 + normalProperties[2]);
				addOffset('lose', (width - 150) / 2 + loseProperties[1], (width - 150) / 2 + loseProperties[2]);
				addOffset('win', (width - 150) / 2 + winProperties[1], (width - 150) / 2 + winProperties[2]);
			}
			else {
				var file:Dynamic = Paths.image(name);
				loadGraphic(file); //Load stupidly first for getting the file size
				loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr
	
				animation.add('normal', [0], 0, false, isPlayer);
				animation.add('lose', [1], 0, false, isPlayer);
				animation.add('win', [0], 0, false, isPlayer);

				addOffset('normal', (width - 150) / 2 + normalProperties[1], (width - 150) / 2 + normalProperties[2]);
				addOffset('lose', (width - 150) / 2 + loseProperties[1], (width - 150) / 2 + loseProperties[2]);
				addOffset('win', (width - 150) / 2 + normalProperties[1], (width - 150) / 2 + normalProperties[2]);
			}
				
			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}

			updateHitbox();
			startPlay('normal');

			this.char = char;

		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		var daOffset = animOffsets.get(curPlayedAnim);
		if (animOffsets.exists(curPlayedAnim))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
	}
	
	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function getCharacter():String {
		return char;
	}

	public function startPlay(curPlayedAnim:String) {
		if(this.curPlayedAnim != curPlayedAnim) {
			animation.play(curPlayedAnim);
			this.curPlayedAnim = curPlayedAnim;
		}
	}
}