
//this is how it is supposed to sounds
(
Pbind(
	\amp, Pseq([0.3,0.1,0.1,0.1],inf),
	\degree, Pseq([0,1,2,3],inf),
	\dur, 0.25,
).play;
)
//this is the way i want to make it sound like the previous one
(
~args = [\amp, Pseq([0.3,0.1,0.1,0.1],inf),\degree, Pseq([0,1,2,3],inf)];
Pbind(
	\args, ~args,
	\dur, 0.25,
).play
)



(
~args1 = Pbind(\amp, Pseq([0.3,0.1,0.1,0.1],inf),\degree, Pseq([0,1,2,3],inf));
(Plazy{~args} <> Pbind(
	\dur, 0.25,
)).play
)



(
~args = [\amp, Pseq([0.3,0.1,0.1,0.1],inf),\degree, Pseq([0,1,2,3],inf)];
Pbind(
	\dur, 0.25,
	* Plazy{~args}
).play
)






~args = [\amp, Pseq([0.3,0.1,0.1,0.1],inf),\degree, Pseq([3,2,1,0],inf)];
(
~args = [\amp, Pseq([0.3,0.1,0.1,0.1],inf),\degree, Pseq([0,1,2,3],inf)];

Pbind(
	\args, ~args,
	\setter, Pn(Prout({arg ev;
		var strdict = ev[\args].asDict.collect(_.asStream);
		inf.do {
			var vals = strdict.collect(_.next(ev));
			ev.putAll(vals);
			ev.postln;
			ev = 1.yield;
		}
	})),
	\dur, 0.25,
).play
)
~args = [\amp, Pseq([0.3,0.1,0.1,0.1],inf),\degree, Pseq([3,2,1,0],inf)];

~args = [\amp, Pseq([0.3,0.1,0.1,0.1],inf),\degree, Pseq([3,2,1,0],inf)];


3.2.asInt