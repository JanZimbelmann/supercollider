//execute this first:
t.setTempoAt
t.beats


(
t = TempoClock.default;
t.beats=10;
a = Pbind(
	\degree, Pseq([0,1,2,3],inf),
	\resetter,Pseq([Pfuncn({0.01.wait;t.beats=0;
	},1),0,0,0],inf),
	).play(t,quant:10)
)
//this second with this kind of quant
b = Pbind(\degree, Pseq([0,1,2,3],inf)).play(t,quant:4.5)
//stop both
a.stop;
b.stop;

//the previous example should always sound like the follower
//indepentend of the timing of triggering the b synth
(
Pbind(\degree, Pseq([0,1,2,3])).play(quant:0);
Pbind(\degree, Pseq([0,1,2,3]),\lag, 0.5).play(quant:0);
)


Pbind(\degree, Pseq([0,1,2,3],inf)).play(quant:4);
Pbind(\degree, Pseq([0,1,2,3],inf)).play(quant:[4,1]);