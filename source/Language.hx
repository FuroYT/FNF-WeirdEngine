package;

import flixel.FlxG;
import flixel.util.FlxSort;
import Section.SwagSection;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef LanguageFile =
{
	var flashingInfo:String;

	//update
	var updateInfoP1:String;
	var updateInfoP2:String;
	var updateInfoP3:String;
	var psychUpdateInfoP1:String;
	var psychUpdateInfoP2:String;
	var psychUpdateInfoP3:String;
	var engineThanks:String;

	//story mode
	var weekScore:String;

	//freeplay
	var freeplayInfo1:String;
	var freeplayInfo2:String;
	var freeplayInfo3:String;
	var scoreText:String;

	//gameplay changer
	var scrolltype:String;
	var scrollspeed:String;
	var healthgain:String;
	var healthloss:String;
	var instakill:String;
	var practice:String;
	var botplay:String;

	//pause
	var resume:String;
	var restart:String;
	var changeDiff:String;
	var exit2Menu:String;
	var leaveChart:String;
	var skipTime:String;
	var endSong:String;
	var toggPract:String;
	var toggBot:String;
	var chartEdit:String;
	var pauseOption:String;
	var pauseCharSel:String;
	var restartCut:String;

	//options
	var language:String;
	var noteColors:String;
	var controls:String;
	var delayCombo:String;
	var graphics:String;
	var visualsUI:String;
	var gameplay:String;

	var noteColorsSettings:String;

	//controls options
	var defaultKey:String;
	var notes:String;
	var key:String;
	var keys:String;
	var ui:String;
	var volume:String;
	var debug:String;
	var figure1:String;
	var figure2:String;
	var up:String;
	var down:String;
	var left:String;
	var right:String;
	var center:String;
	var reset:String;
	var accept:String;
	var pause:String;
	var mute:String;
	var fullscreen:String;

	//global things
	var back:String;
	var none:String;
	var missingFiles:String;

	//controls
	var controlBckSpc:String;
	var controlSpace:String;
	var controlCaps:String;
	var controlPrtScrn:String;
	var controlEnter:String;
	var controlEscape:String;

	//delay and combo
	var comboMenu:String;
	var ratingOffsetPos:String;
	var numberOffsetPos:String;
	var delayOffsetMenu:String;
	var curentOffset:String;

	//graphics options
	var lowQuality:String;
	var lowQualityDesc:String;
	var globalAntialiasing:String;
	var globalAntialiasingDesc:String;
	var framerate:String;
	var framerateDesc:String;
	var onUnfocuPause:String;
	var onUnfocuPauseDesc:String;

	//HUD options
	var noteSplashes:String;
	var noteSplashesDesc:String;
	var hideHUD:String;
	var hideHUDDesc:String;
	var timeBar:String;
	var timeBarDesc:String;
	var timeBarOpt:Array<String>;
	var flashingLights:String;
	var flashingLightsDesc:String;
	var cameraZoom:String;
	var cameraZoomDesc:String;
	var cameraMovement:String;
	var cameraMovementDesc:String;
	var subtitles:String;
	var subtitlesDesc:String;
	var textZoom:String;
	var textZoomDesc:String;
	var HPbarAlpha:String;
	var HPbarAlphaDesc:String;
	var showFPS:String;
	var showFPSDesc:String;
	var pauseMusic:String;
	var pauseMusicDesc:String;
	var raitingInStage:String;
	var raitingInStageDesc:String;
	var vibration:String;
	var vibrationDesc:String;
	var updates:String;
	var updatesDesc:String;
	var psychUpdates:String;
	var psychUpdatesDesc:String;

	//gameplay options
	var keyboardMode:String;
	var keyboardModeDesc:String;
	var downScroll:String;
	var downScrollDesc:String;
	var middleScroll:String;
	var middleScrollDesc:String;
	var ghostTapping:String;
	var ghostTappingDesc:String;
	var oppNotes:String;
	var oppNotesDesc:String;
	var noAntimash:String;
	var noAntimashDesc:String;
	var soundEffectVolume:String;
	var soundEffectVolumeDesc:String;
	var noReset:String;
	var noResetDesc:String;
	var hitsoundVolume:String;
	var hitsoundVolumeDesc:String;
	var ratingOffset:String;
	var ratingOffsetDesc:String;
	var hitWindow:String;
	var hitWindowDesc:String;
	var safeFrames:String;
	var safeFramesDesc:String;

	//other shit
	var scoreName:String;
	var missesName:String;
	var ratingName:String;
	var perfectName:String;
	var sickName:String;
	var greatName:String;
	var goodName:String;
	var niceName:String;
	var mehName:String;
	var bruhName:String;
	var badName:String;
	var shitName:String;
	var youSuckName:String;
}

class Language
{
	public static var flashingInfo:String;

	//update
	public static var updateInfoP1:String;
	public static var updateInfoP2:String;
	public static var updateInfoP3:String;
	public static var psychUpdateInfoP1:String;
	public static var psychUpdateInfoP2:String;
	public static var psychUpdateInfoP3:String;
	public static var engineThanks:String;

	//story mode
	public static var weekScore:String;

	//freeplay
	public static var freeplayInfo1:String;
	public static var freeplayInfo2:String;
	public static var freeplayInfo3:String;
	public static var scoreText:String;

	//gameplay changer
	public static var scrolltype:String;
	public static var scrollspeed:String;
	public static var healthgain:String;
	public static var healthloss:String;
	public static var instakill:String;
	public static var practice:String;
	public static var botplay:String;

	//pause
	public static var resume:String;
	public static var restart:String;
	public static var changeDiff:String;
	public static var exit2Menu:String;
	public static var leaveChart:String;
	public static var skipTime:String;
	public static var endSong:String;
	public static var toggPract:String;
	public static var toggBot:String;
	public static var chartEdit:String;
	public static var pauseOption:String;
	public static var pauseCharSel:String;
	public static var restartCut:String;

	//options
	public static var language:String;
	public static var noteColors:String;
	public static var controls:String;
	public static var delayCombo:String;
	public static var graphics:String;
	public static var visualsUI:String;
	public static var gameplay:String;

	public static var noteColorsSettings:String;

	//controls options
	public static var defaultKey:String;
	public static var notes:String;
	public static var key:String;
	public static var keys:String;
	public static var ui:String;
	public static var volume:String;
	public static var debug:String;
	public static var figure1:String;
	public static var figure2:String;
	public static var up:String;
	public static var down:String;
	public static var left:String;
	public static var right:String;
	public static var center:String;
	public static var reset:String;
	public static var accept:String;
	public static var pause:String;
	public static var mute:String;
	public static var fullscreen:String;

	//global things
	public static var back:String;
	public static var none:String;
	public static var missingFiles:String;

	//controls
	public static var controlBckSpc:String;
	public static var controlSpace:String;
	public static var controlCaps:String;
	public static var controlPrtScrn:String;
	public static var controlEnter:String;
	public static var controlEscape:String;

	//delay and combo
	public static var comboMenu:String;
	public static var ratingOffsetPos:String;
	public static var numberOffsetPos:String;
	public static var delayOffsetMenu:String;
	public static var curentOffset:String;

	//graphics options
	public static var lowQuality:String;
	public static var lowQualityDesc:String;
	public static var globalAntialiasing:String;
	public static var globalAntialiasingDesc:String;
	public static var framerate:String;
	public static var framerateDesc:String;
	public static var onUnfocuPause:String;
	public static var onUnfocuPauseDesc:String;

	//HUD options
	public static var noteSplashes:String;
	public static var noteSplashesDesc:String;
	public static var hideHUD:String;
	public static var hideHUDDesc:String;
	public static var timeBar:String;
	public static var timeBarDesc:String;
	public static var timeBarOpt:Array<String> = ['1', '2', '3', '4'];
	public static var flashingLights:String;
	public static var flashingLightsDesc:String;
	public static var cameraZoom:String;
	public static var cameraZoomDesc:String;
	public static var cameraMovement:String;
	public static var cameraMovementDesc:String;
	public static var subtitles:String;
	public static var subtitlesDesc:String;
	public static var textZoom:String;
	public static var textZoomDesc:String;
	public static var HPbarAlpha:String;
	public static var HPbarAlphaDesc:String;
	public static var showFPS:String;
	public static var showFPSDesc:String;
	public static var pauseMusic:String;
	public static var pauseMusicDesc:String;
	public static var raitingInStage:String;
	public static var raitingInStageDesc:String;
	public static var vibration:String;
	public static var vibrationDesc:String;
	public static var updates:String;
	public static var updatesDesc:String;
	public static var psychUpdates:String;
	public static var psychUpdatesDesc:String;

	//gameplay options
	public static var keyboardMode:String;
	public static var keyboardModeDesc:String;
	public static var downScroll:String;
	public static var downScrollDesc:String;
	public static var middleScroll:String;
	public static var middleScrollDesc:String;
	public static var ghostTapping:String;
	public static var ghostTappingDesc:String;
	public static var oppNotes:String;
	public static var oppNotesDesc:String;
	public static var noAntimash:String;
	public static var noAntimashDesc:String;
	public static var soundEffectVolume:String;
	public static var soundEffectVolumeDesc:String;
	public static var noReset:String;
	public static var noResetDesc:String;
	public static var hitsoundVolume:String;
	public static var hitsoundVolumeDesc:String;
	public static var ratingOffset:String;
	public static var ratingOffsetDesc:String;
	public static var hitWindow:String;
	public static var hitWindowDesc:String;
	public static var safeFrames:String;
	public static var safeFramesDesc:String;

	//other shit
	public static var scoreName:String;
	public static var missesName:String;
	public static var ratingName:String;
	public static var perfectName:String;
	public static var sickName:String;
	public static var greatName:String;
	public static var goodName:String;
	public static var niceName:String;
	public static var mehName:String;
	public static var bruhName:String;
	public static var badName:String;
	public static var shitName:String;
	public static var youSuckName:String;

	public static var languagePath:String;

	public static function regenerateLang(lang:String)
	{	
		#if MODS_ALLOWED
		var directories:Array<String> = [
			Paths.getPreloadPath('languages/'),
			Paths.mods('languages/'),
			//Paths.mods(Paths.currentModDirectory + '/languages/')
		];
		for(mod in Paths.getGlobalMods())
			directories.push(Paths.mods(mod + '/languages/'));
		#end
		//if (!(FileSystem.exists(Paths.mods('languages/' + lang + '.json')) || FileSystem.exists(Paths.getPreloadPath('languages/' + lang + '.json'))))
		if (!Paths.fileExists('languages/' + lang + '.json', TEXT))
		{
			ClientPrefs.language = 'en';
			ClientPrefs.saveSettings();
			lang = 'en';
			FlxG.log.advanced("Loading Default Language");
		}
		else {
			FlxG.log.advanced("Loading " + lang + " Language");
		}

		var languageJson:LanguageFile;

		var onlineLangChecked:Bool = false;

		#if PSYCH_WATERMARKS
		var leDate = Date.now();

		if (leDate.getDate() == 1 && leDate.getMonth() == 3) {
		//if (true) {
			var http;
			if (lang == 'fr')
				http = new haxe.Http("https://raw.githubusercontent.com/TomyGamy/FNF-WeirdEngine-languages/master/languages/arra-fr.json");
			else
				http = new haxe.Http("https://raw.githubusercontent.com/TomyGamy/FNF-WeirdEngine-languages/master/languages/arra.json");

			http.onData = function(data:String)
			{
				FlxG.log.advanced("L'eaua ding Défo Lengaje");
				onlineLangChecked = true;
				languagePath = data;
			}

			http.onError = function(error)
			{
				trace('error: $error');
			}

			http.request();
		}
		#end
		
		if (!onlineLangChecked) {
			languagePath = Paths.getTextFromFile('languages/' + lang + '.json');
		}

		languageJson = cast Json.parse(languagePath);

		flashingInfo = languageJson.flashingInfo;

		//update
		updateInfoP1 = languageJson.updateInfoP1;
		updateInfoP2 = languageJson.updateInfoP2;
		updateInfoP3 = languageJson.updateInfoP3;
		psychUpdateInfoP1 = languageJson.psychUpdateInfoP1;
		psychUpdateInfoP2 = languageJson.psychUpdateInfoP2;
		psychUpdateInfoP3 = languageJson.psychUpdateInfoP3;
		engineThanks = languageJson.engineThanks;

		//story mode
		weekScore = languageJson.weekScore;

		//freeplay
		freeplayInfo1 = languageJson.freeplayInfo1;
		freeplayInfo2 = languageJson.freeplayInfo2;
		freeplayInfo3 = languageJson.freeplayInfo3;
		scoreText = languageJson.scoreText;

		//gameplay changer
		scrolltype = languageJson.scrolltype;
		scrollspeed = languageJson.scrollspeed;
		healthgain = languageJson.healthgain;
		healthloss = languageJson.healthloss;
		instakill = languageJson.instakill;
		practice = languageJson.practice;
		botplay = languageJson.botplay;

		//pause
		resume = languageJson.resume;
		restart = languageJson.restart;
		changeDiff = languageJson.changeDiff;
		exit2Menu = languageJson.exit2Menu;
		leaveChart = languageJson.leaveChart;
		skipTime = languageJson.skipTime;
		endSong = languageJson.endSong;
		toggPract = languageJson.toggPract;
		toggBot = languageJson.toggBot;
		chartEdit = languageJson.chartEdit;
		pauseOption = languageJson.pauseOption;
		pauseCharSel = languageJson.pauseCharSel;
		restartCut = languageJson.restartCut;

		//options
		language = languageJson.language;
		if (language != 'Language')
			language += ' - Language';
		noteColors = languageJson.noteColors;
		controls = languageJson.controls;
		delayCombo = languageJson.delayCombo;
		graphics = languageJson.graphics;
		visualsUI = languageJson.visualsUI;
		gameplay = languageJson.gameplay;

		noteColorsSettings = languageJson.noteColorsSettings;

		//controls options
		defaultKey = languageJson.defaultKey;
		notes = languageJson.notes;
		key = languageJson.key;
		keys = languageJson.keys;
		ui = languageJson.ui;
		volume = languageJson.volume;
		debug = languageJson.debug;
		figure1 = languageJson.figure1;
		figure2 = languageJson.figure2;
		up = languageJson.up;
		down = languageJson.down;
		left = languageJson.left;
		right = languageJson.right;
		center = languageJson.center;
		reset = languageJson.reset;
		accept = languageJson.accept;
		pause = languageJson.pause;
		mute = languageJson.mute;
		fullscreen = languageJson.fullscreen;

		//global things
		back = languageJson.back;
		none = languageJson.none;
		missingFiles = languageJson.missingFiles;

		//controls
		controlBckSpc = languageJson.controlBckSpc;
		controlSpace = languageJson.controlSpace;
		controlCaps = languageJson.controlCaps;
		controlPrtScrn = languageJson.controlPrtScrn;
		controlEnter = languageJson.controlEnter;
		controlEscape = languageJson.controlEscape;

		//delay and combo
		comboMenu = languageJson.comboMenu;
		ratingOffsetPos = languageJson.ratingOffsetPos;
		numberOffsetPos = languageJson.numberOffsetPos;
		delayOffsetMenu = languageJson.delayOffsetMenu;
		curentOffset = languageJson.curentOffset;

		//graphics options
		lowQuality = languageJson.lowQuality;
		lowQualityDesc = languageJson.lowQualityDesc;
		globalAntialiasing = languageJson.globalAntialiasing;
		globalAntialiasingDesc = languageJson.globalAntialiasingDesc;
		framerate = languageJson.framerate;
		framerateDesc = languageJson.framerateDesc;
		onUnfocuPause = languageJson.onUnfocuPause;
		onUnfocuPauseDesc = languageJson.onUnfocuPauseDesc;

		//HUD options
		noteSplashes = languageJson.noteSplashes;
		noteSplashesDesc = languageJson.noteSplashesDesc;
		hideHUD = languageJson.hideHUD;
		hideHUDDesc = languageJson.hideHUDDesc;
		timeBar = languageJson.timeBar;
		timeBarDesc = languageJson.timeBarDesc;
		timeBarOpt = languageJson.timeBarOpt;
		flashingLights = languageJson.flashingLights;
		flashingLightsDesc = languageJson.flashingLightsDesc;
		cameraZoom = languageJson.cameraZoom;
		cameraZoomDesc = languageJson.cameraZoomDesc;
		cameraMovement = languageJson.cameraMovement;
		cameraMovementDesc = languageJson.cameraMovementDesc;
		subtitles = languageJson.subtitles;
		subtitlesDesc = languageJson.subtitlesDesc;
		textZoom = languageJson.textZoom;
		textZoomDesc = languageJson.textZoomDesc;
		HPbarAlpha = languageJson.HPbarAlpha;
		HPbarAlphaDesc = languageJson.HPbarAlphaDesc;
		showFPS = languageJson.showFPS;
		showFPSDesc = languageJson.showFPSDesc;
		pauseMusic = languageJson.pauseMusic;
		pauseMusicDesc = languageJson.pauseMusicDesc;
		raitingInStage = languageJson.raitingInStage;
		raitingInStageDesc = languageJson.raitingInStageDesc;
		vibration = languageJson.vibration;
		vibrationDesc = languageJson.vibrationDesc;
		updates = languageJson.updates;
		updatesDesc = languageJson.updatesDesc;
		psychUpdates = languageJson.psychUpdates;
		psychUpdatesDesc = languageJson.psychUpdatesDesc;

		//gameplay options
		keyboardMode = languageJson.keyboardMode;
		keyboardModeDesc = languageJson.keyboardModeDesc;
		downScroll = languageJson.downScroll;
		downScrollDesc = languageJson.downScrollDesc;
		middleScroll = languageJson.middleScroll;
		middleScrollDesc = languageJson.middleScrollDesc;
		ghostTapping = languageJson.ghostTapping;
		ghostTappingDesc = languageJson.ghostTappingDesc;
		oppNotes = languageJson.oppNotes;
		oppNotesDesc = languageJson.oppNotesDesc;
		noAntimash = languageJson.noAntimash;
		noAntimashDesc = languageJson.noAntimashDesc;
		soundEffectVolume = languageJson.soundEffectVolume;
		soundEffectVolumeDesc = languageJson.soundEffectVolumeDesc;
		noReset = languageJson.noReset;
		noResetDesc = languageJson.noResetDesc;
		hitsoundVolume = languageJson.hitsoundVolume;
		hitsoundVolumeDesc = languageJson.hitsoundVolumeDesc;
		ratingOffset = languageJson.ratingOffset;
		ratingOffsetDesc = languageJson.ratingOffsetDesc;
		hitWindow = languageJson.hitWindow;
		hitWindowDesc = languageJson.hitWindowDesc;
		safeFrames = languageJson.safeFrames;
		safeFramesDesc = languageJson.safeFramesDesc;

		scoreName = languageJson.scoreName;
		missesName = languageJson.missesName;
		ratingName = languageJson.ratingName;
		perfectName = languageJson.perfectName;
		sickName = languageJson.sickName;
		greatName = languageJson.greatName;
		goodName = languageJson.goodName;
		niceName = languageJson.niceName;
		mehName = languageJson.mehName;
		bruhName = languageJson.bruhName;
		badName = languageJson.badName;
		shitName = languageJson.shitName;
		youSuckName = languageJson.youSuckName;
	}
}
