package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
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

class ControlsSubState extends MusicBeatSubstate
{
	private static var curSelected:Int = -1;
	private static var curAlt:Bool = false;

	private static var defaultKey:String = Language.defaultKey;

	private var bindLength:Int = 0;

	var optionShit:Array<Dynamic> = [
		[Language.notes],
		[''],
		['1 ' + Language.key],
		[Language.center, 'note_one1'],
		[''],
		['2 ' + Language.keys],
		[Language.left, 'note_two1'],
		[Language.right, 'note_two2'],
		[''],
		['3 ' + Language.keys],
		[Language.left, 'note_three1'],
		[Language.center, 'note_three2'],
		[Language.right, 'note_three3'],
		[''],
		['4 ' + Language.keys],
		[Language.left, 'note_left'],
		[Language.down, 'note_down'],
		[Language.up, 'note_up'],
		[Language.right, 'note_right'],
		[''],
		['5 ' + Language.keys],
		[Language.left, 'note_five1'],
		[Language.down, 'note_five2'],
		[Language.center, 'note_five3'],
		[Language.up, 'note_five4'],
		[Language.right, 'note_five5'],
		[''],
		['6 ' + Language.keys],
		[Language.left + ' 1', 'note_six1'],
		[Language.up, 'note_six2'],
		[Language.right + ' 1', 'note_six3'],
		[Language.left + ' 2', 'note_six4'],
		[Language.down, 'note_six5'],
		[Language.right + ' 2', 'note_six6'],
		[''],
		['7 ' + Language.keys],
		[Language.left + ' 1', 'note_seven1'],
		[Language.up, 'note_seven2'],
		[Language.right + ' 1', 'note_seven3'],
		[Language.center, 'note_seven4'],
		[Language.left + ' 2', 'note_seven5'],
		[Language.down, 'note_seven6'],
		[Language.right + ' 2', 'note_seven7'],
		[''],
		['8 ' + Language.keys],
		[Language.left + ' 1', 'note_eight1'],
		[Language.down + ' 1', 'note_eight2'],
		[Language.up + ' 1', 'note_eight3'],
		[Language.right + ' 1', 'note_eight4'],
		[Language.left + ' 2', 'note_eight5'],
		[Language.down + ' 2', 'note_eight6'],
		[Language.up + ' 2', 'note_eight7'],
		[Language.right + ' 2', 'note_eight8'],
		[''],
		['9 ' + Language.keys],
		[Language.left + ' 1', 'note_nine1'],
		[Language.down + ' 1', 'note_nine2'],
		[Language.up + ' 1', 'note_nine3'],
		[Language.right + ' 1', 'note_nine4'],
		[Language.center, 'note_nine5'],
		[Language.left + ' 2', 'note_nine6'],
		[Language.down + ' 2', 'note_nine7'],
		[Language.up + ' 2', 'note_nine8'],
		[Language.right + ' 2', 'note_nine9'],
		[''],
		[Language.figure1],
		[Language.figure2],
		[''],
		['10 ' + Language.keys],
		[Language.left + ' 1', 'note_ten1'],
		[Language.down + ' 1', 'note_ten2'],
		[Language.up + ' 1', 'note_ten3'],
		[Language.right + ' 1', 'note_ten4'],
		[Language.down + ' 1', 'note_ten5'],
		[Language.down + ' 2', 'note_ten6'],
		[Language.left + ' 2', 'note_ten7'],
		[Language.down + ' 2', 'note_ten8'],
		[Language.up + ' 2', 'note_ten9'],
		[Language.right + ' 2', 'note_ten10'],
		[''],
		['11 ' + Language.keys],
		[Language.left + ' 1', 'note_elev1'],
		[Language.down + ' 1', 'note_elev2'],
		[Language.up + ' 1', 'note_elev3'],
		[Language.right + ' 1', 'note_elev4'],
		[Language.down + ' 3', 'note_elev5'],
		[Language.center, 'note_elev6'],
		[Language.up + ' 3', 'note_elev7'],
		[Language.left + ' 2', 'note_elev8'],
		[Language.down + ' 2', 'note_elev9'],
		[Language.up + ' 2', 'note_elev10'],
		[Language.right + ' 2', 'note_elev11'],
		[''],
		[Language.ui],
		[Language.left, 'ui_left'],
		[Language.down, 'ui_down'],
		[Language.up, 'ui_up'],
		[Language.right, 'ui_right'],
		[''],
		[Language.reset, 'reset'],
		[Language.accept, 'accept'],
		[Language.back, 'back'],
		[Language.pause, 'pause'],
		[Language.fullscreen, 'fullscreen'],
		[''],
		[Language.volume],
		[Language.mute, 'volume_mute'],
		[Language.up, 'volume_up'],
		[Language.down, 'volume_down'],
		[''],
		[Language.debug],
		[Language.key + ' 1', 'debug_1'],
		[Language.key + ' 2', 'debug_2'],
		[Language.key + ' 3', 'debug_3']
	];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpInputs:Array<AttachedText> = [];
	private var grpInputsAlt:Array<AttachedText> = [];
	var rebindingKey:Bool = false;
	var nextAccept:Int = 5;

	public function new()
	{
		super();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.themeImage('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		defaultKey = Language.defaultKey;

		optionShit.push(['']);
		optionShit.push([defaultKey]);

		for (i in 0...optionShit.length)
		{
			var isCentered:Bool = false;
			var isDefaultKey:Bool = (optionShit[i][0] == defaultKey);
			if (unselectableCheck(i, true))
			{
				isCentered = true;
			}

			var optionText:Alphabet = new Alphabet(0, (10 * i), optionShit[i][0], (!isCentered || isDefaultKey), false);
			optionText.isMenuItem = true;
			if (isCentered)
			{
				optionText.screenCenter(X);
				optionText.forceX = optionText.x;
				optionText.yAdd = -55;
			}
			else
			{
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if (!isCentered)
			{
				addBindTexts(optionText, i);
				bindLength++;
				if (curSelected < 0)
					curSelected = i;
			}
		}
		changeSelection();

		canFullscreen = false;

		#if android
		addVirtualPad(FULL, A_B);
		#end
	}

	var leaving:Bool = false;
	var bindingTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (!rebindingKey)
		{
			if (controls.UI_UP_P)
			{
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P)
			{
				changeSelection(1);
			}
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
			{
				changeAlt();
			}

			if (controls.BACK)
			{
				ClientPrefs.reloadControls();
					#if android
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.resetState();
					#else
				close();
					#end
				FlxG.sound.play(Paths.themeSound('cancelMenu'));
			}

			if (controls.ACCEPT && nextAccept <= 0)
			{
				if (optionShit[curSelected][0] == defaultKey)
				{
					ClientPrefs.keyBinds = ClientPrefs.defaultKeys.copy();
					reloadKeys();
					changeSelection();
					FlxG.sound.play(Paths.themeSound('confirmMenu'));
				}
				else if (!unselectableCheck(curSelected))
				{
					bindingTime = 0;
					rebindingKey = true;
					if (curAlt)
					{
						grpInputsAlt[getInputTextNum()].alpha = 0;
					}
					else
					{
						grpInputs[getInputTextNum()].alpha = 0;
					}
					FlxG.sound.play(Paths.themeSound('scrollMenu'));
				}
			}
		}
		else
		{
			var keyPressed:Int = FlxG.keys.firstJustPressed();
			if (keyPressed > -1)
			{
				var keysArray:Array<FlxKey> = ClientPrefs.keyBinds.get(optionShit[curSelected][1]);
				keysArray[curAlt ? 1 : 0] = keyPressed;

				var opposite:Int = (curAlt ? 0 : 1);
				if (keysArray[opposite] == keysArray[1 - opposite])
				{
					keysArray[opposite] = NONE;
				}
				ClientPrefs.keyBinds.set(optionShit[curSelected][1], keysArray);

				reloadKeys();
				FlxG.sound.play(Paths.themeSound('confirmMenu'));
				rebindingKey = false;
			}

			bindingTime += elapsed;
			if (bindingTime > 5)
			{
				if (curAlt)
				{
					grpInputsAlt[curSelected].alpha = 1;
				}
				else
				{
					grpInputs[curSelected].alpha = 1;
				}
				FlxG.sound.play(Paths.themeSound('scrollMenu'));
				rebindingKey = false;
				bindingTime = 0;
			}
		}

		if (nextAccept > 0)
		{
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function getInputTextNum()
	{
		var num:Int = 0;
		for (i in 0...curSelected)
		{
			if (optionShit[i].length > 1)
			{
				num++;
			}
		}
		return num;
	}

	function changeSelection(change:Int = 0)
	{
		do
		{
			curSelected += change;
			if (curSelected < 0)
				curSelected = optionShit.length - 1;
			if (curSelected >= optionShit.length)
				curSelected = 0;
		}
		while (unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (i in 0...grpInputs.length)
		{
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length)
		{
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (!unselectableCheck(bullShit - 1))
			{
				item.alpha = 0.6;
				if (item.targetY == 0)
				{
					item.alpha = 1;
					if (curAlt)
					{
						for (i in 0...grpInputsAlt.length)
						{
							if (grpInputsAlt[i].sprTracker == item)
							{
								grpInputsAlt[i].alpha = 1;
								break;
							}
						}
					}
					else
					{
						for (i in 0...grpInputs.length)
						{
							if (grpInputs[i].sprTracker == item)
							{
								grpInputs[i].alpha = 1;
								break;
							}
						}
					}
				}
			}
		}
		FlxG.sound.play(Paths.themeSound('scrollMenu'));
	}

	function changeAlt()
	{
		curAlt = !curAlt;
		for (i in 0...grpInputs.length)
		{
			if (grpInputs[i].sprTracker == grpOptions.members[curSelected])
			{
				grpInputs[i].alpha = 0.6;
				if (!curAlt)
				{
					grpInputs[i].alpha = 1;
				}
				break;
			}
		}
		for (i in 0...grpInputsAlt.length)
		{
			if (grpInputsAlt[i].sprTracker == grpOptions.members[curSelected])
			{
				grpInputsAlt[i].alpha = 0.6;
				if (curAlt)
				{
					grpInputsAlt[i].alpha = 1;
				}
				break;
			}
		}
		FlxG.sound.play(Paths.themeSound('scrollMenu'));
	}

	private function unselectableCheck(num:Int, ?checkDefaultKey:Bool = false):Bool
	{
		if (optionShit[num][0] == defaultKey)
		{
			return checkDefaultKey;
		}
		return optionShit[num].length < 2 && optionShit[num][0] != defaultKey;
	}

	private function addBindTexts(optionText:Alphabet, num:Int)
	{
		var keys:Array<Dynamic> = ClientPrefs.keyBinds.get(optionShit[num][1]);
		var text1 = new AttachedText(InputFormatter.getKeyName(keys[0]), 400, -55);
		text1.setPosition(optionText.x + 400, optionText.y - 55);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);

		var text2 = new AttachedText(InputFormatter.getKeyName(keys[1]), 650, -55);
		text2.setPosition(optionText.x + 650, optionText.y - 55);
		text2.sprTracker = optionText;
		grpInputsAlt.push(text2);
		add(text2);
	}

	function reloadKeys()
	{
		while (grpInputs.length > 0)
		{
			var item:AttachedText = grpInputs[0];
			item.kill();
			grpInputs.remove(item);
			item.destroy();
		}
		while (grpInputsAlt.length > 0)
		{
			var item:AttachedText = grpInputsAlt[0];
			item.kill();
			grpInputsAlt.remove(item);
			item.destroy();
		}

		trace('Reloaded keys: ' + ClientPrefs.keyBinds);

		for (i in 0...grpOptions.length)
		{
			if (!unselectableCheck(i, true))
			{
				addBindTexts(grpOptions.members[i], i);
			}
		}

		var bullShit:Int = 0;
		for (i in 0...grpInputs.length)
		{
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length)
		{
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (!unselectableCheck(bullShit - 1))
			{
				item.alpha = 0.6;
				if (item.targetY == 0)
				{
					item.alpha = 1;
					if (curAlt)
					{
						for (i in 0...grpInputsAlt.length)
						{
							if (grpInputsAlt[i].sprTracker == item)
							{
								grpInputsAlt[i].alpha = 1;
							}
						}
					}
					else
					{
						for (i in 0...grpInputs.length)
						{
							if (grpInputs[i].sprTracker == item)
							{
								grpInputs[i].alpha = 1;
							}
						}
					}
				}
			}
		}
	}
}
