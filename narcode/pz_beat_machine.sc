//// PZ Beat machine 2020

/*
Class for custom functional beat machine
*/

//////////////////////////////

PZ_machine {
	var <>beats=4, <>server=nil, <>routine;

	*new {arg server;
		 ^super.new.init(server);
	}

	init {arg server;
		this.server = server;
		this.routine = TaskProxy.new;
		this.routine.play;
	}

	ignite {arg server=this.server, beats=this.beats;
		this.routine.source = {
			inf.do{
				server.bind{
					// audio
					~funcs.do{|f| f.(); };
				};
				beats.wait;
			}
		}
	}

}

PZ_layer {
	 classvar <>maxsubdiv=12, <>debug=false;
	 var <>item=nil, <>itemarg=nil, <>debug=false;

	*new {arg item=this.item, itemarg=nil;

		 ^super.new.init(item, itemarg);
	}

	init {|item, itemarg|
		this.item = item;
		this.itemarg = itemarg;
	}

	rhythm {arg ... args;
		var beats=args;
		// beats.postln;
		 ^Routine{
			if (debug) {item.postln; beats.asString.postln;};

			beats.do{arg beat, index;
				if (beat.isArray.not) { // single:
					if (beat > 0) {
						if (debug) {(index.asString ++ " = " ++ beat.asString).postln;};
						(beat.reciprocal.clip(1, maxsubdiv)).do{
							item.(itemarg);
							(beat.clip(maxsubdiv.reciprocal, 1)).wait;
						};
					} {1.wait};
				} { // array:
					{
						beat.do{arg sub;
							if (sub > 0) {
								if (debug) {(beat.asString ++ " = " ++ beat.asString ++ sub.asString).postln;};
								((sub).clip(1, maxsubdiv)).do{
									item.(itemarg);
									if (sub == 1) {
										(sub/beat.size).wait;
									} {(beat.size.reciprocal/sub).wait;}
							}} {(beat.size.reciprocal).wait;}
						};

						(beat.size.reciprocal).wait;

					}.fork;
					1.wait;
				};
			};
		}.play;
	}

}
