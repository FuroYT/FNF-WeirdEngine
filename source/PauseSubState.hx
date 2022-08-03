package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import haxe.Json;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<Array<String>> = [];
	var menuItemsOG:Array<Array<String>> = [];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	//var botplayText:FlxText;

	public static var checkCutScenes:Bool = false;

	public static var songName:String = '';
	public static var songFolder:String = '';

	private var missingFileText:Alphabet;
	var missingFileTween:FlxTween;

	public function new(x:Float, y:Float)
	{
		super();

		/*if (PlayState.isPixelStage)
			songFolder = 'themes/pixel/';
		else
			songFolder = '';*/

		menuItemsOG = [['Resume', Language.resume], ['Restart Song', Language.restart], ['Options', Language.pauseOption], ['Exit to menu', Language.exit2Menu]];

		if(PlayState.chartingMode || CoolUtil.difficulties.length > 1) {
			menuItemsOG.insert(2, ['Change Difficulty', Language.changeDiff]);
		} //No need to change difficulty if there is only one!

		var hasCharacterSelection:Bool = false;
		var num:Int = 0;

		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(2, ['Chart Editor', Language.chartEdit]);
			menuItemsOG.insert(2, ['Leave Charting Mode', Language.leaveChart]);
			
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(3, ['Skip Time', Language.skipTime]);
			}
			menuItemsOG.insert(3 + num, ['End Song', Language.endSong]);
			menuItemsOG.insert(4 + num, ['Toggle Practice Mode', Language.toggPract]);
			menuItemsOG.insert(5 + num, ['Toggle Botplay', Language.toggBot]);
		}

		if (PlayState.chartingMode || (PlayState.storySelectCharacter && !(WeekData.getCurrentWeek().weekPlayableCharacter == null) && !(WeekData.getCurrentWeek().weekPlayableCharacter == "")))
			hasCharacterSelection = true;

		if (hasCharacterSelection)
			menuItemsOG.insert(2, ['Select Character', Language.pauseCharSel]);

		if(PlayState.chartingMode || checkCutScenes)
			menuItemsOG.insert(2, ['Restart With Cutscenes', Language.restartCut]);


		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push([diff,diff]);
		}
		difficultyChoices.push(['BACK', Language.back]);


		pauseMusic = new FlxSound();
		if(songName != null) {
			pauseMusic.loadEmbedded(Paths.music(songFolder + songName), true, true);
		} else if (songName != 'None') {
			songName = Paths.formatToSongPath(songFolder + ClientPrefs.pauseMusic);
			pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var blueballedTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		blueballedTxt.text = "Blueballed: " + PlayState.deathCounter;
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		missingFileText = new Alphabet(0, 0, Language.missingFiles, true, false, 1, 0.7);
		missingFileText.alpha = 0;
		missingFileText.screenCenter(X);
		missingFileText.y = Std.int(FlxG.height - missingFileText.height - 30);
		add(missingFileText);

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(-1);
		}
		if (downP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if (menuItems == difficultyChoices){
				menuItems = menuItemsOG;
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
				regenMenu();
			}
			else {
				close();
			}
		}

		var daSelected:String = menuItems[curSelected][0];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P)
				{
					FlxG.sound.play(Paths.sound('optionChange'), 0.4);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('optionChange'), 0.4);
					curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (accepted && (cantUnpause <= 0 || !ClientPrefs.controllerMode))
		{
			if (menuItems == difficultyChoices)
			{
				if (daSelected != 'BACK' && PlayState.storyDifficulty != curSelected) {
				//if(menuItems.length - 1 != curSelected && difficultyChoices[curSelected].contains(daSelected)) {
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, curSelected);
					if (!Song.checkJson(poop, name)) {
						missingFileText.alpha = 1;
						if (missingFileTween != null)
						{
							missingFileTween.cancel();
						}
						missingFileTween = FlxTween.tween(missingFileText, {alpha: 0}, 1, {ease: FlxEase.circIn, onComplete: function (twn:FlxTween) {
								missingFileTween = null;
							}
						});
						FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
					}
					else {
						PlayState.SONG = Song.loadFromJson(poop, name);
						PlayState.storyDifficulty = curSelected;
						MusicBeatState.resetState();
						FlxG.sound.music.volume = 0;
						PlayState.changedDifficulty = true;
						PlayState.chartingMode = false;
						return;
					}
				}
				else if (daSelected == 'BACK'){
					menuItems = menuItemsOG;
					regenMenu();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
			}

			switch (daSelected)
			{
				case 'Resume':
					close();
				case 'Change Difficulty':
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					deleteSkipTimeText();
					menuItems = difficultyChoices;
					regenMenu();
				case 'Toggle Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					if(PlayState.instance.practiceMode)
						FlxG.sound.play(Paths.sound('optionOn'), 0.4);
					else
						FlxG.sound.play(Paths.sound('optionOff'), 0.4);
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case "Restart Song":
					restartSong();
				case "Restart With Cutscenes":
					PlayState.seenCutscene = false;
					restartSong();
				case "Leave Charting Mode":
					restartSong();
					PlayState.chartingMode = false;
				case 'Skip Time':
					if(curTime < Conductor.songPosition)
					{
						PlayState.startOnTime = curTime;
						restartSong(true);
					}
					else
					{
						if (curTime != Conductor.songPosition)
						{
							PlayState.instance.clearNotesBefore(curTime);
							PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case "End Song":
					close();
					PlayState.instance.finishSong(true);
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					if(PlayState.instance.cpuControlled)
						FlxG.sound.play(Paths.sound('optionOn'), 0.4);
					else
						FlxG.sound.play(Paths.sound('optionOff'), 0.4);
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case 'Chart Editor':
					MusicBeatState.switchState(new editors.ChartingState());
				case 'Select Character':
					MusicBeatState.switchState(new CharSelectState());
				case "Exit to menu":
					FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					PlayState.chartingMode = false;
					checkCutScenes = false;

					Paths.currentModSelectedDirectory = Paths.currentModDirectory;
					Paths.currentModDirectory = ThemeLoader.themeMod;
					CharSelectState.resetChar();
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}

					var titleJSON = Json.parse(Paths.getTextFromFile('images/${ThemeLoader.themefolder}gfDanceTitle.json'));
					Conductor.changeBPM(titleJSON.bpm);
					PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.themeMusic('freakyMenu'));
					PlayState.changedDifficulty = false;
				case "Options":
					PlayState.seenCutscene = false;
					options.OptionsState.inGame = true;
					LoadingState.loadAndSwitchState(new options.OptionsState(), false);
					FlxG.sound.playMusic(Paths.music(songName));
					FlxG.sound.music.volume = 0.5;
					FlxG.sound.music.time = pauseMusic.time;
			}
		}
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}
	
	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));

				if(item == skipTimeTracker)
				{
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
	}

	function regenMenu():Void {
		skipTimeText = null;
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var textSize:Float = 1;
			if (menuItems[i][1].length > 23)
				textSize = 0.8;
			var item = new Alphabet(0, 70 * i + 30, menuItems[i][1], true, false, 0.05, textSize);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i][0] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
}
