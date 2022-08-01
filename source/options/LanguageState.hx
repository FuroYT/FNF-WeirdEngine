package options;

#if desktop
import Discord.DiscordClient;
#end
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class LanguageState extends MusicBeatState
{
	private var grpLang:FlxTypedGroup<Alphabet>;

	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var firstLaunch:Bool = false;
	public static var noFlashing:Bool = false;
	
	var lang:Array<Array<String>> = [];
	private var iconArray:Array<AttachedSprite> = [];

	override function create()
	{
		var langsLoaded:Map<String, Bool> = new Map();
	
		#if MODS_ALLOWED
		var directories:Array<String> = [
			Paths.getPreloadPath('languages/'),
			Paths.mods('languages/'),
			Paths.mods(Paths.currentModDirectory + '/languages/')
		];
		for(mod in Paths.getGlobalMods())
			directories.push(Paths.mods(mod + '/languages/'));
		for (i in 0...directories.length)
		{
			var directory:String = directories[i];
			if (FileSystem.exists(directory))
			{
				for (file in FileSystem.readDirectory(directory))
				{
					var path = haxe.io.Path.join([directory, file]);
					if (!sys.FileSystem.isDirectory(path) && file.endsWith('.json'))
					{
						var langToCheck:String = file.substr(0, file.length - 5);
						if (!langsLoaded.exists(langToCheck))
						{
							var languagePath = Paths.getTextFromFile('languages/' + langToCheck + '.json');
					
							var languageJson = cast Json.parse(languagePath);
					
							var languageName = languageJson.languageName;

							lang.push([langToCheck, languageName]);
							langsLoaded.set(langToCheck, true);
						}
					}
				}
			}
		}
		#else
		{
			var fullText:String = Assets.getText(Paths.txt('langList'));
	
			var firstArray:Array<String> = fullText.split('\n');
	
			for (i in firstArray)
			{
				var languagePath = Paths.getTextFromFile('languages/' + i + '.json');
		
				var languageJson = cast Json.parse(languagePath);
		
				var languageName = languageJson.languageName;
				lang.push([i, languageName]);
			}
		#end
		#if desktop
		DiscordClient.changePresence("Language Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.themeImage('menuDesat'));
		bg.color = 0xFF009900;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpLang = new FlxTypedGroup<Alphabet>();
		add(grpLang);

		if (lang.length == 1) {
			lang.push(['null', 'Nothing in /mods']);
		}

		for (i in 0...lang.length)
		{
			var langText:Alphabet = new Alphabet(0, 0, lang[i][1], true, false);
			langText.isMenuItem = true;
			langText.y += (100 * (i - ((lang.length) / 2))) + 50;
			langText.x += 300;
			langText.ID = i;
			langText.xAdd = 200;
			grpLang.add(langText);

			var icon:AttachedSprite = new AttachedSprite();
			icon.frames = Paths.getThemedSparrowAtlas('languages/' + lang[i][0]);
			icon.animation.addByPrefix('idle', lang[i][0], 24);
			icon.animation.play('idle');
			icon.xAdd = -icon.width - 10;
			icon.sprTracker = langText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
		}

		var langMenu:String;
		if (firstLaunch)
			langMenu = 'Language';
		else
			langMenu = Language.language;

		var titleText:Alphabet = new Alphabet(0, 0, langMenu, true, false, 0, 0.6);
		titleText.x += 60;
		titleText.y += 40;
		titleText.alpha = 0.4;
		add(titleText);

		curSelected = 0;
		changeSelection();
		if (FlxG.save.data.flashing == null)
			noFlashing = true;

		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end

		super.create();
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if (firstLaunch) {
				FlxG.sound.play(Paths.themeSound('cancelMenu'));
			}
			else {
				FlxG.sound.play(Paths.themeSound('cancelMenu'));
				MusicBeatState.switchState(new options.OptionsState());
			}
		}

		if (controls.ACCEPT)
		{
			if (lang[curSelected][0] == 'null')
				FlxG.sound.play(Paths.themeSound('cancelMenu'));
			else
				changeLanguage();
		}
	}

	function changeLanguage() {ClientPrefs.language = lang[curSelected][0];
		ClientPrefs.saveSettings();
		Language.regenerateLang(lang[curSelected][0]);
		FlxG.sound.play(Paths.themeSound('confirmMenu'));

		grpLang.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					FlxFlicker.flicker(iconArray[spr.ID], 1, 0.06, false, false, null);
					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						#if android
						removeVirtualPad();
						#end
						if (firstLaunch) {
							firstLaunch = false;
							if (noFlashing){
								FlxG.save.data.flashing = null;
								FlxTransitionableState.skipNextTransIn = true;
								FlxTransitionableState.skipNextTransOut = true;
								MusicBeatState.switchState(new FlashingState());
							}
							else {
								MusicBeatState.switchState(new TitleState());
							}
						}
						else {
							MusicBeatState.switchState(new options.OptionsState());
						}
					});
				}
			});
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = lang.length - 1;
		if (curSelected >= lang.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpLang.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		FlxG.sound.play(Paths.themeSound('scrollMenu'));
	}
}
