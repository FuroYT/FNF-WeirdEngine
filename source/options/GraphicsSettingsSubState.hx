package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import ClientPrefs;
import openfl.Lib;

using StringTools;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	//var outpusDevices:Array<String>;
	public function new()
	{
		title = Language.graphics;
		rpcTitle = 'Graphics Settings Menu'; // for Discord Rich Presence

		//outpusDevices = flash.media.AudioDeviceManager.deviceNames;

		// I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option(Language.lowQuality, // Name
			Language.lowQualityDesc, // Description
			'lowQuality', // Save data variable name
			'bool', // Variable type
			false); // Default value
		addOption(option);

		var option:Option = new Option(Language.globalAntialiasing, Language.globalAntialiasingDesc, 'globalAntialiasing', 'bool', true);
		option.showBoyfriend = true;
		option.onChange = onChangeAntiAliasing; // Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);

		#if !html5 // Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		var option:Option = new Option(Language.framerate, Language.framerateDesc, 'framerate', 'fps',  #if desktop 'V-Sync' #else 60 #end);
		addOption(option);

		option.minValue = 60;
		option.maxValue = 240;
		option.changeValue = 1;
		if (ClientPrefs.framerate == 'V-Sync'){
			option.displayFormat = '%v';
		}
		else
			option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		#if desktop
		var option:Option = new Option(Language.onUnfocuPause, Language.onUnfocuPauseDesc, 'unfocuPause', 'bool', true);
		option.onChange = onChangeFocus; // Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);

		/*
		var option:Option = new Option('audioOutput', 'audioOutputDesc', 'music', 'string', outpusDevices[0], outpusDevices);
		addOption(option);
		option.onChange = onChangeAudioOutput;*/
		#end

		/*
			var option:Option = new Option('Persistent Cached Data',
				'If checked, images loaded will stay in memory\nuntil the game is closed, this increases memory usage,\nbut basically makes reloading times instant.',
				'imagesPersist',
				'bool',
				false);

			option.onChange = onChangePersistentData; //Persistent Cached Data changes FlxGraphic.defaultPersist
			addOption(option);
		 */

		super();
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; // Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; // Don't judge me ok
			if (sprite != null && (sprite is FlxSprite) && !(sprite is FlxText))
			{
				sprite.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	}

	function onChangeFramerate()
	{
		if (ClientPrefs.framerate == 'V-sync'){
			ClientPrefs.curFramerate = ClientPrefs.vSyncFPS;
		}
		else 
			ClientPrefs.curFramerate = Math.round(ClientPrefs.framerate);

		if (ClientPrefs.curFramerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.curFramerate;
			FlxG.drawFramerate = ClientPrefs.curFramerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.curFramerate;
			FlxG.updateFramerate = ClientPrefs.curFramerate;
		}
	}

	function onChangeFocus()
	{
		#if desktop
		FlxG.autoPause = ClientPrefs.unfocuPause;
		#end
	}

	function onChangeAudioOutput()
	{
		trace('output changed');
	}
}