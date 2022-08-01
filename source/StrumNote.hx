package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;
	public var direction:Float = 90;//plan on doing scroll directions soon -bb
	public var downScroll:Bool = false;//plan on doing scroll directions soon -bb
	public var sustainReduce:Bool = true;
	
	private var player:Int;

	private var skinThing:Array<String> = ['static', 'pressed'];
	private var skinThingFix:Array<String> = ['static', 'pressed'];
	
	public var texture(default, set):String = null;
	public var isPixel(default, set):Bool = false;
	private function set_texture(value:String):String {
		if(texture != value) {
			texture = value;
			reloadNote();
		}
		return value;
	}

	private function set_isPixel(value:Bool):Bool {
		if(isPixel != value) {
			isPixel = value;
			reloadNote();
		}
		return value;
	}

	public function new(x:Float, y:Float, leData:Int, player:Int) {
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		noteData = leData;
		this.player = player;
		this.noteData = leData;
		super(x, y);

		var stat:String = Note.keysShit.get(PlayState.mania).get('strumAnims')[leData];
		var pres:String = Note.keysShit.get(PlayState.mania).get('letters')[leData];
		skinThing[0] = stat;
		skinThing[1] = pres;

		skinThingFix[0] = Note.keysShit.get(11).get('strumAnims')[leData];
		skinThingFix[1] = Note.keysShit.get(11).get('letters')[leData];

		var skin:String = 'NOTE_assets';
		//if(PlayState.isPixelStage) skin = 'PIXEL_' + skin;
		if(PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin.length > 1) skin = PlayState.SONG.arrowSkin;
		texture = skin; //Load texture and anims
		isPixel = PlayState.isPixelStage; //Load texture and anims

		scrollFactor.set();
	}

	public function reloadNote()
	{
		var lastAnim:String = null;
		if(animation.curAnim != null) lastAnim = animation.curAnim.name;

		if(isPixel)
			{
				loadGraphic(Paths.image('pixelUI/' + texture));
				if (PlayState.mania == 3 && width == 68) {
					width = width / 4;
					height = height / 5;
					antialiasing = false;
					loadGraphic(Paths.image('pixelUI/' + texture), true, Math.floor(width), Math.floor(height));
					var daFrames:Array<Int> = Note.keysShit.get(PlayState.mania).get('pixelAnimIndex');
	
					setGraphicSize(Std.int(width * PlayState.daPixelZoom * Note.pixelScales[PlayState.mania]));
					updateHitbox();
					antialiasing = false;
					animation.add('static', [daFrames[noteData]]);
					animation.add('pressed', [daFrames[noteData] + 4, daFrames[noteData] + 8], 12, false);
					animation.add('confirm', [daFrames[noteData] + 12, daFrames[noteData] + 16], 24, false);
					//i used calculator
				}
				else {
					width = width / 18;
					height = height / 5;
					antialiasing = false;
					loadGraphic(Paths.image('pixelUI/' + texture), true, Math.floor(width), Math.floor(height));
					var daFrames:Array<Int> = Note.keysShit.get(PlayState.mania).get('pixelAnimIndex');
	
					setGraphicSize(Std.int(width * PlayState.daPixelZoom * Note.pixelScales[PlayState.mania]));
					updateHitbox();
					antialiasing = false;
					animation.add('static', [daFrames[noteData]]);
					animation.add('pressed', [daFrames[noteData] + 18, daFrames[noteData] + 36], 12, false);
					animation.add('confirm', [daFrames[noteData] + 54, daFrames[noteData] + 72], 24, false);
					//i used calculator
				}
			}
		else
			{
				frames = Paths.getSparrowAtlas(texture);

				antialiasing = ClientPrefs.globalAntialiasing;

				setGraphicSize(Std.int(width * Note.scales[PlayState.mania]));

				animation.addByPrefix('static', 'arrow ' + skinThing[1]);
				if (animation.getByName('static') == null)
					animation.addByPrefix('static', 'arrow' + skinThing[0]);

				animation.addByPrefix('pressed', skinThing[1] + ' press', 24, false);
				if (animation.getByName('pressed') == null)
					animation.addByPrefix('pressed', skinThing[0].toLowerCase() + ' press', 24, false);
				if (animation.getByName('pressed') == null)
					animation.addByPrefix('pressed', skinThingFix[1] + ' press', 24, false);
				if (animation.getByName('pressed') == null)
					animation.addByPrefix('pressed', skinThingFix[0].toLowerCase() + ' press', 24, false);

				animation.addByPrefix('confirm', skinThing[1] + ' confirm', 24, false);
				if (animation.getByName('confirm') == null)
					animation.addByPrefix('confirm', skinThing[0].toLowerCase() + ' confirm', 24, false);
				if (animation.getByName('confirm') == null)
					animation.addByPrefix('confirm', skinThingFix[1] + ' confirm', 24, false);
				if (animation.getByName('confirm') == null)
					animation.addByPrefix('confirm', skinThingFix[0].toLowerCase() + ' confirm', 24, false);
			}

		updateHitbox();

		if(lastAnim != null)
		{
			playAnim(lastAnim, true);
		}
	}

	public function postAddedToGroup() {
		playAnim('static');
		switch (PlayState.mania)
		{
			case 0 | 1 | 2: x += width * noteData;
			case 3: x += (Note.swagWidth * noteData);
			default: x += ((width - Note.lessX[PlayState.mania]) * noteData);
		}

		x += Note.xtra[PlayState.mania];
	
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;
		x -= Note.posRest[PlayState.mania];
	}

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		if(animation.curAnim != null){ //my bad i was upset
			if(animation.curAnim.name == 'confirm' && !isPixel) {
				centerOrigin();
			}
		}

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();
		if(animation.curAnim == null || animation.curAnim.name == 'static') {
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		} else {
			colorSwap.hue = ClientPrefs.arrowHSV.get(Note.keysShit.get(PlayState.mania).get('letters')[noteData])[0] / 360;
			colorSwap.saturation = ClientPrefs.arrowHSV.get(Note.keysShit.get(PlayState.mania).get('letters')[noteData])[1] / 100;
			colorSwap.brightness = ClientPrefs.arrowHSV.get(Note.keysShit.get(PlayState.mania).get('letters')[noteData])[2] / 100;

			if(animation.curAnim.name == 'confirm' && !isPixel) {
				centerOrigin();
			}
		}
	}
}
