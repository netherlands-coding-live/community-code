i = File.open(Document.current.path, "r").readAllString();""

(Task{
	1.do{
		i.do{|i|
			i.post;
			case
			{i.ascii == 10}{2.wait;}
			{i.ascii == 32}{1.wait;}
			{[10,32].includes(i.ascii).not}{
				{SinOsc.ar(i.ascii.linlin(32,127,24,60).floor.midicps*2,0,0.1).dup*Env([0,1,1,0],[1,0.2,1]).kr(2)}.play;
				1.wait;
			}
		}
	}
}.play)

(Task{
	1.do{
		u.do{|i|
			i.post;
			case
			{i.ascii == 10}{1.wait;}
			{i.ascii == 32}{0.4.wait;}
			{[10,32].includes(i.ascii).not}{
				{SinOsc.ar(i.ascii.linlin(32,127,200,10000),0,0.1).dup*Env([0,1,1,0],[0.4,0.2,1.21]).kr(2)}.play;
				0.4.wait;
			}
		}
	}
}.play)