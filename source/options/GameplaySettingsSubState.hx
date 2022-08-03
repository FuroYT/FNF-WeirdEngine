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

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.gameplay;
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence
		
		/*
		var option:Option = new Option('Controller Mode',
			'Check this if you want to play with\na controller instead of using your Keyboard.',
			'controllerMode',
			'bool',
			false);
		addOption(option);*/

		//this is a WIP
		/*var option:Option = new Option('Control Mode:',
			'What type of control do you want to use?',
			'controlMode',
			'string',
			#if desktop 'keyboard' #elseif mobile 'touch' #else 'controller' #end,
			["keyboard", "touch", "controller"]);
		addOption(option);*/
		
		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option(Language.downScroll, //Name
			Language.downScrollDesc, //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option(Language.middleScroll,
			Language.middleScrollDesc,
			'middleScroll',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option(Language.oppNotes,
			Language.oppNotesDesc,
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option(Language.ghostTapping,
			Language.ghostTappingDesc,
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option(Language.noAntimash,	//even tho only one person asked, it here
			Language.noAntimashDesc,
			'noAntimash',
			'bool',
			false);
		addOption(option); //now shut up before i put you in my basement
		// PD: i dont have a basement

		var option:Option = new Option(Language.soundEffectVolume, Language.soundEffectVolumeDesc, 'soundEffectVolume', 'percent', 1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option(Language.noReset,
			Language.noResetDesc,
			'noReset',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option(Language.hitsoundVolume,
			Language.hitsoundVolumeDesc,
			'hitsoundVolume',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;

		var option:Option = new Option(Language.ratingOffset,
			Language.ratingOffsetDesc,
			'ratingOffset',
			'int',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option(
			StringTools.replace(Language.hitWindow, '@[rating]', 'Sick!'),
			StringTools.replace(Language.hitWindowDesc, '@[rating]', 'Sick!'),
			'sickWindow',
			'int',
			45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option(
			StringTools.replace(Language.hitWindow, '@[rating]', 'Good'),
			StringTools.replace(Language.hitWindowDesc, '@[rating]', 'Good'),
			'goodWindow',
			'int',
			90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option(
			StringTools.replace(Language.hitWindow, '@[rating]', 'Bad'),
			StringTools.replace(Language.hitWindowDesc, '@[rating]', 'Bad'),
			'badWindow',
			'int',
			135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option(Language.safeFrames,
			Language.safeFramesDesc,
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}
}