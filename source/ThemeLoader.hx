package;

import flixel.FlxG;
import flixel.util.FlxSort;
import Section.SwagSection;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef ThemeFile =
{
	var chance:Int;
	var antialiasing:Bool;
	var pixelTheme:Bool;
	var mainMenuChar:Array<String>;
	var platformPos:Array<Float>;
	var platformCharPos:Array<Float>;
	var offsetGF:String;
	var offsetGFpos:Array<Float>;
	var offsetBF:String;
	var offsetBFpos:Array<Float>;
	var offsetBPM:Float;
	//var fontName:String;
}

class ThemeLoader
{
	public static var gametheme:String = null;
	public static var themefolder:String = '';
	public static var themeMod:String = '';
	
	public static var antialiasing:Bool;
	public static var pixelTheme:Bool;
	public static var mainMenuChar:Array<String>;
	public static var platformPos:Array<Float>;
	public static var platformCharPos:Array<Float>;
	public static var offsetGF:String;
	public static var offsetGFpos:Array<Float>;
	public static var offsetBF:String;
	public static var offsetBFpos:Array<Float>;
	public static var offsetBPM:Float;
	//public static var fontName:String;

	inline static public function getThemeProperties(?theme:String = null)
	{
		var weekToLoad:Map<String, String> = new Map<String, String>();
		if (theme != null && true) 
		{
			if(Paths.fileExists('images/themes/' + theme + '/themeProperties.json', TEXT))
				gametheme = theme;
			else
			{
				gametheme = 'default';
				WeekData.loadTheFirstEnabledMod();
			}
		}
		else
		{
			gametheme = 'default';
			
			var themeChance:Map<String, Int> = new Map<String, Int>();
			var maxChance:Int = 0;
			
			var themes:Array<String> = [];

			var directories:Array<String> = [
				Paths.getPreloadPath('images/themes/')
			];
			#if MODS_ALLOWED
			directories.push(Paths.mods('images/themes/'));

			var disabledMods:Array<String> = [];
			var modsDirectories:Array<String> = Paths.getModDirectories();
			var modsListPath:String = 'modsList.txt';
			if(FileSystem.exists(modsListPath))
			{
				var stuff:Array<String> = CoolUtil.coolTextFile(modsListPath);
				for (i in 0...stuff.length)
				{
					var splitName:Array<String> = stuff[i].trim().split('|');
					if(splitName[1] == '0') // Disable mod
					{
						disabledMods.push(splitName[0]);
					}
				}
			}
			for (mod in modsDirectories)
			{
				var pathThing:String = haxe.io.Path.join([Paths.mods(), mod]) + '/';
				if (!disabledMods.contains(mod))
				{
					directories.push(Paths.mods(mod + '/images/themes/'));
					//trace('pushed Directory: ' + mod);
				}
			}
			
			for (i in 0...directories.length)
			{
				var directory:String = directories[i];
				if (FileSystem.exists(directory))
				{
					for (file in FileSystem.readDirectory(directory))
					{
						var path = haxe.io.Path.join([directory, file]);
						if (sys.FileSystem.isDirectory(path))
						{
							//var themeToCheck:String = file.substr(0, file.length);
							if (FileSystem.exists(path + '/themeProperties.json'))
							{
								themes.push(file);
								var modsdir:Array<String> = path.split('/');
								maxChance += Json.parse(File.getContent(path + '/themeProperties.json')).chance;
								themeChance[file] = maxChance;
								if(path.startsWith('mods') && path != Paths.mods('images/themes/' + file))
									weekToLoad[file] = modsdir[1];
							}
						}
					}
				}
			}
			#else
			/*for (i in 0...directories.lenght)
			{
				if (!OpenFlAssets.exists(directories[i] + '/themeProperties.json'))
					directories.remove(directories[i]);
				else
				{
					maxChance += Json.parse(Paths.getTextFromFile('images/themes/' + directories[i] + '/themeProperties.json')).chance;
					themeChance[directories[i]] = maxChance;
				}
			}*/
			#end

			var easterEggChance:Int = FlxG.random.int(0,maxChance + 70);
			//easterEggChance = 31; // used to test themes

			var hasTheme:Bool = false;

			for (dir in themes)
			{
				if (themeChance.get(dir) > easterEggChance && !hasTheme)
				{
					gametheme = dir;
					trace('loading a mod: ' + weekToLoad.exists(dir));
					hasTheme = true;
				}
			}
		}
		
		trace('theme: ' + gametheme);

		if (gametheme != 'default')
		{
			if (weekToLoad.exists(gametheme))
			{
				Paths.currentModDirectory = weekToLoad.get(gametheme);
			}
			else
			{
				WeekData.loadTheFirstEnabledMod();
			}
			themefolder = 'themes/' + gametheme + '/';
		}
		else
		{
			WeekData.loadTheFirstEnabledMod();
		}

		themeMod = Paths.currentModDirectory;
		
		var key:String = 'images/${themefolder}themeProperties.json';

		#if MODS_ALLOWED
		var path:String = Paths.modFolders(key);
		if (!FileSystem.exists(path))
		{
			path = Paths.getPreloadPath(key);
		}

		if (!FileSystem.exists(path))
		#else
		var path:String = Paths.getPreloadPath(key);
		if (!OpenFlAssets.exists(path))
		#end
		{
			path = Paths.getPreloadPath('images/themeProperties.json'); // If a character couldn't be found, change him to the default theme just to prevent a crash
		}

		#if sys
		var rawJson = File.getContent(path);
		#else
		var rawJson = OpenFlAssets.getText(path);
		#end

		var themeJSON:ThemeFile = cast Json.parse(rawJson);

		antialiasing = themeJSON.antialiasing;
		pixelTheme = themeJSON.pixelTheme;
		mainMenuChar = themeJSON.mainMenuChar;
		platformPos = themeJSON.platformPos;
		platformCharPos = themeJSON.platformCharPos;
		offsetGF = themeJSON.offsetGF;
		offsetGFpos = themeJSON.offsetGFpos;
		offsetBF = themeJSON.offsetBF;
		offsetBFpos = themeJSON.offsetBFpos;
		offsetBPM = themeJSON.offsetBPM;
		//fontName = themeJSON.fontName;
	}
}
