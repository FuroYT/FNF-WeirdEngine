package;

import flixel.FlxG;
import haxe.Json;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import openfl.utils.Assets as OpenFlAssets;


typedef SplashData =
{
	var offsetX:Int;
	var offsetY:Int;
	var fps:Int;
	var fpsVariation:Int;
	var ignoreColor:Bool;
	var size:Float;
	var antialiasing:Bool;
	var alpha:Float;
	var centerToStrum:Bool;
}

class NoteSplashData
{
	public static var curTexture:String = null;

	public static var offsetX:Int = 0;
	public static var offsetY:Int = 0;
	public static var fps:Int = 24;
	public static var fpsVariation:Int = 2;
	public static var ignoreColor:Bool = false;
	public static var size:Float = 1;
	public static var splashesAntialiasing:Bool = true;
	public static var splashesAlpha:Float = 0.6;
	public static var centerToStrum:Bool = false;

	public static function loadProperties(skin:String) {
		
		if (skin == null)
			skin = 'noteSplashes';

		if(curTexture == skin) {
			return;
		}
		curTexture = skin;

		var jsonCheck:String = 'images/' + skin +'.json';
		var jsonPath:String;
		var fileContent:String;

		#if MODS_ALLOWED
		if (FileSystem.exists(Paths.modFolders(jsonCheck)))
			jsonPath = Paths.modFolders(jsonCheck)
		else if (FileSystem.exists(Paths.getLibraryPath(jsonCheck, 'shared')))
			jsonPath = Paths.getLibraryPath(jsonCheck, 'shared')
		else if (FileSystem.exists(Paths.getLibraryPath(jsonCheck)))
			jsonPath = Paths.getLibraryPath(jsonCheck)
		#else
		if (OpenFlAssets.exists(Paths.getLibraryPath(jsonCheck, 'shared')))
			jsonPath = Paths.getLibraryPath(jsonCheck, 'shared')
		else if (OpenFlAssets.exists(Paths.getLibraryPath(jsonCheck)))
			jsonPath = Paths.getLibraryPath(jsonCheck)
		#end
		else
		{
			FlxG.log.advanced("No data for " + skin);

			switch (skin) {
				default:
					offsetX = 0;
					offsetY = 0;
					fps = 24;
					fpsVariation = 2;
					ignoreColor = false;
					size = 1;
					splashesAntialiasing = true;
					splashesAlpha = 0.6;
					centerToStrum = false;
			}
			return;
		}
		fileContent = Paths.getTextFromFile(jsonCheck);
		
		var splashJson:SplashData = Json.parse(fileContent);
		FlxG.log.advanced("Loading " + skin + " data");

		
		offsetX = splashJson.offsetX;
		offsetY = splashJson.offsetY;
		fps = splashJson.fps;
		fpsVariation = splashJson.fpsVariation;
		ignoreColor = splashJson.ignoreColor;
		size = splashJson.size;
		splashesAntialiasing = splashJson.antialiasing;
		splashesAlpha = splashJson.alpha;
		centerToStrum = splashJson.centerToStrum;
	}
}