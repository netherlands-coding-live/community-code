///////////////////////////////////////////////////
// History, as it was on Mon Jun 29 21:15:19 2020.
///////////////////////////////////////////////////

// - 0:0:0 -  
~in = { SoundIn.ar( [0,1] ); };

// - 0:0:2.22 -  
~in.play;

// - 0:0:18.7 -  
~ps = { PitchShift.ar( ~in.ar, 0.2, [4/5, 5/4], 0.2, 0.2 ) };

// - 0:0:21.51 -  
~ps.play;

// - 0:0:37.64 -  
b = Buffer.alloc( s, s.sampleRate * 5.rand + 2, 2 );

// - 0:0:52.65 -  
~rec = { RecordBuf.ar( ~ps.ar, b, 0, 1, 0.6 ); };

// - 0:1:9.8 -  
~play = { PlayBuf.ar( 2, b, 0.8, loop: 1 ) };

// - 0:1:13.03 -  
~play.play

// - 0:1:16.9 -  
~play = { PlayBuf.ar( 2, b, 0.8, loop: 1 )*2 };

// - 0:1:32 -  
~filt = { Resonz.ar( ~play.ar, 700, 0.2, 4 ) };

// - 0:1:37.69 -  
~filt.play;

// - 0:1:41.71 -  
t = ThinkPad.new;

// - 0:1:56.97 -  
~filt = { Resonz.ar( ~play.ar, t.at( \keyVal ).kr.linexp( 0,1, 300, 4500 ), 0.2, 4 ) };

// - 0:2:17.56 -  
~filt = { Resonz.ar( ~play.ar, t.at( \keyVal ).kr.linexp( 0,1, 300, 4500 ), t.at( \headx ).kr.linexp( -1.0, 1.0, 0.02, 0.2 ), 4 ) };

// - 0:2:21.44 -  
~filt = { Resonz.ar( ~play.ar, t.at( \keyVal ).kr.linexp( 0,1, 300, 4500 ), t.at( \headx ).kr.linexp( -1.0, 1.0, 0.02, 0.2 ), 8 ) };

// - 0:2:24.85 -  
~filt = { Resonz.ar( ~play.ar, t.at( \keyVal ).kr.linexp( 0,1, 300, 4500 ), t.at( \headx ).kr.linexp( -1.0, 1.0, 0.02, 0.2 ), 16 ) };

// - 0:2:35.53 -  
c = Buffer.alloc( s, s.sampleRate, 2 );

// - 0:3:5.44 -  
~recc = { RecordBuf.ar( ~filt.ar, c, 0, t.at( \t_x).kr, t.at(\t_y).kr, t.at( \t_touch ).kr ); };

// - 0:3:15.7 -  
~plc = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*2 };

// - 0:3:16.35 -  
~plc.play

// - 0:3:21.47 -  
~plc = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*5 };

// - 0:3:24.87 -  
~plc = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*5 };

// - 0:3:27.6 -  
~plc = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 };

// - 0:3:48.62 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,1], inf ) )

// - 0:3:55.79 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,1], inf ), \delta, 2 );

// - 0:4:10.64 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf) );

// - 0:4:20.09 -  
~plc = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) };

// - 0:4:25.35 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf), \amp, 2 );

// - 0:4:34.68 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf), \amp, Pseq( [2,1,2,3], inf ) );

// - 0:4:46 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf) / 2, \amp, Pseq( [2,1,2,3], inf ) );

// - 0:4:52.97 -  
~plc2 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) };

// - 0:4:54.09 -  
~plc2.play

// - 0:4:57.73 -  
~plc2[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ) * 4, \delta, Pseq( [2,1,1,0.25], inf), \amp, Pseq( [2,1,2,3], inf ) );

// - 0:5:3.14 -  
~plc2[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ) * 4, \delta, Pseq( [2,1,1,0.25], inf) / 2, \amp, Pseq( [2,1,2,3], inf ) );

// - 0:5:7.46 -  
~plc2[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ) * 4, \delta, Pseq( [2,1,1,0.25], inf) / 4, \amp, Pseq( [2,1,2,3], inf ) );

// - 0:5:11.79 -  
~plc2[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ) * 4, \delta, Pshuf( [2,1,1,0.25], inf) / 4, \amp, Pseq( [2,1,2,3], inf ) );

// - 0:5:20.52 -  
~plc2[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ) * 4, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pseq( [2,1,2,3], inf ) );

// - 0:5:31.8 -  
~plc2[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 4, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pseq( [2,1,2,3], inf ) );

// - 0:5:42.88 -  
~plc2[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 4, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pn( Pshuf( [2,1,2,3], 4, ), inf ) );

// - 0:5:44.7 -  
~plc2[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 4, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) );

// - 0:5:58.5 -  
~plc3 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) };

// - 0:5:59.25 -  
~plc3.play

// - 0:6:0.08 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 4, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) );

// - 0:6:3.15 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 8, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) );

// - 0:6:7.82 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 8, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) );

// - 0:6:11.39 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 8, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2 );

// - 0:6:23.62 -  
~plc4 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) };

// - 0:6:24.37 -  
~plc4.play

// - 0:6:25.66 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 8, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2 );

// - 0:6:29.62 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2 );

// - 0:6:35.53 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2 );

// - 0:6:42.99 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 3 );

// - 0:6:45 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 4 );

// - 0:7:3.44 -  
~plc4 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) * EnvGen.kr( Env.perc, \trig.tr, timeScale: \dur.kr(1) ) };

// - 0:7:7.91 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 4, \trig, 1 );

// - 0:7:15.08 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 4, \trig, 1, \dur, 1 );

// - 0:7:21.11 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 4, \trig, 1, \dur, 0.5 );

// - 0:7:25.8 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 8, \trig, 1, \dur, 0.5 );

// - 0:7:33.65 -  
~plc3 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) * EnvGen.kr( Env.perc, \trig.tr, timeScale: \dur.kr(1) ) };

// - 0:7:37.08 -  
~plc2 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) * EnvGen.kr( Env.perc, \trig.tr, timeScale: \dur.kr(1) )};

// - 0:7:42.4 -  
~plc = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) * EnvGen.kr( Env.perc, \trig.tr, timeScale: \dur.kr(1) ) };

// - 0:7:57.26 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 8, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.5 );

// - 0:7:59.05 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 8, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.25 );

// - 0:8:1.39 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 8, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.125 );

// - 0:8:3.33 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 8, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.25 );

// - 0:8:7.71 -  
~plc2[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 4, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ), \trig, 1, \dur, 0.25 );

// - 0:8:15.91 -  
~plc2[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 4, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.25 );

// - 0:8:17.6 -  
~plc2 = { PlayBuf.ar( 2, c, \rate.kr(1), loop: 1 )*8 * \amp.kr(1) * EnvGen.kr( Env.perc, \trig.tr, timeScale: \dur.kr(1) )};

// - 0:8:23.15 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf) / 2, \amp, Pseq( [2,1,2,3], inf ) , \trig, 1, \dur, 0.5 );

// - 0:8:28.69 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf) / 2, \amp, Pseq( [2,1,2,3], inf ) * 2, \trig, 1, \dur, 0.5 );

// - 0:8:30.55 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf) / 2, \amp, Pseq( [2,1,2,3], inf ) * 3, \trig, 1, \dur, 0.5 );

// - 0:8:34.07 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf) / 2, \amp, Pseq( [2,1,2,3], inf ) * 4, \trig, 1, \dur, 0.5 );

// - 0:8:42.01 -  
~plc[1] = \set -> Pbind( \rate, Pseq( [1,4/5,5/4,2], inf ), \delta, Pseq( [2,1,1,0.25], inf) / 2, \amp, Pseq( [2,1,2,3], inf ) * 4, \trig, 1, \dur, 1 );

// - 0:8:46.25 -  
~plc2[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 4, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 4, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.5 );

// - 0:8:49.21 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * 8, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.5 );

// - 0:8:52.71 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 8, \trig, 1, \dur, 2 );

// - 0:9:4.44 -  
~plc4[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 8 ), inf ) / 2, \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) * 2, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 8, \trig, 1, \dur, 2 );

// - 0:9:37.15 -  
~plc3[1] = \set -> Pbind( \rate, Pn( Pshuf( [1,4/5,5/4,2], 4 ), inf ) * Pstutter( 4, Pseq( [8,7,9,8], inf ) ), \delta, Pn( Pshuf( [2,1,1,0.25], 4 ), inf) / 8, \amp, Pn( Pshuf( [2,1,2,3], 4 ), inf ) * 2, \trig, 1, \dur, 0.5 );

// - 0:9:47.99 -  
p.stop(15);

// - 0:9:51.83 -  
~rec = { RecordBuf.ar( ~ps.ar, b, 0, 0, 0.6 ); };

// - 0:9:52.82 -  
~rec = { RecordBuf.ar( ~ps.ar, b, 0, 0, 0.6 ); };

