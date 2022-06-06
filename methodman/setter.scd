(
~rout =
{arg ev;
		var strdicts;
		strdicts = [];
		~setter.do{|set|
			strdicts = strdicts ++ [set.asDict.collect(_.asStream)];
		};
		inf.do {
			var vals, val;
			vals = [];
			strdicts.do{|strdict|
				vals = vals ++ [strdict.collect(_.next(ev))];
			};
			val = vals[~stage];
			val.postln;
			ev.putAll(val);
			ev = 1.yield;
		}
};
)
(
~setter = [];
~setter = ~setter ++ [[\amp, Pseq([0.3,0.1,0.1,0.1],inf),\degree, Pseq([0,1,2,3],inf)]];
~setter = ~setter ++ [[\amp, Pseq([0.3,0.1,0.1,0.1],inf),\degree, Pseq([3,2,1,0],inf)]];
~stage = 0;
Pbind(
	\setter, Prout(~rout),
	\dur, 0.25,
).play;
)
~stage=0;
~stage=1;
