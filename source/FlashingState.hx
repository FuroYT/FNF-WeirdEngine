package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			Language.flashingInfo,
			32);
		warnText.setFormat(Paths.font("NotoSans-Bold.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
		switch(ClientPrefs.language)
		{
			case "English" | "Español" | "Français" | "Português" | "Svenska" | "Русский": //English, Spanish, French, Portuguese, Swedish, Russian
				warnText.font = Paths.font("NotoSans-Bold.ttf");
			case "한국": //Refering in South Korea, Korean
				warnText.font = Paths.font("NotoSansKR-Bold.otf");
			case "العربية": //Arabic
				warnText.font = Paths.font("NotoNaskhArabic-Bold.ttf");
			case "日本": //Japanese
				warnText.font = Paths.font("NotoSansJP-Bold.ttf");
			case "中文": //Chinese (Tradional)
				warnText.font = Paths.font("NotoSansTC-Bold.otf");
		}
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.themeSound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.themeSound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
