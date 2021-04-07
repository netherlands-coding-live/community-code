
// INIT first:
(
fork {
	
	// synthdefs
	
	SynthDef(\ping,{
		arg freq = 100, gate = 1, amp = 0.1, out=0, fxBus=nil, bufnum;
		var snd, env;
		freq = [freq, freq*1.01];
		//snd = SinOsc.ar(freq) + Pulse.ar(freq*0.99) + LFTri.ar(freq*1.01);
		snd = Osc.ar(bufnum, freq);
		snd = snd * Linen.kr(gate, 0.001, 1, 0.01, doneAction:Done.freeSelf);
		snd = LeakDC.ar(snd);
		snd = Limiter.ar(snd, 0.95);
		snd = snd * amp * 0.5 * 10;
		//Out.ar()
		Out.ar(out,snd);
	} ).add;

	SynthDef(\wab,{
		arg freq = 100, gate = 1, amp = 0.1, out=0, fxBus=nil, bufnum;
		var snd, env;
		snd = Osc.ar(bufnum, freq);
		snd = snd * Linen.kr(gate, 0.001, 1, 0.1, doneAction:Done.freeSelf);
		snd = LeakDC.ar(snd);
		snd = BRF.ar(snd, LFNoise1.kr(2).exprange(100,1000), 0.1);
		snd = RLPF.ar(snd, LFNoise1.kr(2).exprange(50,1000), 0.2);
		snd = snd * 20;
		snd = Limiter.ar(snd, 0.95);
		snd = Splay.ar(snd);
		snd = snd * amp * 0.7 * 10 ;
		Out.ar(out,snd);
	} ).add;


	SynthDef(\sab,{
		arg freq = 100, gate = 1, amp = 0.1, out=0, fxBus=nil, bufnum, sustain;
		var snd, env;
		freq = XLine.ar(freq,freq * 0.1, sustain);
		snd = Osc.ar(bufnum, freq);
		snd = snd * Linen.kr(gate, 0.001, 1, 0.01, doneAction:Done.freeSelf);
		snd = LeakDC.ar(snd);
		snd = snd + PinkNoise.ar(0.5);
		snd = HPF.ar(snd, 500);
		snd = snd * 20;
		snd = snd.softclip;
		snd = Limiter.ar(snd, 0.95);
		snd = Splay.ar(snd);
		snd = snd * amp * 0.15 * 10;
		Out.ar(out,snd);
	} ).add;

	SynthDef(\dlywrangler, {
		arg out=0, in, wet=0.1, wet2=0.5;
		var snd, dly2;
		snd = In.ar(in,2);
		dly2 = CombN.ar(HPF.ar(snd,300), 1, [0.5,0.77], 5, mul: LFNoise1.kr(0.1).range(0.4,0.1) * 2 * wet2);
		snd = CombN.ar(snd, 1, Lag.ar(LFNoise0.ar(1).range(0.01,0.1),0.1), 3, mul:wet) + snd;
		snd = Limiter.ar(snd, 0.8);
		snd = snd + dly2;
		Out.ar(out, snd);
	}).add;

	// ---------------------------
	
	s.sync;

	~dly.free;
	0.1.wait;
	~dly = Bus.audio(s, 2);

	s.sync;

	0.1.wait;
	~dw.free;
	// create delaymangler comb // on ctrl+. you need to reeval this
	~dw = Synth(\dlywrangler, [\out, 0, \in, ~dly, \wet2, 0.1, \wet, 0.02]);

}
) ///////////////////////////////////////////////////////////////////
// end of init /////////////////////////////////////////////////////


// buffers init
b.free;	c.free;
b = Buffer.alloc(s, 44100 * 10,  1);
c = Buffer.alloc(s, 4096);

// record something throught your mic
{RecordBuf.ar(SoundIn.ar, b, loop:0, doneAction:2).dup}.play
b.normalize
b.plot

(
Ndef(\g, {
	var snd = GrainBuf.ar(1,
		Impulse.ar(100),
		0.2, b, [0.5,1,2,3,4,8],
		pos: LFNoise2.ar(1/50!6).range(0,1) * LFNoise0.ar(100).range(1,0.98)
	);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, LFNoise1.kr(1/10).exprange(500,8000));
	snd = Limiter.ar(snd, 0.6);
	snd = CombN.ar(snd, 1, [0.55,0.44], 5, mul:0.7) + snd;
	snd * 0.8;
}).play
)

Ndef(\g).fadeTime = 20;

// copy a part from buffer b to buffer c
b.copyData(c, 0, b.numFrames.rand)
c.normalize
c.plot

(
Pbindef(\p1, *[instrument:\ping, bufnum:c,
	sustain: 0.1,
	octave: 3,
	out: ~dly,
	dur: Pseq([1,1.5] * 4,inf)
]).play
)

(
Pbindef(\p2, *[instrument:\ping, bufnum:c,
	sustain: 0.01,
	octave: 8,
	out: ~dly,
	dur: Prand([1,1.5] * 1/4,inf)
]).play
)

(
Pbindef(\p3, *[instrument:\wab, bufnum:c,
	sustain: 1,
	octave: [2,3],
	dur: 4 
]).play
)

(
Pbindef(\p4, *[instrument:\sab, bufnum:c,
	sustain: Pwhite(0.1, 0.3),
	octave: 5,
	amp: 0.1,
	out: ~dly,
	dur: Prand([2,3,3.5],inf), 
]).play
)

~dw.set(\wet2, 0.9)
~dw.set(\wet, 0.5)

//////////////////////////
Pbindef(\p1).stop
Pbindef(\p2).stop
Pbindef(\p3).stop
Pbindef(\p4).stop
Ndef(\g).release
//////////////////////////

