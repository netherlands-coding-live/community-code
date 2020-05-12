~timestamp = "date '+%M'".unixCmdGetStdOut.asInteger

a = PZ_machine(s)
a.ignite

~funcs['bd'] = {PZ_layer(~bd).rhythm(1,0,[2],[0,1])}
~funcs['hh'] = {PZ_layer(~hh).rhythm([0,1],[0,2],[2],1)}
~funcs['sn'] = {PZ_layer(~sn).rhythm(0,1,0,[1])}

"say -v whi 10 minutes went fast. bye bye".unixCmd

Tdef(\t, {
	loop{
		~now = "date '+%M'".unixCmdGetStdOut.asInteger;
		if ((~timestamp+10) - ~now == 0) {
			~funcs = ();
			"say -v wh the end".unixCmd;
		};
		2.wait;
	}
}).play;

x = {arg note=100; {Saw.ar(98)*0.1*EnvGen.kr(Env.perc,doneAction:2)}.play(s,11) }
~funcs['b'] = {PZ_layer(x).rhythm([2],[2],0,[2])}

Tdef(\t).stop
