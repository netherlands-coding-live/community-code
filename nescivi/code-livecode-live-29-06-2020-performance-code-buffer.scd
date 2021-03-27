~in = { SoundIn.ar( [0,1] ); };
~in.play;

~ps = { PitchShift.ar( ~in.ar, 0.2, [4/5, 5/4], 0.2, 0.2 ) };
~ps.play;

b = Buffer.alloc( s, s.sampleRate * 5.rand + 2, 2 );

~rec = { RecordBuf.ar( ~ps.ar, b, 0, 0, 0.6 ); };

~play = { PlayBuf.ar( 2, b, 0.8, loop: 1 )*2 };
~play.play

~filt = { Resonz.ar( ~play.ar, t.at( \keyVal ).kr.linexp( 0,1, 300, 4500 ), t.at( \headx ).kr.linexp( -1.0, 1.0, 0.02, 0.2 ), 16 ) };
~filt.play;

t = ThinkPad.new;


c = Buffer.alloc( s, s.sampleRate, 2 );

~recc = { RecordBuf.ar( ~filt.ar, c, 0, t.at( \t_x).kr, t.at(\t_y).kr, t.at( \t_touch ).kr ); };

~plc = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) };
~plc.play

~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf), \amp, Pseq( [2,1,2,3], inf ) );

~plc = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) * EnvGen.kr( Env.perc, \trig.tr, timeScale: \dur.kr(1) ) };
~plc.play

~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf) / 2, \amp, Pseq( [2,1,2,3], inf ) * 4, \trig, 1, \dur, 1 );


~plc2 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) * EnvGen.kr( Env.perc, \trig.tr, timeScale: \dur.kr(1) )};
~plc2.play

~plc2[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 4, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.5 );

~plc3 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) * EnvGen.kr( Env.perc, \trig.tr, timeScale: \dur.kr(1) ) };
~plc3.play

~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * Pstutter( 4, Pseq( [8,7,9,8], inf ) ), \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.5 );

~plc4 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) * EnvGen.kr( Env.perc, \trig.tr, timeScale: \dur.kr(1) ) };
~plc4.play

~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 8 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 8, \trig, 1, \dur, 2 );

p.stop(15);