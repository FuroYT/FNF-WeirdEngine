package;

import Song.SwagSong;

/**
 * ...
 * @author
 */
typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
	var characterspeed:Float;
}

class Conductor
{
	public static var bpm:Float = 100;
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds
	public static var characterspeed:Float = 1;
	public static var songPosition:Float = 0;
	public static var lastSongPos:Float;
	public static var offset:Float = 0;

	// public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (ClientPrefs.safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public function new()
	{
	}

	public static function judgeNote(note:Note,
			diff:Float = 0) // STOLEN FROM KADE ENGINE (bbpanzu) - I had to rewrite it later anyway after i added the custom hit windows lmao (Shadow Mario)
	{
		// tryna do MS based judgment due to popular demand
		var timingWindows:Array<Int> = [ClientPrefs.sickWindow, ClientPrefs.goodWindow, ClientPrefs.badWindow];
		var windowNames:Array<String> = ['sick', 'good', 'bad'];

		// var diff = Math.abs(note.strumTime - Conductor.songPosition) / (PlayState.songMultiplier >= 1 ? PlayState.songMultiplier : 1);
		for (i in 0...timingWindows.length) // based on 4 timing windows, will break with anything else
		{
			if (diff <= timingWindows[Math.round(Math.min(i, timingWindows.length - 1))])
			{
				return windowNames[i];
			}
		}
		return 'shit';
	}

	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		var charBPM:Float = 1;
		for (i in 0...song.notes.length)
		{
			if (song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;

				if (curBPM < 30)
					charBPM = curBPM * 2;
				else if (curBPM >= 180)
					charBPM = curBPM / 8;
				else if (curBPM >= 90)
					charBPM = curBPM / 4;
				else if (curBPM >= 60)
					charBPM = curBPM / 2;
				else
					charBPM = curBPM;

				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM,
					characterspeed: charBPM
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace("new BPM map BUDDY " + bpmChangeMap);
	}

	public static function changeBPM(newBpm:Float)
	{
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;

		if (newBpm < 30)
			characterspeed = newBpm * 2;
		else if (newBpm >= 180)
			characterspeed = newBpm / 8;
		else if (newBpm >= 90)
			characterspeed = newBpm / 4;
		else if (newBpm >= 60)
			characterspeed = newBpm / 2;
		else
			characterspeed = newBpm;
	}
}
