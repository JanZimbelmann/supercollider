(
~slice = 32;
~vout = 330;

~v0_0 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Pseq([1,2],inf),
	\reset,Pseq([
		Pseq([1,0,0,0,3,0,1,0,0,0,1,0,3,0,0,0],7),
		Pseq([1,8,0,13,3,12,1,6,0,23,1,25,3,5,0,4],1)
	],inf),
	\dur, ~dur*8/~slice,
	\reldur, 1,
	\amp, Pfunc{~vamp}*1.1*Pseq([1,0.4,0.4,0.4,1,0.4,1,0.4,0.4,0.4,1,0.4,1,0.4,0.4,0.4],inf),
	// \hits, Prand([1,1,1,1,2],inf),
	\pan, Pwhite(-0.2,0.2,inf)*Pseq([1,2],inf),
	\lpf,6000,
	\seriesArray,  [[0,0]],
	\hpf, 75,
	// \sliRate, Pseq([1,1,5],inf),
	\out, Pfunc{~vout},
);
Pdef(\v0, Pseq([~v0_0],inf))
// .play(quant:0)
;

~v1_0 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Pseq([1,Prand([1,1,0.5,1,1.5])],inf),
	\reset,Place([1,[16,1],[0,13],[1,0],3,[0,19],1,0,[0,18],0,1,[14,0],3,5,0,0],2).trace,
	// \reset, Pseq([Pkey(\reset,1),Pwrand([Pwhite(1,~slice,1),Pkey(\reset,1)],[0.3,0.7],3)],inf),
	\dur, ~dur*8/~slice,
	\reldur, 1,
	\amp, 1.1*Pfunc{~vamp}*Pseq([1,0.2,0.4,0.2,1,0.4,1,0.4,0.4,0.4,1,0.4,1,0.4,0.4,0.4],inf),
	\hits, Prand([1,1,1,1,1,2,3,1.5],inf),
	\pan, Pwhite(-0.2,0.2,inf)*Pseq([1,2],inf),
	\lpf, Pseq([1,0.2,1,0.4,1,0.2,1,0.5],inf)*6000,
	\seriesArray,  [[0,12,-1,-3]],
	\hpf, 75,
	// \sliRate, Pseq([1,1,5],inf),
	\out, Pfunc{~vout},
);
// ~v1_0.play(quant:0);
~v1_1 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Pseq([1,1,0.33,1,1,1,1,1],inf),
	\reset, Pseq([
		Pseq([1,2,3,4,5,6,7,8],6),
		Pseq([10,13,11,13,14,13,13,13,15],2)
	],1),
	\dur, ~dur*8/~slice,
	\reldur, 1,
	\amp, Pfunc{~vamp}*1*Pseq((1!48)++[Pseq([1,0.7,0.5,0.4],4)],inf),
	\lpf,10000* Pstutter(4,Pseq([1,0.5,0.225,0.185],inf)),
	\hits, Place([[1.5,1],[1,1,4],[1,3],1],inf),
	\seriesArray,  [[0,0,-1,-3]],
	// \sliRate, Pseq([1,1,5],inf),
	\out, Pfunc{~vout},
);
~v1_2 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Pseq([1,1,0.33,1,1,1,1,1],inf),
	\reset, Pseq([
		Place([1,[0,3],3,[4,0],[0,15],[0,16],[23,0],12],6),
		Pseq([10,13,11,13,14,13,13,15],1),
		Pseq([10,0,11,0,14,0,13,15],1)
	],1),
	\dur, ~dur*8/~slice,
	\reldur, 1,
	\amp, Pfunc{~vamp}*1*Pseq((1!48)++[Pseq([1,0.7,0.5,0.4],4)],inf),
	\lpf,10000* Pstutter(4,Pseq([1,0.5,0.225,0.185],inf)),
	\hits, Place([[1,1],[1,1,4],[1,3],1],inf),
	\seriesArray,  [[0,0,-1,-3]],
	// \sliRate, Pseq([1,1,5],inf),
	\out, Pfunc{~vout},
);

Pdef(\v1, Pseq([~v1_0,~v1_1,~v1_0,~v1_2],inf));

~v2_0 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Pseq([1,2],inf),
	\reset,Pseq([
		Pseq([2,8,4,13,7,12,9,6,11,23,14,25,16,5,0,4],1)
	],4),
	\dur, ~dur*8/~slice,
	\reldur, 0.8,
	\amp, Pfunc{~vamp}* 1.1*(Pseq([1,0.4,0.4,0.4,1,0.4,1,0.4,0.4,0.4,1,0.4,1,0.4,0.4,0.4],inf)**0.5)*Pseq([Pseries(0.2,0.05,16),Pseq([1],inf)]),
	\hits, Pwrand([1,2,3,4],[0.93,0.3,0.2,0.1],inf),
	\pan, Pwhite(-0.2,0.2,inf)*Pseq([1,2],inf),
	\lpf,5000,
	\seriesArray, [[0,0,0,0]],
	\hpf, 110,
	\sliRate, Place([1,[1,15],1,1,1,1,[15,1],1],inf),
	\out, Pfunc{~vout},
);
~v2_1 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Pseq([1],inf),
	\reset,Place([1,0,0,[2,0],12,[Pwhite(1,32,1),0],0,1],8),
	\dur, ~dur*8/~slice,
	\reldur, 0.8,
	\hits, Pwrand([1,2,3,4],[0.93,0.03,0.02,0.01],inf),
	\pan, Pwhite(-0.2,0.2,inf)*Pseq([1,2],inf),
	\lpf,5000,
	\amp,  Pfunc{~vamp}*1.1 * Place([1,1,1,1,[0.25,1],1,1,1],inf),
	\seriesArray, [[0,0,0,0]],
	\hpf, 110,
	\sliRate, Place([1,[1,15],1,1,1,1,[15,1],1],inf),
	\out, Pfunc{~vout},
);
~v2_2 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Pseq([1],inf),
	\reset,Place([2,0,4,6,0,32,29,0],2),
	\dur, ~dur*8/~slice,
	\reldur, 0.8,
	\hits, Pwrand([1,2,3,4],[0.93,0.03,0.02,0.01],inf),
	\pan, Pwhite(-0.2,0.2,inf)*Pseq([1,2],inf),
	\lpf,5000*Pstutter(8,Pseq([1,0.3])),
	\amp,  Pfunc{~vamp}*1.1 * Place([1,0.56],inf),
	\seriesArray, [[0,0,0,0]],
	\hpf, 110,
	\sliRate, Place([1,[1,15],1,1,1,1,[15,1],1],inf),
	\out, Pfunc{~vout},
);
~v2_3 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Place([0.5,[0.5,5],2,0.5],inf),
	\reset,Pseq([2,0,0,0,5,0,0,0],1),
	\dur, ~dur*8/~slice,
	\reldur, 0.8,
	\hits, Pwrand([1,1.5,2,3,4],[0.85,0.08,0.03,0.02,0.01],inf),
	\pan, Pwhite(-0.2,0.2,inf)*Pseq([1,2],inf),
	\lpf,5000,
	\amp,  Pfunc{~vamp}*1.1*Pseq([1,1],inf),
	\seriesArray, [[0,0,0,0]],
	\hpf, 110,
	\sliRate, Place([1,[1,15],1,1,1,1,[15,1],1],inf),
	\out, Pfunc{~vout},
);
~v2_4 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Place([0.5,[0.5,5],2,0.5],inf),
	\reset,Pseq([
		Place([2,0,[15,18],0,2,0,14,0],4),
		Place([2,1,[15,18],5,2,31,14,0],4),
	],1),
	\dur, ~dur*8/~slice,
	\reldur, 0.8,
	\hits, Pwrand([1,1.5,2,3,4],[0.85,0.08,0.03,0.02,0.01],inf),
	\pan, Pwhite(-0.2,0.2,inf)*Pseq([1,2],inf),
	\lpf,5000,
	\amp, Pfunc{~vamp}*1.1*Pseq([1,1],inf),
	\seriesArray, [[0,0,0,0]],
	\hpf, 110,
	\sliRate, Place([1,[1,15],1,1,1,1,[15,1],1],inf),
	\out, Pfunc{~vout},
);
~v2_5 = Pbind(
	\instrument, \stairstep_loop,
	\buf,~b[\amen][0],
	\length, ~slice,
	\rate, Pseq([0.5],inf),
	\reset,Pseq([Pseries(1,1,~slice)],inf),
	\dur, ~dur*4/~slice,
	\reldur, 0.8,
	\hits, Pwrand([1,2,3,4],[0.93,0.03,0.02,0.01],inf),
	\pan, Pwhite(-0.2,0.2,inf)*Pseq([1,2],inf),
	\lpf,5000,
	\amp, Pfunc{~vamp}*1.1*Pseq([1],inf),
	\seriesArray, [[0,0,0,0]],
	\hpf, 110,
	\sliRate, Place([1,[1,15],1,1,1,1,[15,1],1],inf),
	\out, Pfunc{~vout},
);
// ~v2_3.play(quant:0);
Pdef(\v2, Pseq([~v2_0,~v2_1,~v2_2,~v2_3,~v2_3,~v2_4,~v2_5],inf))
// .play(quant:0)
;
)


Pdef(\sub3,Pmono(
	\sin,
	\gate, 1,
	\midinote, Pseq([
		59,60,59,59,57,
		Pseq([
			57,63,59,57,59,
			56,63,59,57,63,
		],inf)-12
	],inf),
	\dur, ~dur*Pseq([
		2,1,1,2,2,
		Pseq([2,0.5,0.5,0.5,0.5],inf)
	],inf),
	\rel, ~dur*Pseq([
		2,1,0.75,2,1.5,
		Pkey(\dur,5)
	],inf),
	\amp,0.05*Pseq([Pseries(0.05,0.05,5),Pseq([1],inf)],inf),
	// \out, 300,
	\len, ~dur*8,

)).play(quant:0);
)







