# Dependencies

To run the code you will also need the Panda Zooicide beat classes.

Just Place the `pz_beat_machine.sc` file in your Supercollider extensions folder
before your boot supercollider.

I use 3 global variabales `~bd, ~hh, ~sn` for samples of bassdrum, hihat and snare.
You can make your own variables like this:

`
SynthDef(\sampleNarcode, {|out=0, at=0.01, rl=0.1, rate=1, pos=0, amp=1, buf|
	var env = EnvGen.kr(Env.perc(at, rl), doneAction:2);
	var snd;
	snd = PlayBuf.ar(1, buf, BufRateScale.kr(buf)*rate, 1, BufFrames.kr(buf)*pos)*env;
	Out.ar(out, snd*amp);
}).add;

~bd = { Synth(\sampleNarcode, [\buf, Buffer.read(s, "PATH_TO_YOUR_SAMPLE")]) };
~hh = { Synth(\sampleNarcode, [\buf, Buffer.read(s, "PATH_TO_YOUR_SAMPLE")]) };
~sn = { Synth(\sampleNarcode, [\buf, Buffer.read(s, "PATH_TO_YOUR_SAMPLE")]) };

`
