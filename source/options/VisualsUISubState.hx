package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
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

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.visualsUI;
		rpcTitle = 'Visuals & UI Settings Menu'; // for Discord Rich Presence

		var option:Option = new Option(Language.noteSplashes, Language.noteSplashesDesc, 'noteSplashes', 'bool', true);
		addOption(option);

		var option:Option = new Option(Language.hideHUD, Language.hideHUDDesc, 'hideHud', 'bool', false);
		addOption(option);

		//Without translation
		var option:Option = new Option(Language.timeBar, Language.timeBarDesc, 'timeBarType', 'string', "Time Left",
		["Time Left", "Time Elapsed", "Song Name", "Disabled"]);
		addOption(option);

		//With translation (desactivated for fix)
		/*var option:Option = new Option(Language.timeBar, Language.timeBarDesc, 'timeBarType', 'string', Language.timeBarOptions[0],
			Language.timeBarOptions);
		addOption(option);*/

		var option:Option = new Option(Language.flashingLights, Language.flashingLightsDesc, 'flashing', 'bool', true);
		addOption(option);

		var option:Option = new Option(Language.cameraZoom, Language.cameraZoomDesc, 'camZooms', 'bool', true);
		addOption(option);

		var option:Option = new Option(Language.textZoom, Language.textZoomDesc, 'scoreZoom', 'bool', true);
		addOption(option);

		var option:Option = new Option(Language.HPbarAlpha, Language.HPbarAlphaDesc, 'healthBarAlpha', 'percent', 1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		#if !mobile
		var option:Option = new Option(Language.showFPS, Language.showFPSDesc, 'showFPS', 'bool', true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end

		var option:Option = new Option(Language.pauseMusic, Language.pauseMusicDesc, 'pauseMusic', 'string', 'Breakfast', ['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;

		super();
	}

	var changedMusic:Bool = false;

	function onChangePauseMusic()
	{
		if (ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.themeMusic(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if (changedMusic)
			FlxG.sound.playMusic(Paths.themeMusic('freakyMenu'));
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if (Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end
}
