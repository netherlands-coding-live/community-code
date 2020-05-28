// Hi CCU! Let's get started... :-)
a.countdown(60*10);

a.sacred.gen; // generates a sequence of 4-part Sacred Harp harmonies
( // Oh yeah!
Pdef(\harp, Pbind(*[
	instrument: \play,
	amp: 0.7,
	buf: b,
	rfreq: \fs6.notecps, // playback (changed from original code \f6.f
	sac: Pfunc({ a.sacred.gen }),
	dur: 1/2,
	delta: Pfunc({|e| e.sac.dur }),
	degree: Pfunc({|e| e.sac.voices }),
	root: \fs0.notemidi,  // changed from original code \fs0.m
	scale: Scale.minor,
	out: ~bus,
])).play(quant: 1);
TempoClock.tempo = 120/60;
);

~bus = Bus.audio(s, 2);
b = Buffer.alloc(s, 44100, 1);
( // recording...
Ndef(\post, {
	var sig1, in, in2, mix;
	in = SoundIn.ar(0); // my voice (into the mic)
	in2 = In.ar(~bus, 2);
	RecordBuf.ar(in, b, run: 1, loop: 1);
	sig1 = Impulse.ar(LFNoise1.ar(10).range(1, 20)) * SinOsc.ar(0.1);
	sig1 = Ringz.ar(sig1, MouseY.kr(60, 10000), LFNoise0.ar(20).range(0.01, 0.001)) * 0.5;
	sig1 = [sig1, CombL.ar(sig1, 2, 0.2, 1.0)];
	sig1 = sig1 * Line.ar(1.0, 0, 10);
	mix = in2 + sig1;
	mix = (mix*0.6) + (JPverb.ar(mix, 10, 0.2, 2.0, 0.6, 0.5, 0.4, 0.5, 0.5, 0.5) * 0.5);
	mix;
}).play(out: 0, numChannels: 2, group: s, addAction: \addToTail);

);

Pbindef(\harp, \amp, {Line.ar(1.0, 0, 10)}.ndef(\fade));

out we go...
Thanks!



