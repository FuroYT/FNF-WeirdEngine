package android;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import flixel.FlxSprite;

class FlxHitbox extends FlxSpriteGroup {
    public var hitbox:FlxSpriteGroup;

    public var array:Array<FlxButton> = [];

    public var k1:FlxButton;
    public var k2:FlxButton;
    public var k3:FlxButton;
    public var k4:FlxButton;
    public var k5:FlxButton;
    public var k6:FlxButton;
    public var k7:FlxButton;
    public var k8:FlxButton;
    public var k9:FlxButton;
    public var k10:FlxButton;    
    public var k11:FlxButton;

    public var orgType:HitboxType = FOUR;
    public var orgAlpha:Float = 0.75;
    public var orgAntialiasing:Bool = true;
    
    public function new(type:HitboxType = FOUR, ?alphaAlt:Float = 0.75, ?antialiasingAlt:Bool = true)
    {
        super();

	orgType = type;
	orgAlpha = alphaAlt;
	orgAntialiasing = antialiasingAlt;

        hitbox = new FlxSpriteGroup();
        hitbox.scrollFactor.set();

        k1 = new FlxButton(0, 0);
        k2 = new FlxButton(0, 0);
        k3 = new FlxButton(0, 0);
        k4 = new FlxButton(0, 0);
        k5 = new FlxButton(0, 0);
        k6 = new FlxButton(0, 0);
        k7 = new FlxButton(0, 0);
        k8 = new FlxButton(0, 0);
        k9 = new FlxButton(0, 0);
        k10 = new FlxButton(0, 0);
        k11 = new FlxButton(0, 0);

        var hitbox_hint:FlxSprite = new FlxSprite(0, 0);

        switch (type)
        {
            case ONE:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/1k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
            case TWO:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/2k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(640, 0, "k2")));
            case THREE:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/3k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(426, 0, "k2")));
                hitbox.add(add(k3 = createhitbox(852, 0, "k3")));
            case FOUR:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/4k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(320, 0, "k2")));
                hitbox.add(add(k3 = createhitbox(640, 0, "k3")));
                hitbox.add(add(k4 = createhitbox(960, 0, "k4")));
            case FIVE:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/5k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(256, 0, "k2")));
                hitbox.add(add(k3 = createhitbox(512, 0, "k3")));
                hitbox.add(add(k4 = createhitbox(768, 0, "k4")));
                hitbox.add(add(k5 = createhitbox(1024, 0, "k5"))); 
            case SIX:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/6k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(213, 0, "k2")));
                hitbox.add(add(k3 = createhitbox(426, 0, "k3")));
                hitbox.add(add(k4 = createhitbox(639, 0, "k4")));
                hitbox.add(add(k5 = createhitbox(852, 0, "k5")));
                hitbox.add(add(k6 = createhitbox(1065, 0, "k6")));
            case SEVEN:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/7k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(182, 0, "k2")));
                hitbox.add(add(k3 = createhitbox(364, 0, "k3")));
                hitbox.add(add(k4 = createhitbox(546, 0, "k4")));
                hitbox.add(add(k5 = createhitbox(728, 0, "k5")));
                hitbox.add(add(k6 = createhitbox(910, 0, "k6")));
                hitbox.add(add(k7 = createhitbox(1092, 0, "k7")));
            case EIGHT:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/8k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(160, 0, "k2")));
                hitbox.add(add(k3 = createhitbox(320, 0, "k3")));
                hitbox.add(add(k4 = createhitbox(480, 0, "k4")));
                hitbox.add(add(k5 = createhitbox(640, 0, "k5")));
                hitbox.add(add(k6 = createhitbox(800, 0, "k6")));
                hitbox.add(add(k7 = createhitbox(960, 0, "k7")));
                hitbox.add(add(k8 = createhitbox(1120, 0, "k8")));
            case NINE:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/9k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(142, 0, "k2")));
                hitbox.add(add(k3 = createhitbox(284, 0, "k3")));
                hitbox.add(add(k4 = createhitbox(426, 0, "k4")));
                hitbox.add(add(k5 = createhitbox(568, 0, "k5")));
                hitbox.add(add(k6 = createhitbox(710, 0, "k6")));
                hitbox.add(add(k7 = createhitbox(852, 0, "k7")));
                hitbox.add(add(k8 = createhitbox(994, 0, "k8")));
                hitbox.add(add(k9 = createhitbox(1136, 0, "k9")));
            case TEN:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/10k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(128, 0, "k2")));
                hitbox.add(add(k3 = createhitbox(256, 0, "k3")));
                hitbox.add(add(k4 = createhitbox(384, 0, "k4")));    
                hitbox.add(add(k5 = createhitbox(512, 0, "k5")));
                hitbox.add(add(k6 = createhitbox(640, 0, "k6"))); 
                hitbox.add(add(k7 = createhitbox(768, 0, "k7")));
                hitbox.add(add(k8 = createhitbox(896, 0, "k8"))); 
                hitbox.add(add(k9 = createhitbox(1024, 0, "k9")));
                hitbox.add(add(k10 = createhitbox(1152, 0, "k10")));
            case ELEVEN:
                hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox/11k_hint'));

                hitbox.add(add(k1 = createhitbox(0, 0, "k1")));
                hitbox.add(add(k2 = createhitbox(116, 0, "k2")));
                hitbox.add(add(k3 = createhitbox(232, 0, "k3")));
                hitbox.add(add(k4 = createhitbox(348, 0, "k4")));    
                hitbox.add(add(k5 = createhitbox(464, 0, "k5")));
                hitbox.add(add(k6 = createhitbox(580, 0, "k6"))); 
                hitbox.add(add(k7 = createhitbox(696, 0, "k7")));
                hitbox.add(add(k8 = createhitbox(812, 0, "k8"))); 
                hitbox.add(add(k9 = createhitbox(928, 0, "k9")));
                hitbox.add(add(k10 = createhitbox(1044, 0, "k10"))); 
                hitbox.add(add(k11 = createhitbox(1160, 0, "k11"))); 
        }

        array = [k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11];

	hitbox_hint.antialiasing = orgAntialiasing;
	hitbox_hint.alpha = orgAlpha;
	add(hitbox_hint);
    }

    public function createhitbox(x:Float = 0, y:Float = 0, frames:String) {
	var button = new FlxButton(x, y);
	button.loadGraphic(FlxGraphic.fromFrame(getFrames().getByName(frames)));
	button.antialiasing = orgAntialiasing;
	button.alpha = 0;// sorry but I can't hard lock the hitbox alpha
	button.onDown.callback = function (){FlxTween.num(0, 0.75, 0.075, {ease:FlxEase.circInOut}, function(alpha:Float){ button.alpha = alpha;});};
	button.onUp.callback = function (){FlxTween.num(0.75, 0, 0.1, {ease:FlxEase.circInOut}, function(alpha:Float){ button.alpha = alpha;});}
	button.onOut.callback = function (){FlxTween.num(button.alpha, 0, 0.2, {ease:FlxEase.circInOut}, function(alpha:Float){ button.alpha = alpha;});}
	return button;
    }

    public function getFrames():FlxAtlasFrames {
        return switch (orgType)
        {
            case ONE:
                Paths.getSparrowAtlas('androidcontrols/hitbox/1k');
            case TWO:
                Paths.getSparrowAtlas('androidcontrols/hitbox/2k');
            case THREE:
                Paths.getSparrowAtlas('androidcontrols/hitbox/3k');
            case FOUR:
                Paths.getSparrowAtlas('androidcontrols/hitbox/4k');
            case FIVE:
                Paths.getSparrowAtlas('androidcontrols/hitbox/5k');
            case SIX:
                Paths.getSparrowAtlas('androidcontrols/hitbox/6k');
            case SEVEN:
                Paths.getSparrowAtlas('androidcontrols/hitbox/7k');
            case EIGHT:
                Paths.getSparrowAtlas('androidcontrols/hitbox/8k');
            case NINE:
                Paths.getSparrowAtlas('androidcontrols/hitbox/9k');
            case TEN:
                Paths.getSparrowAtlas('androidcontrols/hitbox/10k');
            case ELEVEN:
                Paths.getSparrowAtlas('androidcontrols/hitbox/11k');
        }
    }

    override public function destroy():Void
    {
            super.destroy();

            k1 = null;
            k2 = null;
            k3 = null;
            k4 = null;
            k5 = null;
            k6 = null;
            k7 = null;
            k8 = null;
            k9 = null;
            k10 = null;
            k11 = null;
    }
}

enum HitboxType {
    ONE;
    TWO;
    THREE;
    FOUR;
    FIVE;
    SIX;
    SEVEN;
    EIGHT;
    NINE;
    TEN;
    ELEVEN;
}
