package;

import animateatlas.AtlasFrameMaker;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import openfl.geom.Rectangle;
import flixel.math.FlxRect;
import haxe.xml.Access;
import openfl.system.System;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
import flixel.FlxSprite;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import haxe.Json;

import flash.media.Sound;

using StringTools;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	#if MODS_ALLOWED
	public static var ignoreModFolders:Array<String> = [
		'characters', 'custom_events', 'custom_notetypes', 'data', 'languages', 'songs', 'music', 'sounds', 'shaders', 'videos', 'images', 'stages', 'weeks', 'fonts',
		'scripts', 'achievements'
	];
	#end

	public static function excludeAsset(key:String)
	{
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> = [
		'assets/music/freakyMenu.$SOUND_EXT',
		'assets/shared/music/breakfast.$SOUND_EXT',
		'assets/shared/music/tea-time.$SOUND_EXT',
	];

	/// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory()
	{
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys())
		{
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key))
			{
				// get rid of it
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null)
				{
					openfl.Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					currentTrackedAssets.remove(key);
				}
			}
		}
		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// define the locally tracked assets
	public static var localTrackedAssets:Array<String> = [];

	public static function clearStoredMemory(?cleanUnused:Bool = false)
	{
		// clear anything not in the tracked assets list
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key))
			{
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		// clear all sounds that are cached
		for (key in currentTrackedSounds.keys())
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null)
			{
				// trace('test: ' + dumpExclusions, key);
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		openfl.Assets.cache.clear("songs");
	}

	static public var currentModDirectory:String = '';
	static public var currentModSelectedDirectory:String = '';
	static public var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if (currentLevel != 'shared')
			{
				levelPath = getLibraryPathForce(file, currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		var returnPath = '$library:assets/$library/$file';
		return returnPath;
	}

	inline public static function getPreloadPath(file:String = '')
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function imageTxt(key:String, ?library:String)
	{
		return getPath('images/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function imageJson(key:String, ?library:String)
	{
		return getPath('images/$key.json', TEXT, library);
	}

	inline static public function shaderFragment(key:String, ?library:String)
	{
		return getPath('shaders/$key.frag', TEXT, library);
	}

	inline static public function shaderVertex(key:String, ?library:String)
	{
		return getPath('shaders/$key.vert', TEXT, library);
	}

	inline static public function lua(key:String, ?library:String)
	{
		return getPath('$key.lua', TEXT, library);
	}

	static public function video(key:String)
	{
		#if MODS_ALLOWED
		var file:String = modsVideo(key);
		if (FileSystem.exists(file))
		{
			return file;
		}
		#end
		return 'assets/videos/$key.$VIDEO_EXT';
	}

	static public function sound(key:String, ?library:String):Sound
	{
		var sound:Sound = returnSound('sounds', key, library);
		return sound;
	}

	static public function langSound(key:String, ?library:String):Sound
	{
		var sound:Sound = returnSound('sounds', key + '-' + ClientPrefs.language, library);
		#if MODS_ALLOWED
		if (!(FileSystem.exists(modsSounds('sounds', key + '-' + ClientPrefs.language)) || FileSystem.exists('assets/sounds/' + key + '-' + ClientPrefs.language + '.$SOUND_EXT') || FileSystem.exists('assets/shared/sounds/' + key + '-' + ClientPrefs.language + '.$SOUND_EXT'))) {
			sound = returnSound('sounds', key, library);
		}
		return sound;
		#end
		if (!OpenFlAssets.exists(getPath('sounds/' + key + '-' + ClientPrefs.language + '.$SOUND_EXT', SOUND, library)))
			return returnSound('sounds', key, library);
		return sound;
	}

	static public function themeSound(key:String, ?library:String):Sound
	{
		var sound:Sound = returnSound('sounds', ThemeLoader.themefolder + key, library);
		#if MODS_ALLOWED
		if (!(FileSystem.exists(modsSounds('sounds', ThemeLoader.themefolder + key)) || FileSystem.exists('assets/sounds/' + ThemeLoader.themefolder + '$key.$SOUND_EXT') || FileSystem.exists('assets/shared/sounds/' + ThemeLoader.themefolder + '$key.$SOUND_EXT'))) {
			sound = returnSound('sounds', key, library);
		}
		return sound;
		#end
		if (!OpenFlAssets.exists(getPath('sounds/${ThemeLoader.themefolder}/$key.$SOUND_EXT', SOUND, library)))
			return returnSound('sounds', key, library);
		return sound;
	}

	/*
	static public function stageSound(key:String, ?library:String):Sound
	{
		var sound:Sound = returnSound('sounds', PlayState.stageThemeFolder + key, library);
		#if MODS_ALLOWED
		if (!(FileSystem.exists(modsSounds('sounds', PlayState.stageThemeFolder + key)) || FileSystem.exists('assets/sounds/' + PlayState.stageThemeFolder + '$key.$SOUND_EXT') || FileSystem.exists('assets/shared/sounds/' + PlayState.stageThemeFolder + '$key.$SOUND_EXT'))) {
			sound = returnSound('sounds', key, library);
		}
		return sound;
		#end
		if (!OpenFlAssets.exists(getPath('sounds/${PlayState.stageThemeFolder}/$key.$SOUND_EXT', SOUND, library)))
			return returnSound('sounds', key, library);
		return sound;

	}*/

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String):Sound
	{
		var file:Sound = returnSound('music', key, library);
		return file;
	}

	inline static public function themeMusic(key:String, ?library:String):Sound
	{
		var sound:Sound = returnSound('music', ThemeLoader.themefolder + key, library);
		#if MODS_ALLOWED
		if (!(FileSystem.exists(modsSounds('music', ThemeLoader.themefolder + key)) || FileSystem.exists('assets/music/' + ThemeLoader.themefolder + '$key.$SOUND_EXT') || FileSystem.exists('assets/shared/music/' + ThemeLoader.themefolder + '$key.$SOUND_EXT'))) {
			sound = returnSound('music', key, library);
		}
		return sound;
		#else
		return returnSound('music', key, library);
		#end
	}

	/*
	inline static public function stageMusic(key:String, ?library:String):Sound
	{
		var file:Sound = returnSound('music', PlayState.stageThemeFolder + key, library);
		if (!(FileSystem.exists(modsSounds('music', PlayState.stageThemeFolder + key)) || FileSystem.exists('assets/music/' + PlayState.stageThemeFolder + '$key.$SOUND_EXT') || FileSystem.exists('assets/shared/music/' + PlayState.stageThemeFolder + '$key.$SOUND_EXT')))
			file = returnSound('music', key, library);
		FlxG.log.advanced("Default theme music");
		return file;
	}*/

	inline static public function checkOppVoices(song:String):Any
	{
		var songKey:String = '${formatToSongPath(song)}/OppVoices';
		if (fileExists('songs/$songKey.$SOUND_EXT', SOUND) || fileExists('$songKey.$SOUND_EXT', SOUND, true, 'songs'))
		{
			FlxG.log.advanced("OppVoices loaded");
			return true;
		}
		FlxG.log.advanced("There is no OppVoices");
		return false;
	}

	inline static public function oppVoices(song:String):Any
	{
		var songKey:String = '${formatToSongPath(song)}/OppVoices';
		var file:Sound = returnSound('songs', songKey);
		return file;
	}

	inline static public function voices(song:String, ?char:String = ''):Any
	{
		var songKey:String = '${formatToSongPath(song)}/Voices-${char}';
		if (fileExists('songs/$songKey.$SOUND_EXT', SOUND) || fileExists('$songKey.$SOUND_EXT', SOUND, true, 'songs'))
		{
			FlxG.log.advanced(char + " Voices loaded");
		}
		else
		{
			FlxG.log.advanced("Default Voices loaded");
			songKey = '${formatToSongPath(song)}/Voices';
		}
		return returnSound('songs', songKey);
	}

	inline static public function inst(song:String):Any
	{
		var songKey:String = '${formatToSongPath(song)}/Inst';
		var inst = returnSound('songs', songKey);
		return inst;
	}

	inline static public function image(key:String, ?library:String):FlxGraphic
	{
		// streamlined the assets process more
		var returnAsset:FlxGraphic = returnGraphic(key, library);
		return returnAsset;
	}

	inline static public function themeImage(key:String, ?library:String):FlxGraphic
	{
		// streamlined the assets process more
		var returnAsset:FlxGraphic;
		if (!FileSystem.exists(modsImages(ThemeLoader.themefolder + key)) && !FileSystem.exists('assets/images/' + ThemeLoader.themefolder + '$key.png'))
			returnAsset = returnGraphic(key, library);
		else
			returnAsset = returnGraphic(ThemeLoader.themefolder + key, library);
		return returnAsset;
	}

	static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
	{
		#if sys
		#if MODS_ALLOWED
		if (!ignoreMods && FileSystem.exists(modFolders(key)))
			return File.getContent(modFolders(key));
		#end

		if (FileSystem.exists(getPreloadPath(key)))
			return File.getContent(getPreloadPath(key));

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(key, currentLevel);
				if (FileSystem.exists(levelPath))
					return File.getContent(levelPath);
			}

			levelPath = getLibraryPathForce(key, 'shared');
			if (FileSystem.exists(levelPath))
				return File.getContent(levelPath);
		}
		#end
		return Assets.getText(getPath(key, TEXT));
	}

	inline static public function font(key:String)
	{
		#if MODS_ALLOWED
		var file:String = modsFont(key);
		if (FileSystem.exists(file))
		{
			return file;
		}
		#end
		return 'assets/fonts/$key';
	}

	inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String = null)
	{
		#if MODS_ALLOWED
		if (FileSystem.exists(modFolders(key)) && !ignoreMods)
		{
			return true;
		}
		#end

		if (OpenFlAssets.exists(getPath(key, type, library)))
		{
			return true;
		}
		return false;
	}

	inline static public function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames
	{
		#if MODS_ALLOWED
		var imageLoaded:FlxGraphic = returnGraphic(key);
		var xmlExists:Bool = false;
		if (FileSystem.exists(modsXml(key)))
		{
			xmlExists = true;
		}

		return FlxAtlasFrames.fromSparrow((imageLoaded != null ? imageLoaded : image(key, library)),
			(xmlExists ? File.getContent(modsXml(key)) : file('images/$key.xml', library)));
		#else
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
		#end
	}

	inline static public function getThemedSparrowAtlas(key:String, ?library:String):FlxAtlasFrames
	{
		#if MODS_ALLOWED
		var fileCheck = ThemeLoader.themefolder + key;

		if (!FileSystem.exists(modsImages(fileCheck)) && !FileSystem.exists('assets/images/' + ThemeLoader.themefolder + '$key.png'))
			fileCheck = key;
		
		var imageLoaded:FlxGraphic = returnGraphic(fileCheck);
		var xmlExists:Bool = false;

		if (FileSystem.exists(modsXml(fileCheck)))
		{
			xmlExists = true;
		}

		return FlxAtlasFrames.fromSparrow((imageLoaded != null ? imageLoaded : image(fileCheck, library)),
			(xmlExists ? File.getContent(modsXml(fileCheck)) : file('images/$fileCheck.xml', library)));
		#else
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
		#end
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		#if MODS_ALLOWED
		var imageLoaded:FlxGraphic = returnGraphic(key);
		var txtExists:Bool = false;
		if (FileSystem.exists(modsTxt(key)))
		{
			txtExists = true;
		}

		return FlxAtlasFrames.fromSpriteSheetPacker((imageLoaded != null ? imageLoaded : image(key, library)),
			(txtExists ? File.getContent(modsTxt(key)) : file('images/$key.txt', library)));
		#else
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
		#end
	}

	inline static public function formatToSongPath(path:String)
	{
		return path.toLowerCase().replace(' ', '-');
	}

	// completely rewritten asset loading? fuck!
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

	public static function returnGraphic(key:String, ?library:String)
	{
		#if MODS_ALLOWED
		var modKey:String = modsImages(key);
		if (FileSystem.exists(modKey))
		{
			if (!currentTrackedAssets.exists(modKey))
			{
				var newBitmap:BitmapData = BitmapData.fromFile(modKey);
				var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(newBitmap, false, modKey);
				newGraphic.persist = true;
				currentTrackedAssets.set(modKey, newGraphic);
			}
			localTrackedAssets.push(modKey);
			return currentTrackedAssets.get(modKey);
		}
		#end

		var path = getPath('images/$key.png', IMAGE, library);
		//trace(path);
		if (OpenFlAssets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(path))
			{
				var newGraphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
				newGraphic.persist = true;
				currentTrackedAssets.set(path, newGraphic);
			}
			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}
		trace('oh no its returning null NOOOO');
		return null;
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];

	public static function returnSound(path:String, key:String, ?library:String)
	{
		#if MODS_ALLOWED
		var file:String = modsSounds(path, key);
		if (FileSystem.exists(file))
		{
			if (!currentTrackedSounds.exists(file))
			{
				currentTrackedSounds.set(file, Sound.fromFile(file));
			}
			localTrackedAssets.push(key);
			return currentTrackedSounds.get(file);
		}
		#end
		// I hate this so god damn much
		var gottenPath:String = getPath('$path/$key.$SOUND_EXT', SOUND, library);
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		// trace(gottenPath);
		if (!currentTrackedSounds.exists(gottenPath))
			#if MODS_ALLOWED
			currentTrackedSounds.set(gottenPath, Sound.fromFile(gottenPath));
			#else
			{
				var folder:String = '';
				if(path == 'songs') folder = 'songs:';
	
				currentTrackedSounds.set(gottenPath, OpenFlAssets.getSound(getPath(folder + '$path/$key.$SOUND_EXT', SOUND, library)));
			}
			#end
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}

	#if MODS_ALLOWED
	inline static public function mods(key:String = '')
	{
		return 'mods/' + key;
	}

	inline static public function modsFont(key:String)
	{
		return modFolders('fonts/' + key);
	}

	inline static public function modsJson(key:String)
	{
		return modFolders('data/' + key + '.json');
	}

	inline static public function modsDataTxt(key:String)
	{
		return modFolders('data/' + key + '.txt');
	}

	inline static public function modsVideo(key:String)
	{
		return modFolders('videos/' + key + '.' + VIDEO_EXT);
	}

	inline static public function modsSounds(path:String, key:String)
	{
		return modFolders(path + '/' + key + '.' + SOUND_EXT);
	}

	inline static public function modsImages(key:String)
	{
		return modFolders('images/' + key + '.png');
	}

	inline static public function modsXml(key:String)
	{
		return modFolders('images/' + key + '.xml');
	}

	inline static public function modsTxt(key:String)
	{
		return modFolders('images/' + key + '.txt');
	}

	inline static public function modsImageJson(key:String)
	{
		return modFolders('images/' + key + '.json');
	}

	/* Goes unused for now

	inline static public function modsShaderFragment(key:String, ?library:String)
	{
		return modFolders('shaders/'+key+'.frag');
	}
	inline static public function modsShaderVertex(key:String, ?library:String)
	{
		return modFolders('shaders/'+key+'.vert');
	}
	inline static public function modsAchievements(key:String) {
		return modFolders('achievements/' + key + '.json');
	}*/

	static public function modFolders(key:String)
	{
		if (currentModDirectory != null && currentModDirectory.length > 0)
		{
			var fileToCheck:String = mods(currentModDirectory + '/' + key);
			if (FileSystem.exists(fileToCheck))
			{
				return fileToCheck;
			}
		}

		for(mod in getGlobalMods()){
			var fileToCheck:String = mods(mod + '/' + key);
			if(FileSystem.exists(fileToCheck))
				return fileToCheck;

		}
		return 'mods/' + key;
	}
	
	public static var globalMods:Array<String> = [];

	static public function getGlobalMods()
		return globalMods;

	static public function pushGlobalMods() // prob a better way to do this but idc
	{
		globalMods = [];
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var list:Array<String> = CoolUtil.coolTextFile(path);
			for (i in list)
			{
				var dat = i.split("|");
				if (dat[1] == "1")
				{
					var folder = dat[0];
					var path = Paths.mods(folder + '/pack.json');
					if(FileSystem.exists(path)) {
						try{
							var rawJson:String = File.getContent(path);
							if(rawJson != null && rawJson.length > 0) {
								var stuff:Dynamic = Json.parse(rawJson);
								var global:Bool = Reflect.getProperty(stuff, "runsGlobally");
								if(global)globalMods.push(dat[0]);
							}
						} catch(e:Dynamic){
							trace(e);
						}
					}
				}
			}
		}
		return globalMods;
	}

	static public function getModDirectories():Array<String>
	{
		var list:Array<String> = [];
		var modsFolder:String = mods();
		if (FileSystem.exists(modsFolder))
		{
			for (folder in FileSystem.readDirectory(modsFolder))
			{
				var path = haxe.io.Path.join([modsFolder, folder]);
				if (sys.FileSystem.isDirectory(path) && !ignoreModFolders.contains(folder) && !list.contains(folder))
				{
					list.push(folder);
				}
			}
		}
		return list;
	}
	#end

	public static var userDesktop = Sys.getEnv(if (Sys.systemName() == "Windows") "UserProfile" else "HOME") + "\\Desktop";
}
