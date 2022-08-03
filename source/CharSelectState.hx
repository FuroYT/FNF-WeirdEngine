package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import FunkinLua;

#if sys
import sys.FileSystem;
#end


using StringTools;

class CharSelectState extends MusicBeatState
{
    var defaultChar:String = 'Default';

    var charSprite:Character;
    var bouleSprite:Character;
    var pcafeSprite:Character;
    var dremySprite:Character;
    var thymSprite:Character;
    var tomySprite:Character;

	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	public var camZooming:Bool = false;
	public var defaultCamZoom:Float = 0.5;

    public static var character:String = 'Default';
    // var length = characters.length;
    var cur_section:Int = 0;
    var text:FlxText = new FlxText(0, 0, FlxG.width, "Character select", 20);
    var cur_character = new FlxText(0, 70, FlxG.width,'Default');
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
    var workInProgress:FlxText = new FlxText(0, 630, FlxG.width, "WARNING : This is still a work in progress", 30);
    var moving:Bool = false;
    var charText:String = null;

    var launched:Bool = false;

	public var charList:FlxTypedGroup<Character>;

	public var defaultCharLoad:Boyfriend = null;
    var nametodisplay:String = null;

    var characters:String = null;

    var charArray:Array<Array<String>> = [];

    var iconP1 = new HealthIcon('bf', true);                                                       
    override public function create()
        {    
            camGame = new FlxCamera();
            camHUD = new FlxCamera();
            camOther = new FlxCamera();
            camHUD.bgColor.alpha = 0;
            camOther.bgColor.alpha = 0;

            FlxG.cameras.reset(camGame);
            FlxG.cameras.add(camHUD);
            FlxG.cameras.add(camOther);
            CustomFadeTransition.nextCamera = camOther;
            FlxCamera.defaultCameras = [camGame];

            FlxG.camera.zoom = defaultCamZoom;
            camHUD.zoom = 1;

            StageData.loadDirectory(PlayState.SONG);

            Conductor.changeBPM(128.0);

            if (PlayState.SONG.song.toLowerCase() == "test")
                characters = "bf,dad,spooky,pico-player,mom,senpai,tankman-player";
            else if (WeekData.getCurrentWeek().weekPlayableCharacter == null || WeekData.getCurrentWeek().weekPlayableCharacter == "")
                characters = "bf,pico-player,tankman-player";
            else
                characters = WeekData.getCurrentWeek().weekPlayableCharacter;

            characters = characters.trim();

            if (characters != null && characters.length > 0)
            {
                var charN:Array<String> = characters.split(',');
                for (i in 0...charN.length)
                {
                    var importChar:Array<String> = [charN[i]];
                    charArray.push(importChar);
                }
            }

            addDefaultChar();
            
            var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('charSelectStage'));
            bg.scale.set(1.3, 1.3);
            bg.scrollFactor.set(0, 0);
            bg.screenCenter();
            bg.y -= 35;
            bg.antialiasing = ClientPrefs.globalAntialiasing;
            
            var bg_lights:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('charSelectStage_lights'));
            bg_lights.scale.set(1.3, 1.3);
            bg_lights.scrollFactor.set(0, 0);
            bg_lights.screenCenter();
            bg_lights.y -= 35;
            //bg_lights.color = 0xFFFFFF99;
            bg_lights.blend = "add";
            bg_lights.alpha = 0.3;
            bg_lights.antialiasing = ClientPrefs.globalAntialiasing;
            
            var bg_Front:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('charSelectStage_Front'));
            bg_Front.scale.set(1.3, 1.3);
            bg_Front.scrollFactor.set(0, 0);
            bg_Front.screenCenter();
            bg_Front.y -= 35;
            bg_Front.antialiasing = ClientPrefs.globalAntialiasing;

            text.setFormat(null,30,FlxColor.WHITE,FlxTextAlign.CENTER);
            text.scrollFactor.set(0, 0);
            text.cameras = [camHUD];

            var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

            leftArrow = new FlxSprite(0, 0);
            leftArrow.screenCenter();
            leftArrow.scrollFactor.set(0, 0);
            leftArrow.frames = ui_tex;
            leftArrow.animation.addByPrefix('idle', "arrow left");
            leftArrow.animation.addByPrefix('press', "arrow push left");
            leftArrow.animation.play('idle');
            leftArrow.scale.set(1.3, 1.3);
            leftArrow.x -= 300 + leftArrow.width;
            leftArrow.y += 100;
            leftArrow.antialiasing = ClientPrefs.globalAntialiasing;

            rightArrow = new FlxSprite(0, 0);
            rightArrow.screenCenter();
            rightArrow.scrollFactor.set(0, 0);
            rightArrow.frames = ui_tex;
            rightArrow.animation.addByPrefix('idle', 'arrow right');
            rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
            rightArrow.animation.play('idle');
            rightArrow.scale.set(1.3, 1.3);
            rightArrow.x += 300;
            rightArrow.y += 100;
            rightArrow.antialiasing = ClientPrefs.globalAntialiasing;

            workInProgress.setFormat(null,30,FlxColor.RED,FlxTextAlign.CENTER);
            workInProgress.scrollFactor.set(0, 0);
            workInProgress.cameras = [camHUD];

            cur_character.setFormat("VCR OSD Mono",30,FlxColor.BLACK,FlxTextAlign.CENTER);
            cur_character.scrollFactor.set(0, 0);
            cur_character.text = charArray[cur_section][0];
            cur_character.cameras = [camHUD];
            
            iconP1.y = 4;
            iconP1.x = 340;
            iconP1.scrollFactor.set(0, 0);
            iconP1.cameras = [camHUD];
            
            add(bg);

            charList = new FlxTypedGroup<Character>();
            add(charList);

		    for (i in 0...charArray.length)
            {
                charSprite = new Character(450, 0, charArray[i][0], true, true);
                //charSprite.scale.set(0.6, 0.6);
                //charSprite.screenCenter(X);
                //charSprite.screenCenter(Y);
                charSprite.x += (i * 880) + charSprite.positionArray[0];
                charSprite.y += charSprite.positionArray[1];
                charSprite.ID = i;
                charList.add(charSprite);
                charSprite.updateHitbox();

                charArray[i].push(getCharNames(charArray[i][0]));
            }

            camFollow = new FlxObject(650, 350, 1, 1);
            camFollowPos = new FlxObject(650, 350, 1, 1);
            add(camFollow);
            add(camFollowPos);
            camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, 0), FlxMath.lerp(camFollowPos.y, 350, 0));
            
            changeSelection();

            FlxG.camera.follow(camFollowPos, null, 1);

            add(bg_lights);
            add(bg_Front);

            add(text);
            add(leftArrow);
            add(rightArrow);
            //add(workInProgress);
            add(cur_character);
            add(iconP1);

            FlxG.sound.playMusic(Paths.music('offsetSong'), 1, true);
            
            super.create();
        }
    
    override public function update(elapsed:Float)
    {
        var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, 350, lerpVal));

        if (!launched) {
            if (controls.UI_LEFT_P)
            {
                changeSelection(-1);
            }
            
            if (controls.UI_RIGHT_P)
            {
                changeSelection(1);
            }

			if (controls.UI_RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.UI_LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');

            if (controls.ACCEPT)
            {
                CustomFadeTransition.nextCamera = camOther;
                launched = true;

                charList.forEach(function(spr:Character)
                {
                    if (cur_section == spr.ID) {
                        if (spr.animation.getByName('hey') != null)
                            spr.playAnim('hey', true);
                        else if (spr.animation.getByName('cheer') != null)
                            spr.playAnim('cheer', true);
                        else
                            spr.playAnim('singUP', true);
                    }
                });

                new FlxTimer().start(1, function(tmr:FlxTimer) {
                    launchSong();
                });
            }
            if (controls.BACK){
                resetChar();
                CustomFadeTransition.nextCamera = camOther;
				PauseSubState.checkCutScenes = false;
                Paths.currentModDirectory = ThemeLoader.themeMod;
				var titleJSON = Json.parse(Paths.getTextFromFile('images/${ThemeLoader.themefolder}gfDanceTitle.json'));
                Conductor.changeBPM(titleJSON.bpm);
                FlxG.sound.playMusic(Paths.themeMusic('freakyMenu'));
                PlayState.chartingMode = false;
                PlayState.isStoryMode = false;
                if (PlayState.isStoryMode)
                    MusicBeatState.switchState(new StoryMenuState());
                else
                    MusicBeatState.switchState(new MainMenuState());
            }
        }

        Conductor.songPosition = FlxG.sound.music.time;
        super.update(elapsed);

    }

	var zoomTween:FlxTween;
	var lastBeatHit:Int = -1;

	override public function beatHit()
        {
            super.beatHit();

		if(lastBeatHit == curBeat)
		{
			return;
		}

        if (!launched)
        {
            charList.forEach(function(spr:Character) {
            if (spr.animation.getByName('idle') == null)
                {
                    spr.dance();
                }
            else if (curBeat % 2 == 0)
                {
                    spr.dance();
                }
            });
            
            if(curBeat % 4 == 2)
            {
                if (ClientPrefs.camZooms)
                    {
                        FlxG.camera.zoom += 0.015;
                        camHUD.zoom = 1;
            
                        if (!camZooming)
                        { // Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
                            FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
                        }
                    }
            }
        }

		lastBeatHit = curBeat;
	}

    var charTween:FlxTween;

    function changeSelection(change:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        cur_section += change;

        if (cur_section < 0)
            cur_section = charArray.length - 1;
        if (cur_section >= charArray.length)
            cur_section = 0;

        if (charArray[cur_section][0] == PlayState.SONG.player1)
            character = 'Default';
        else
            character = charArray[cur_section][0];
        charText = charArray[cur_section][1];

        //trace("The character is: " + charText);
        cur_character.text = charText;

        charList.forEach(function(spr:Character)
        {
            if (cur_section == spr.ID) {
                camFollow.setPosition(((cur_section * 880) + 650), 0);
                iconP1.changeIcon(spr.healthIcon);
            }
        });
    }

    function addDefaultChar()
    {   
        var charLoad:String;
        if (PlayState.SONG.player1 == null)
            charLoad = 'bf';
        else
            charLoad = PlayState.SONG.player1;

        for (i in 0...charArray.length)
        {
            if (charArray[i][0] == charLoad)
            {
                return;
            }
        }

        charArray.insert(0, [charLoad]);
    }

    public static function resetChar()
    {
        character = 'Default';
    }

    function launchSong() {
        PlayState.seenCutscene = false;
        LoadingState.loadAndSwitchState(new PlayState(), true);
        FreeplayState.destroyFreeplayVocals();
    }

	function getCharNames(curChar:String):String
	{
        
		var fullText:String = Assets.getText(Paths.txt('charNames'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

        
        #if MODS_ALLOWED
        if (FileSystem.exists(Paths.modsDataTxt('charNames'))) {
            var fullTextMods:String = Paths.getTextFromFile('data/charNames.txt');

            var modsArray:Array<String> = fullTextMods.split('\n');
            for (i in modsArray)
            {
                swagGoodArray.push(i.split('--'));
            }
            trace("Loaded mods char names.");
        }
        #end

		for (i in 0...swagGoodArray.length)
		{
			if (curChar == swagGoodArray[i][0])
                return swagGoodArray[i][1];
		}

		return curChar;
	}

}