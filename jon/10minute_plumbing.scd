// Additional SynthDefs Used
(
SynthDef('sin1', {|out=0, freq=440, amp=0.1, gate=1, atk=1, rel=1, curve=0, mod=0, mute=0, pan=0|
  var sig;
  sig = SinOsc.ar(freq);
  sig = sig * (1 - SinOsc.ar(mod, mul: (mod > 0)).range(0.0,1.0));
  sig = sig * EnvGen.ar(Env.asr(atk, 1.0, rel, curve), gate, doneAction: 2);
  sig = Pan2.ar(sig, pan, amp);
  Out.ar(out, sig * (1-mute));
}).add;


SynthDef('rezpad', {arg out=0, amp=0.3, freq=440, dur=1, phase=2.5, modhz=0.1, saturation=10, atk=0.1, tremhz=4, tremmix=0.4;
	var sig, mod, ratios;
	ratios = [ 1.0665241742002, 1.0736323145277, 1.0792282365041, 1.0594630943591, 1.0293022366434 ];
	sig = Saw.ar(freq * ratios).sum;
	mod = SinOsc.ar(modhz, phase * (pi/2)).range(0.2, 3);
	sig = Resonz.ar(sig, [400,1200,500,800,569] * mod, 0.1, mul: 1.0);
	sig = (sig*saturation).tanh * (saturation.log + 1).reciprocal;
	sig = Splay.ar(sig, Line.ar(0.1,1,dur/2)) * EnvGen.ar(Env.linen(atk,1-atk), doneAction: 2, timeScale: dur);
	sig = SinOsc.ar(tremhz).range(1-tremmix,1.0) * sig;
	Out.ar(out, sig * amp);
}).add;

SynthDef('play', {|amp=0.5, rate=1, freq=261.62556, rfreq=261.62556, buf, dur=1, out, pan=0, atk=0.01, rel=0.01, gate=1|
	var sig, playrate;
	playrate = rate * freq / rfreq;
	sig = PlayBuf.ar(1, buf, playrate, 1, 0, 1);
	sig = sig * EnvGen.ar(Env.asr(atk, 1.0, rel), gate: gate, doneAction: 2);
	Out.ar(out, Pan2.ar(sig, pan, amp));
}).add;
);


(
// First few bars from
// Wondrous Love in F minor (1811), The Sacred Harp
~degrees = [
	[5, 5, 5, 5, 4, 5, 4, 4, 3, 1, 3, 2, 5,  5, 4, 5, 7, 8, 7, 7, 5],
	[5, 5, 5, 5, 7, 8, 7, 7, 8, 8, 7, 7, 8,  7, 8, 8, 9, 8, 9, 7, 5] - 7,
	[1, 1, 0, 2, 4, 5, 4, 2, 1, 1, 0, 2, 5,  7, 6, 5, 4, 5, 4, 2, 1],
	[8, 5, 5, 5, 7, 8, 7, 7, 8, 8, 7, 5, 8, 10, 9, 8, 7, 8, 7, 5, 8] - 14,
];

~durations = [
	[2, 4, 4, 4, 4, 2, 4, 4, 2, 4, 4, 2, 2,  4, 4, 4, 4, 2, 4, 4, 1],
	[2, 4, 4, 4, 4, 2, 4, 4, 2, 4, 4, 2, 2,  4, 4, 4, 4, 2, 4, 4, 1],
	[2, 4, 4, 4, 4, 2, 4, 4, 2, 4, 4, 2, 2,  4, 4, 4, 4, 2, 4, 4, 1],
	[2, 4, 4, 4, 4, 2, 4, 4, 2, 4, 4, 2, 2,  4, 4, 4, 4, 2, 4, 4, 1],
];

~seq_1 = (~degrees[0]-1).pseq(inf);
~seq_2 = (~degrees[1]-1).pseq(inf);
~seq_3 = (~degrees[2]-1).pseq(inf);
~seq_4 = (~degrees[3]-1).pseq(inf);
~dur_1 = (1/~durations[0]).pseq(inf);

// 1st order markov chains
m = MarkovSet.fill(100, ~seq_1.asStream); m.makeSeeds;
~vsoprano = m.asStream;
m = MarkovSet.fill(100, ~seq_2.asStream); m.makeSeeds;
~valto = m.asStream;
m = MarkovSet.fill(100, ~seq_3.asStream); m.makeSeeds;
~vtenor = m.asStream;
m = MarkovSet.fill(100, ~seq_4.asStream); m.makeSeeds;
~vbass = m.asStream;
m = MarkovSet.fill(100, ~dur_1.asStream); m.makeSeeds;
~vdur = m.asStream;

// 2nd order markov chains
m = MarkovSetN.fill(100, ~seq_1.asStream, 2); m.makeSeeds;
~vsoprano2 = m.asStream;
m = MarkovSetN.fill(100, ~seq_2.asStream, 2); m.makeSeeds;
~valto2 = m.asStream;
m = MarkovSetN.fill(100, ~seq_3.asStream, 2); m.makeSeeds;
~vtenor2 = m.asStream;
m = MarkovSetN.fill(100, ~seq_4.asStream, 2); m.makeSeeds;
~vbass2 = m.asStream;
m = MarkovSetN.fill(100, ~dur_1.asStream, 2); m.makeSeeds;
~vdur2 = m.asStream;

// 3nd order markov chains
m = MarkovSetN.fill(100, ~seq_1.asStream, 3); m.makeSeeds;
~vsoprano3 = m.asStream;
m = MarkovSetN.fill(100, ~seq_2.asStream, 3); m.makeSeeds;
~valto3 = m.asStream;
m = MarkovSetN.fill(100, ~seq_3.asStream, 3); m.makeSeeds;
~vtenor3 = m.asStream;
m = MarkovSetN.fill(100, ~seq_4.asStream, 3); m.makeSeeds;
~vbass3 = m.asStream;
m = MarkovSetN.fill(100, ~dur_1.asStream); m.makeSeeds;
~vdur3 = m.asStream;

a = ();
a.sacred = ();
a.countdown = {|e, val|
	m = Tdef(\countdown, {
		var seconds, cnt;
		seconds = val;
		seconds.do {|idx|
			cnt = seconds - idx;
			cnt.asString.postln;
			1.wait;
		};
	}).play(SystemClock);
	m;
};
a.sacred.gen = {|e, order=1|
	var res;
	if(order == 1) {
		res = (dur: ~vdur2.next, voices: [~vsoprano.next, ~valto.next, ~vtenor.next, ~vbass.next]);
	};
	if(order == 2) {
		res = (dur: ~vdur2.next, voices: [~vsoprano2.next, ~valto2.next, ~vtenor2.next, ~vbass2.next]);
	};
	if(order == 3) {
		res = (dur: ~vdur3.next, voices: [~vsoprano3.next, ~valto3.next, ~vtenor3.next, ~vbass3.next]);
	};
	res;
};

);
