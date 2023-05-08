package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;

	private static var curSelected:Int = 0;

	var curDifficulty:Int = -1;

	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var missingFileText:Alphabet;
	var missingFileTween:FlxTween;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var bgInvert:FlxSprite;
	var intendedColor:Int;
	var intendedInvertColor:Int;
	var colorTween:FlxTween;
	var invertColorTween:FlxTween;

	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();

		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length)
		{
			if (weekIsLocked(WeekData.weeksList[i]))
				continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if (colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				var invertBG:Float = 1;
				if (song.length < 4 || !song[3])
					invertBG = 0;
				addSong(song[0], i, song[1], [colors[0], colors[1], colors[2], Math.floor(255*invertBG)]);
			}
		}
		WeekData.loadTheFirstEnabledMod();

		/*//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

			var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
			for (i in 0...initSonglist.length)
			{
				if(initSonglist[i] != null && initSonglist[i].length > 0) {
					var songArray:Array<String> = initSonglist[i].split(":");
					addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
				}
		}*/

		bg = new FlxSprite().loadGraphic(Paths.themeImage('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		bgInvert = new FlxSprite().loadGraphic(Paths.themeImage('menuInvert'));
		bgInvert.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgInvert);
		bgInvert.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			if (songText.width > 980)
			{
				var textScale:Float = 980 / songText.width;
				songText.scale.x = textScale;
				for (letter in songText.lettersArray)
				{
					letter.x *= textScale;
					letter.offset.x *= textScale;
				}
				// songText.updateHitbox();
				// trace(songs[i].songName + ' new scale: ' + textScale);
			}

			Paths.currentModSelectedDirectory = Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter, false);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.5, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("NotoSans-Bold.ttf"), 32, FlxColor.WHITE, RIGHT);

		switch(ClientPrefs.language)
		{
			case "English" | "Español" | "Français" | "Português" | "Svenska" | "Русский": //English, Spanish, French, Portuguese, Swedish, Russian
				scoreText.font = Paths.font("NotoSans-Bold.ttf");
			case "한국": //Refering in South Korea, Korean
				scoreText.font = Paths.font("NotoSansKR-Bold.otf");
			case "العربية": //Arabic
				scoreText.font = Paths.font("NotoNaskhArabic-Bold.ttf");
			case "日本": //Japanese
				scoreText.font = Paths.font("NotoSansJP-Bold.ttf");
			case "中文": //Chinese (Tradional)
				scoreText.font = Paths.font("NotoSansTC-Bold.otf");
		}

		diffText = new FlxText(scoreText.x, scoreText.y + scoreText.height, 0, "", 24);
		diffText.font = scoreText.font;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, Std.int(scoreText.height + diffText.height + 10), 0xFF000000);
		scoreBG.alpha = 0.6;

		add(scoreBG);
		add(diffText);

		add(scoreText);
		
		if (curSelected >= songs.length)
			curSelected = 0;
		bg.color = getSongColor(songs[curSelected].color, false);
		bgInvert.color = getSongColor(songs[curSelected].color, true);
		if (songs[curSelected].color[3] == 0)
			bgInvert.alpha = 0;
		intendedColor = bg.color;
		intendedInvertColor = bgInvert.color;

		if (lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 59).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		
		var controlsInfo:Array<String> = [Language.controlSpace.toUpperCase(), 'CTRL', Language.reset.toUpperCase()];

		var leText:String = #if PRELOAD_ALL StringTools.replace(Language.freeplayInfo1, '@[control]', controlsInfo[0]) + '\n' + #end StringTools.replace(Language.freeplayInfo2, '@[control]', controlsInfo[1]) + '\n' + StringTools.replace(Language.freeplayInfo3, '@[control]', controlsInfo[2]);
		var size:Int = 18;
		
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("NotoSans-Bold.ttf"), size, FlxColor.WHITE, RIGHT);
		switch(ClientPrefs.language)
		{
			case "English" | "Español" | "Français" | "Português" | "Svenska" | "Русский": //English, Spanish, French, Portuguese, Swedish, Russian
				text.font = Paths.font("NotoSans-Bold.ttf");
			case "한국": //Refering in South Korea, Korean
				text.font = Paths.font("NotoSansKR-Bold.otf");
			case "العربية": //Arabic
				text.font = Paths.font("NotoNaskhArabic-Bold.ttf");
			case "日本": //Japanese
				text.font = Paths.font("NotoSansJP-Bold.ttf");
			case "中文": //Chinese (Tradional)
				text.font = Paths.font("NotoSansTC-Bold.otf");
		}
		text.scrollFactor.set();
		add(text);

		text.y = Std.int(FlxG.height - text.height - 4);

		textBG.y = text.y - 4;

		missingFileText = new Alphabet(0, scoreBG.height + 30, Language.missingFiles, true, false, 1, 0.7);
		missingFileText.alpha = 0;
		missingFileText.x = Std.int(FlxG.width - missingFileText.width - 30);
		add(missingFileText);

		super.create();
	}

	override function closeSubState()
	{
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Array<Int>)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	public function getSongColor(color:Array<Int>, inverted:Bool):FlxColor
	{
		if (inverted)
			return FlxColor.fromRGB(color[0], color[1], color[2], color[3]);
		else
			return FlxColor.fromRGB(color[0], color[1], color[2]);
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked
			&& leWeek.weekBefore.length > 0
			&& (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
		{
			if (songCharacters == null)
				songCharacters = ['bf'];

			var num:Int = 0;
			for (song in songs)
			{
				addSong(song, weekNum, songCharacters[num]);
				this.songs[this.songs.length-1].color = weekColor;

				if (songCharacters.length != 1)
					num++;
			}
	}*/
	var instPlaying:Int = -1;

	public static var vocals:FlxSound = null;
	public static var oppVocals:FlxSound = null;

	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if (ratingSplit.length < 2)
		{ // No decimals, add an empty space
			ratingSplit.push('');
		}

		while (ratingSplit[1].length < 2)
		{ // Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = Language.scoreText + ' ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftMult = 3;

		if (songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if (controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.themeSound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP)
			changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if (colorTween != null)
			{
				colorTween.cancel();
			}
			if (invertColorTween != null)
			{
				invertColorTween.cancel();
			}
			if (missingFileTween != null)
			{
				missingFileTween.cancel();
			}
			FlxG.sound.play(Paths.themeSound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if (space)
		{
			if (instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModSelectedDirectory = Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
				{
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		
					// for check opp voices
					var hasOppVocals = Paths.checkOppVoices(PlayState.SONG.song);
		
					// then import them or not
					if (hasOppVocals)
					{
						oppVocals = new FlxSound().loadEmbedded(Paths.oppVoices(PlayState.SONG.song));
					}
					else
					{
						oppVocals = new FlxSound();
					}
				}
				else
				{
					vocals = new FlxSound();
					oppVocals = new FlxSound();
				}

				FlxG.sound.list.add(vocals);
				FlxG.sound.list.add(oppVocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				oppVocals.play();
				oppVocals.persist = true;
				oppVocals.looped = true;
				oppVocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}
		else if (accepted)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
				if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
				#else
				if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
				#end
					poop = songLowercase;
					curDifficulty = 1;
					trace('Couldnt find file');
			}*/
			trace(poop);

			if (!Song.checkJson(poop, songLowercase)) {
				missingFileText.alpha = 1;
				if (missingFileTween != null)
				{
					missingFileTween.cancel();
				}
				missingFileTween = FlxTween.tween(missingFileText, {alpha: 0}, 1, {ease: FlxEase.circIn, onComplete: function (twn:FlxTween) {
						missingFileTween = null;
					}
				});
				FlxG.sound.play(Paths.themeSound('cancelMenu'));
			}
			else {
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
				if (colorTween != null)
				{
					colorTween.cancel();
				}
				if (invertColorTween != null)
				{
					invertColorTween.cancel();
				}
				if (missingFileTween != null)
				{
					missingFileTween.cancel();
				}

				if (FlxG.keys.pressed.SHIFT)
				{
					LoadingState.loadAndSwitchState(new ChartingState());
				}
				else
				{
					if (WeekData.getCurrentWeek().weekPlayableCharacter == null || WeekData.getCurrentWeek().weekPlayableCharacter == "")
						LoadingState.loadAndSwitchState(new PlayState(), true);
					else
						LoadingState.loadAndSwitchState(new CharSelectState());
				}

				FlxG.sound.music.volume = 0;

				destroyFreeplayVocals();
			}
		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.themeSound('scrollMenu'));
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals()
	{
		if (vocals != null)
		{
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
		if (oppVocals != null)
		{
			oppVocals.stop();
			oppVocals.destroy();
		}
		oppVocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length - 1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (playSound)
			FlxG.sound.play(Paths.themeSound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var newColor:Int = getSongColor(songs[curSelected].color, false);
		var newInvertColor:Int = getSongColor(songs[curSelected].color, true);
		if (newColor != intendedColor || newInvertColor != intendedInvertColor)
		{
			if (colorTween != null)
			{
				colorTween.cancel();
			}
			if (invertColorTween != null)
			{
				invertColorTween.cancel();
			}
			intendedColor = newColor;
			intendedInvertColor = newInvertColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween)
				{
					colorTween = null;
				}
			});
			invertColorTween = FlxTween.color(bgInvert, 1, bgInvert.color, intendedInvertColor, {
				onComplete: function(twn:FlxTween)
				{
					invertColorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		Paths.currentModSelectedDirectory = Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if (diffStr != null)
			diffStr = diffStr.trim(); // Fuck you HTML5

		if (diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if (diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if (diffs[i].length < 1)
						diffs.remove(diffs[i]);
				}
				--i;
			}

			if (diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}

		if (CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		// trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if (newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	private function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Array<Int> = [255, 255, 255, 255];
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Array<Int>)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if (this.folder == null)
			this.folder = '';
	}
}
