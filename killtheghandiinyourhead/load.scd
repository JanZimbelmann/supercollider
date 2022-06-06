m = MIDIOut(0);
m.connect(0);
m.program(3,0);
s.scope
(
~load_b.value(\amen,\amen);
~load_b.value(\glitch,\glitch);
~load_b.value(\record,\record);
~load_b.value(\drum,\perc);
~load_b.value(\maidn,\drums);
~load_b.value(\jazz,\jazz);
)

(
~amps=Dictionary.new();
~amps[\guitar]=0.9;
~amps[\dist]=0.37;
~amps[\bass0]=0.14;
~amps[\bass0_high] = 0.1;
~amps[\bass1]=0.14;
// ~amps[\bass1]=0.09;
~amps[\kick0]=0.7;
~amps[\kick1]=0.3;
~amps[\tom]=0.5;
~amps[\noise]=0.17;
~amps[\jazz]=0.155;
~amps[\stick]=0.1;
~amps[\amen]=0.13;


~args = Dictionary.new();
~args[\kick] = [\instrument, \kick, \rel, 0.1, \gain, 0.9, \out, 70, \lpf, 110];
~args[\bass] = [\instrument, \sin_bass, \cur, 30, \gain, 1.3, \out, 170, \lpf, Pkey(\freq)*4,];

~dur= 0.32;

Pdef(\bass1,Pbind(
	\dur, ~dur*Pseq([20,2,1,19],inf),
	\lag, ~dur*8,
	\midinote, Pseq([48,48,48,47],inf)-12,
	\rel, ~dur*Pseq([12,1,0.75,11],inf),
	\amp, Pfunc{~amps[\bass0]},
	*~args[\bass]
));

Pdef(\toms1,Pbind(
	\instrument, \sampler,
	\buf, ~b[\drum][0],
	\atk, 0,
	\dur, ~dur*Place((1/4!7)++[[18.25,20.25]],inf),
	\lag, 2*~dur,
	\hpf, 95,
	\low_db, -3,
	\pan, Pseq([-0.8,0.8],inf),
	\rate, -1.midiratio,
	\amp, Pfunc{~amps[\tom]}*Pn(Pseries(0.6,0.4/10,10))*Pwhite(0.9,1.0),
));

Pdef(\kick00,Pbind(
	\dur, ~dur*Pseq([
		Pser([1.5,1.5,1],12),2,1,1,
		Pser([1.5,1.5,1],15),1,1],inf),
	\midinote, (Pseq(
		(38!6)++(36!9)++
		(38!6)++(36!2)++(35!9),inf)),
	\amp, Pfunc{~amps[\kick0]}*Pn(Pser([1,0.89,0.89],32))*(Pseries(0.1,0.15,inf).clip(0,1)),
	* ~args[\kick]
)).play(quant:0);

Pdef(\kick0,Pbind(
	\dur, ~dur*Pseq([
		Pser([1.5,1.5,1],12),2,1,1,
		Pser([1.5,1.5,1],15),1,1],inf),
	\midinote, (Pseq(
		(38!6)++(36!9)++
		(38!6)++(36!2)++(35!9),inf)),
	\amp, Pfunc{~amps[\kick0]}*Pn(Pser([1,0.89,0.89],32)),
	*~args[\kick]
));

Pdef(\kick1,Pbind(
	\dur, ~dur*Pseq([20,2,1,19],inf),
	\midinote, Pseq([38],inf),
	\amp, Pfunc{~amps[\kick0]},
	*~args[\kick]
));


~slice = 8;
Pdef(\drm_noise,Pbind(
	\instrument, \sampler_loop_old,
	\buf, Prand([~b[\jazz][3],~b[\jazz][4],~b[\jazz][5]],inf),
	\length, ~slice,
	\dur, ~dur*8/~slice,
	\rate, [1,0.5,0.75]*Pwrand([1,-1],[0.8,0.2],inf),
	\atk, Prand([0,Pwhite(0,0.1,3)],inf),
	\pan, ([-0.5,0,0.5]*Pwhite(0.5,1.0))+Pwhite(-0.5,0.5),
	\reset, Place([
		4,1,6,5,8,1,2,1,8,1,
		3,4,4,2,7,4,4,5,8,3,
		6,1,6,5,8,1,1,3,1,7,
		7,4,5,1,2,3,4,4,5,6,7,8
		]
	,inf),
	\amp, Pseq([1,0.7,0.25,0.3,0.5,0.1,0.1,0.1]++(0.5!12)++[1,0.27,0.35,0.4,0.5,0.1,0.1,0.1]++(0.5!14),inf)
	* Place([
		9,1,9,9,9,1,9,1,9,9,
		9,9,1,1,1,1,1,1,1,1,
		9,1,9,9,9,1,1,9,1,9,
		9,9,9,1,1,1,1,1,1,1,1,1
		]
	,inf)/9,
	\amp, Pkey(\amp) * Pseq([1]++(0.6!19)++[1]++(0.6!21),inf),
	\amp, Pkey(\amp) * Pfunc{~amps[\noise]} * [0.3,1,0.3],
	\hits,Pwhite(1,2)*Pseq([3,2,1,6,1],inf)*Pseq((1!20)++[3]++(1!31),inf),
	\seriesArray, Pwrand([
		[[0,-3,8,5]],
		[[0,5,-8,-12]],
		[[0,1,2,3]],
		[5,-12,5,0]
	],[10,1,1,1].normalizeSum,inf),
	\sliRate,[1,2,1]*Pseq((1!20)++(12!6)++(1!18),inf)*Pseq([1,Pwrand([1,3,6,9,12],[20,2,1,0.5,0.25].normalizeSum,1)],inf),
	\out, Pswitch(
		[[90,110,90],[80,110,80]],
		Pseq((0!9)++(1!11)++(0!9)++(1!13),inf)
	),
	\w_delay0, Pwhite(0.0,0.05,inf),
	\w_delay1, Pwhite(0.0,0.05,inf),
	\w, Pseq([0.1,1],inf),
	\hpf, 220,
	\lpf, 8000*Pseq([1,Pwhite(0.3,0.8,19),0.76,Pwhite(0.3,0.8,21)],inf),
	\hs_f, 1200,
	\hs_db, -10,
));



~slice = 8;
Pdef(\drm_jazz1,Pbind(
	\instrument, \sampler_loop,
	\buf, Pseq([
		Pseq([~b[\jazz][0]],4),Pwrand(~b[\jazz],[0.7,0.2,0.1],5),Pseq([~b[\jazz][2]],11),
		Pseq([~b[\jazz][0]],4),Pwrand(~b[\jazz],[0.7,0.2,0.1],3),Pseq([~b[\jazz][2]],15)
	],inf),
	\length, ~slice * Pwrand([1,2],[0.99,0.01],inf),
	\gate,Pseq([1,0],inf),
	\dur, ~dur*8/~slice,
	\rate, [0.5,1],
	\hpf, 140,
	\hits,Pwrand([1,1.5,2,2.5,3,3.5],[5,2,1,0.5,1,0.5].normalizeSum,inf),
	\reldur, (Pwhite(0.7,1.0,inf)**0.5),
	// \lpf, Pwrand([18000,Pwhite(2000,5000,1)],[0.9,0.1],inf),
	// \hpf, Pwrand([60,Pwhite(2000,5000,1)],[0.9,0.1],inf),
	// \hits, Place([Pser([3,1.5,1,3,2,2],10)]++[Pseq([1],10),Pseq([1],12)],inf)+Prand([0,0.5],inf),
	\amp, Pfunc{~amps[\jazz]},
	// \amp, Pseq([1,0.6],inf)*Pseq([1,Pwhite(0.7,0.8,19)],inf),
	\reset, (1+(Pseq([Pseries(0,1,20),Pseries(0,1,10),Pseries(0,1,12)],inf)%8)),
	\seriesArray, Prand([[[0,-3,-1,0]]],inf),
	\out, Place([90,90,100,100,90,90,110,90,90,90,[Pser([90],10),Pser([90],12)]],inf),
	\sliRate, Pwrand([1,3,6,9,12],[20,2,1,0.5,0.25].normalizeSum,inf),
));

//2

Pdef(\drm_jazz2,Pbind(
	\instrument, \sampler_loop,
	\buf, ~b[\jazz][2],
	\length, ~slice,
	\dur, ~dur*8/~slice,
	\rate, 1,
	\reset,3,
	\hpf, 140,
	\rate, Pwhite(0.99,1.01),
	\hits, Pseq((1!7)++[4]++(1!2)++[5,3,1,1,2],inf),
	\reset, Pseq([1,2,3,4,5,6,7,8],inf),
	\seriesArray, Prand([[[0,-3,-1,0]]],inf),
	\out, 90,
	\amp, Pfunc{~amps[\jazz]},
	// \rel, \sine,
	\rel, [10,~dur],
));

Pdef(\bass2,Pbind(
	\dur, ~dur*Pseq([16,1.5,1.5,13],inf),
	\lag, ~dur*8,
	\midinote, Pseq([48,48,48+12,48],inf)-12,
	\rel, ~dur*Pseq([8,1.5,1.5,3],inf),
	\amp, Pfunc{~amps[\bass0]},
	*~args[\bass]
));

Pdef(\bass02,Pbind(
	\dur, ~dur*Pseq((0.5!4)++[4,1,1,4,4],inf),
	\midinote, Pseq([45,
		52,45,52,45,
		43,41,40,38,
	],inf)-12,
	\rel, Pkey(\dur),
	\amp, Pfunc{~amps[\bass0]},
	*~args[\bass]
));

Pdef(\kick2,Pbind(
	\dur, ~dur*Pseq([1],inf),
	\midinote, Pseq([38],inf),
	\cur, 3,
	\amp, Pfunc{~amps[\kick1]},
	*~args[\kick]
));

Pdef(\stick2,Pbind(
	\instrument, \sampler_loop_old,
	\buf, ~b[\jazz][1],
	\length, ~slice,
	\dur, ~dur*Pseq([1,2/3,1/3],inf)*16/~slice,
	\rate, [2,1,4]*Pseq([1,2/3,1/3],inf),
	\atk, Prand([0,Pwhite(0,0.03,3)],inf),
	\pan, ([-0.5,0,0.5]+Pwhite(-0.5,0.5))*Pwhite(-1.0,1.0,inf),
	\reset, Pseq([1,2,3,4,5,6,7,8],inf),
	\amp, [1,0.123,1]*Pfunc{~amps[\stick]}*Pseq([1,Pwhite(0.7,0.85,2)],inf),
	\hits,Pexprand(4,24),
	\seriesArray, Prand([[[0,-3,8,12]]],inf),
	\sliRate, Place([4,6,[8,16,2,3]],inf),
	\out, [90,110,90],
));

//3

Pdef(\kick02,Pbind(
	\dur, ~dur*Pseq([
		1.5,Pseq([0.5/3],3),1.5,1,1,1,
		2,1,Pseq([1.5/3],3),
		0.5,1,1.5,2
	],inf),
	\gain2, Pseg(Pseq([2,15],inf),~dur*16),
	\midinote, Pstutter(1,Pseq((38!8)++(36!5)++(34!4),inf)),
	\rel, Pkey(\dur).clip(0,1.5)/3.5,
	\amp, Pfunc{~amps[\kick1]}*Pkey(\dur).linlin(0,~dur*1.5,0.85,1),
	*~args[\kick]
));
//3
Pdef(\bass3,Pbind(
	\dur, ~dur*Pseq([
		3,3,2, 10,1,1,
		3,3,2, 1,1,1,11
	],inf),
	\midinote, Pseq([
		72,69,64, 67,64,59,
		72,69,64, 67,69,71,66
	],inf)-36,
	\rel, Pkey(\dur),
	\amp, Pfunc{~amps[\bass0]},
	*~args[\bass]
));
Pdef(\kick3,Pbind(
	\dur, ~dur*Pseq([Place([
		1.5,0.5/3,0.5/3,0.5/3,1,0.5,1,1,1,1.5,
		0.5,1,0.5,0.5,0.5,2,1,1,
		0.5,1,1.5,2
	],2),1,1/3,1/3,1/3],inf),
	\midinote, Pstutter(1,Pseq((38!8),inf)),
	\cur, 2,
	\gain2,Pseq([
		Pseg(Pseq([2,15]),~dur*8),
		Pseg(Pseq([2,15]),~dur*12),
		Pseg(Pseq([2,15]),~dur*8),
		Pseg(Pseq([2,15]),~dur*14)
	],inf),
	\amp,Pfunc{~amps[\kick1]}*Pkey(\dur).linlin(0,~dur*1.5,0.85,1)
	*Pkey(\gain).linlin(2,15,1,0.9)
	*Pseq((1!10)++[0]++(1!11)++(1!10)++[0]++(1!15),inf),
	* ~args[\kick]
));

//4
Pdef(\bass4,Pbind(
	\dur, ~dur*Pseq([
		2,2,2,1,
		3,2,2,1,5,
		1,1,1,3,2,2,2
	],inf),
	\midinote, Pseq([
		47,47,47,47,
		54,47,45,47,43,
		47,45,43,42,38,38,35
	],inf)-12,
	\rel, Pkey(\dur),
	\amp, Pfunc{~amps[\bass0_high]},
	*~args[\bass]
));

Pdef(\kick4,Pbind(
	\dur, ~dur*Pseq([1,0.5,0.5],inf),
	\midinote, Pseq([38],inf),
	\amp, ~amps[\amen]=0.25;Pfunc{~amps[\kick0]}*Pseq([1,0.6,0.3],inf),
	* ~args[\kick]
));

//5
~slice=32;
Pdef(\amen5,Pbind(
	\instrument, \sampler_loop_old,
	\buf, Pswitch(~b[\amen],Pseq((0!16)++(1!8)++(2!8),inf)),
	\length, ~slice,
	\dur, ~dur*0.5,
	\rate, Pwhite(0.98,1.02,inf)*Pstutter(8,Pseq([[1,0.5],[1,0.5],[1,2],[1,0.5]],inf)),
	\reset, Pn(Pseries(1,1,~slice)),
	\hits, Pseq((1!16)++[Place([[1,1,2,6,3],[2,3,4,5,6]],8)],inf),
	\amp, Pfunc{~amps[\amen]},
	\sliRate,Pseq((1!16)++[Pwrand([1,6],[0.9,0.1],16)],inf),
	\out, Pseq([70]++(0!15)++(0!4)++[0,100,100,0, 0,0,0,0, 0,0,110,110],inf),
	\pan, Pseq((0!6)++[Pseries(0,0.1,6)]++(0!4),inf)*Pseq([1,-1],inf),
	\ls_db, 1.5,
	\ls_f, 1400,
	\hpf, 100,
	// \out, Pseq([70]++(0!31),inf),
));

Pdef(\bass5,Pbind(
	\dur, ~dur*Pseq([
		8,
		Pseq([0.5],12),1,1,
		8,
		0.5,1,1,0.5,1,1,0.5,1.5,1
	],inf),
	\midinote, Pseq([
		38,
		Pseq([45,40],7),
		38,
		40,45,40,45,40,41,43,38,33
	],inf),
	\rel, Pkey(\dur)*Pseq((1!16)++(0.5!9),inf),
	\amp, Pfunc{~amps[\bass1]},
	*~args[\bass]
));
Pdef(\kick5,Pbind(
	\dur, ~dur*Pseq([
		8,
		Pseq([0.5],12),1,1,
		8,
		0.5,1,1,0.5,1,1,0.5,1.5,1
	],inf),
	\midinote, Pseq([
		38,
		Pseq([45,40],7),
		38,
		40,45,40,45,40,41,43,38,33
	],inf),
	\rel, (Pkey(\dur)/8).clip(0.2,0.4),
	\amp,Pfunc{~amps[\kick1]},
	* ~args[\kick]
));
//6
Pdef(\amen6,Pbind(
	\instrument, \sampler_loop_old,
	\buf, Pswitch(~b[\amen],Pseq((0!16),inf)),
	\length, ~slice,
	\dur, ~dur*0.5,
	\rate, Pwhite(0.98,1.02,inf)*Pstutter(8,Pseq([[1,0.5]],inf)),
	// \reset, Pn(Pseries(1,1,16)),
	\reset,Pseq([
		Pseq([1,2,31,4,5,6,7,8,9,10,11,12,13,14,13,30],3),
		Pseq([1,2,31,4,1,2,31,4,5,6,7,8,13,14,13,30],1)
	],inf),
	\amp, Pfunc{~amps[\amen]},
	\sliRate,Pseq((1!16)++[Pwrand([1,6],[0.9,0.1],16)],inf),
	// \out, Pseq((0!16)++(0!4)++[0,100,100,0, 0,0,0,0, 0,0,110,110],inf),
	\pan, Pseq((0!6)++[Pseries(0,0.06,10)],inf)*Pseq([1,0.1,-1,0.1],inf),
	// \out, 110
	\ls_db, 1.5,
	\ls_f, 1400,
	\hpf, 100,
	\out, Pseq([70]++(0!15),inf),
));
Pdef(\bass6,Pbind(
	\dur, ~dur/2,
	\midinote, Pdrop(16,Pser([Pseq([
		38,40,40,40,
		38,40,40,40,
		38,40,40,40,
		38,36,33,35,
	],3),
	47,42,40,41,
	47,42,48,47,
	47,42,40,41,
	42,43,44,45,
	],inf)),
	\rel, Pkey(\dur)*0.97,
	\amp, Pfunc{~amps[\bass1]}*Pseq([1,0.9,0.9,0.9],inf),
	*~args[\bass]
));
Pdef(\kick6,Pbind(
	\dur, ~dur/2,
	\midinote, Pdrop(16,Pser([Pseq([
		38,40,40,40,
		38,40,40,40,
		38,40,40,40,
		38,36,33,35,
	],3),
	47,42,40,41,
	47,42,48,47,
	47,42,40,41,
	42,43,44,45,
	],inf)),
	\rel, (Pkey(\dur)/8).clip(0.2,0.4),
	\amp,Pfunc{~amps[\kick1]},
	* ~args[\kick]
));
//7
Pdef(\bass7,Pbind(
	\dur, ~dur*Pseq([3,0.5,0.5],inf),
	\midinote, Pseq([
		36,36,35,
		36,36,35,
		31,31,31,
		31,31,31,
		36,36,35,
		36,36,35,
		31,31,31,
		30,30,30,
	],inf)+[0,12],
	\rel, Pkey(\dur),
	\amp, Pfunc{~amps[\bass1]}*[1,0.4]*Pseq([1,0.9,0.9,0.9],inf),
	*~args[\bass]
));
Pdef(\kick7,Pbind(
	\dur, ~dur*Pseq([3,0.5,0.5],inf),
	\midinote, Pseq([
		36,36,35,
		36,36,35,
		31,31,31,
		31,31,31,
		36,36,35,
		36,36,35,
		31,31,31,
		30,30,30,
	],inf),
	\rel, (Pkey(\dur)/8).clip(0.2,0.4),
	\amp,Pfunc{~amps[\kick1]},
	* ~args[\kick]
));

//8
Pdef(\bass8,Pbind(
	\dur, ~dur*Pseq([
		Pseq([1,1.5,1,0.5,1,1,1,1],1),
		Pser([0.5],16),
		Pseq([0.5,0.25,0.25],8),
		Pseq([0.25],32),
	],inf),
	\midinote, Pseq([
		Pseq([40,40,40,40,40,38,36,\r],1),
		Pser([40,28,40,28,28,40,28,40,40,28,38,38,36,36-12,\r,\r],16),
		Pstutter(3,Pseq([40,40,40,40,40,38,36,\r],8))+Place([[0,0,-12,-12,0],[-12,-12,0,0,-12],[-12,-12,0,0,-12]],8),
		Pseq((35!16)++(36!8)++(38!8),1)
	],inf),
	\rel, Pkey(\dur)*Pseq([
		Pser([1,0.75],8),
		Pseq([1],16),
		Pseq([1,1,1,1],8),
		Pseq([0.88],32),
	],inf),
	\amp, Pfunc{~amps[\bass1]},
	*~args[\bass]
));
Pdef(\kick8,Pbind(
	\dur, ~dur*Pseq([
		Pseq([1,1.5,1,0.5,1,1,1,1],1),
		Pser([0.5],16),
		Pseq([0.5,0.25,0.25],8),
		Pseq([0.25],32),
	],inf),
	\midinote, Pseq([
		Pseq([40,40,40,40,40,38,36,\r],1),
		Pser([40,28,40,28,28,40,28,40,40,28,38,38,36,36-12,\r,\r],16),
		Pstutter(3,Pseq([40,40,40,40,40,38,36,\r],8))+Place([[0,0,-12,-12,0],[-12,-12,0,0,-12],[-12,-12,0,0,-12]],8),
		Pseq((35!16)++(36!8)++(38!8),1)
	],inf),
	\rel, Pkey(\dur)*Pseq([
		Pser([1,0.75],8),
		Pseq([1],16),
		Pseq([1,1,1,1],8),
		Pseq([0.88],32),
	],inf),
	\rel, (Pkey(\dur)/8).clip(0.2,0.4),
	\amp,Pfunc{~amps[\kick1]},
	* ~args[\kick]
));
//9
Pdef(\bass9,Pbind(
	\instrument, \sin_bass,
	\dur, ~dur*Pseq([
		1.5,1,1.5,
		1.5,1,1.5,
		1.5,1,1.5,
		1.5,1,1.5,
		1.5,1,1.5,
		1.5,1,1.5,
		1,0.5,1,1.5,
		1,0.5,1,1.5,
	],inf),
	\midinote, Place([
		42,39,34,
		42,39,34,
		37,34,29,
		37,34,29,
		42,39,34,
		42,39,34,
		37,39,37,[34,39],
		37,39,37,[34,39]
	],inf)+1,
	\rel, Pkey(\dur),
	\amp, Pfunc{~amps[\bass1]},
	*~args[\bass]
));
Pdef(\kick9,Pbind(
	\dur, ~dur*Pseq([
		1.5,1,1.5,
		1.5,1,1.5,
		1.5,1,1.5,
		1.5,1,1.5,
		1.5,1,1.5,
		1.5,1,1.5,
		1,0.5,1,1.5,
		1,0.5,1,1.5,
	],inf),
	\midinote, Place([
		42,39,34,
		42,39,34,
		37,34,29,
		37,34,29,
		42,39,34,
		42,39,34,
		37,39,37,[34,39],
		37,39,37,[34,39]
	],inf)+1,
	\rel, Pkey(\dur)*Pseq([
		Pser([1,0.75],8),
		Pseq([1],16),
		Pseq([1,1,1,1],8),
		Pseq([0.88],32),
	],inf),
	\rel, (Pkey(\dur)/8).clip(0.2,0.4),
	\amp,Pfunc{~amps[\kick1]},
	* ~args[\kick]
));


SynthDef(\guitar_danny,{
	arg amp=0.95, out=0, gain=0.7, amount = 0.9, hi_f = 2400,hi_db=4.5,lo_f = 120,lo_db=0, del_dist =0.0, del_long=0.1, tresh=0, del_amp=1, pre_gain = 9, len =0.32;

	var sig, root;
	sig = SoundIn.ar(0)!2;
	sig = (sig * pre_gain).tanh;
	root = sig;
	// sig = Compander.ar(sig,sig,0.5,1,0.3);
	sig = GuitarAmp.ar(sig,1,amount);
	sig = sig+Reflector.ar(sig,5,spread:0.5);
	sig = sig + CombC.ar(sig,len*4,len*4,len*16,del_long*del_amp);
	sig = sig + CombC.ar((sig*15).tanh,len*5,len*5,len*6,del_dist);
	sig = sig + CombC.ar(HPF.ar(sig,330),len*3/2,[len*3/2,len*2/2],15*len,0.45*del_amp);
	sig = sig + CombC.ar(LPF.ar(sig,550),len*1.5,len*1.5,10*len,0.7*del_amp);
	sig = sig + CombC.ar(BPF.ar(sig,1550,2),len,[1,1.01]*len/3,2*len,0.8*del_amp);

	sig = Compander.ar(sig,root,tresh,2,1,0.01,0.3);
	sig = HighShelf.ar(sig,hi_f,1,hi_db);
	sig = LowShelf.ar(sig,lo_f,1,lo_db);
	// sig = BPeakEQ.ar(sig, 550, 2, 2);
	sig = Width1.ar(sig, 1,0.01,0);
	sig = ((sig*gain).tanh);
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = LPF.ar(sig, \lpf.kr(5000));
	Out.ar(out,sig*amp);
}).add;



SynthDef(\glitch_sampler,{
	arg out=0,buf=0, amp=1, atk=0.01, rel=2, cur=3, rate=1, start=0, end=1,pan=0, lpf=18000, hpf=100, gain=1, hits=1;
	var sig, ptr, trig, dur;
	e = EnvGen.kr(Env.perc(atk,rel,1,cur),doneAction:2);
	dur = atk+rel;
	trig= Impulse.kr(hits/dur);
	sig = PlayBuf.ar(2,buf,BufRateScale.kr(buf)*rate,trig,start,1);
	sig = (gain*sig).tanh;
	sig = LPF.ar(sig,lpf);
	sig = HPF.ar(sig,hpf);
	// sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig * e * amp;
	Out.ar(out,sig);
}).add;

SynthDef(\fx,{
	arg blend = 0.3, amp =1;
	var sig;
	sig = In.ar(\out.kr(0),2);
	sig = sig.blend(HighShelf.ar(NHHall.ar(sig.blend(GuitarAmp.ar(sig,0.1,lpf:1000),0.2),0.63,0.95,130,0.5,5000,0.5,0.75,0.65,0.6),880,2,-5),blend);
	sig = sig.blend(GuitarAmp.ar(sig,0.1,lpf:1000),0.05);
	ReplaceOut.ar(\out.kr(0),sig*amp);
}).add;

SynthDef(\sin_bass,{
	arg freq=110, amp=0.3, atk=0.01, rel=1, cur=(-4), gain=0.75, t_side_gate=0, lpf=4000, len = 1;
	var sig, e, e_s, f, count, wet;
	e   = EnvGen.kr(Env.perc(atk, rel, 1, cur),doneAction:2);
	// e_s =SinOsc.ar(f) * (1 - EnvGen.kr(Env.perc(0.01,0.1,1,3),t_side_gate));
	f   = freq!2;
	sig = SinOsc.ar(f);
	sig = sig + SinOsc.ar(f*2);
	sig = sig + SinOsc.ar(f,sig.range(0,2*pi),0.2);
	// sig = sig + SinOsc.ar(f*2)+ SinOsc.ar(f);
	sig = sig + SinOsc.ar(f,sig.range(0,2*pi),0.1);
	sig = sig + SinOsc.ar(f/2,mul:0.2);
	sig = sig / 4;
	sig = sig+LPF.ar(Pulse.ar(f),f*10,0.2)+SinOsc.ar(f*3,mul:0.7);
	sig = LPF.ar(sig,e.linlin(0,1,f*4,f*2));
	sig = sig.blend(GuitarAmp.ar(sig,0.3,lpf:f*6,hpf:f/4),0.7);
	// sig = sig+HPF.ar(Width1.ar(sig,1,SinOsc.kr(2/~dur,pi).range(0,0.01),SinOsc.kr(2/~dur).range(0,0.01)),120,0.3);
	count = 3;
	wet = DelayC.ar(sig, 0.03, SinOsc.ar(1/len, (0..count - 1) / count * 2pi).linlin(-1, 1, 10e-3, 50e-3)).sum / sqrt(count);
	sig = sig + Width1.ar(HPF.ar(wet,f*2,0.2),1,0,0.01);

	sig = (sig*gain).tanh;
	sig = LPF.ar(sig,lpf);
	sig = LowShelf.ar(sig,90,1,2);
	sig = BPeakEQ.ar(sig,110,1,-5);
	sig = sig * amp * e ;
	Out.ar(\out.kr(0),sig);
}).add;

SynthDef(\kick,{
	arg freq=110, amp=0.3, atk=0.03, rel=0.3, cur=3, gain=0.7, gain2=1;
	var sig, e, f;
	e   = EnvGen.kr(Env.new([0,1,0.2,0],[atk,atk,rel], cur),doneAction:2);
	f   = freq!2;
	f   = f * XLine.kr(0.25,1,0.05);
	sig = 0;
	sig = SinOsc.ar(f);
	sig = sig + RLPF.ar(LFNoise0.ar(f,0.5*e),f,0.1);
	sig = (sig*gain*gain2).tanh;
	// sig = LPF.ar(sig,1200*(1-gain.linlin(2,14,0,0.98)));
	sig = LPF.ar(sig,220)+Width1.ar(HPF.ar(sig,110),1,gain2.explin(2,15,0,0.02));
	sig = LPF.ar(sig, \lpf.kr(1000));
	sig = sig * amp * e;
	Out.ar(\out.kr(0),sig);
}).add;

SynthDef(\fx_brutalize0,{
	var sig;
	sig = In.ar(\in.kr(100),2);
	sig = sig.blend(Decimator.ar(sig,LFNoise0.kr(1/~dur).exprange(1000,10000),1,0.3),1);
	sig = LeakDC.ar(sig);
	sig = HighShelf.ar(sig,3200,1,-3);
	sig = sig * Pulse.kr(3/~dur).range(0,1);
	sig = PanStereo.ar(sig,LFNoise0.kr(3/~dur,0.5));
	sig = sig + CombC.ar(sig,~dur*2,~dur*2,~dur*4,0.3) +  DelayN.ar(CombC.ar(sig,~dur*3,~dur*3,~dur*4,0.3),~dur,~dur);
	// sig = PanStereo.ar(sig,LFNoise0.kr(3/~dur,0.2));

	Out.ar(\out.kr(90),sig)
}).add;

SynthDef(\fx_brutalize1,{
	arg gain = 0.24;
	var sig;
	sig = In.ar(\in.kr(110),2);
	sig = sig.blend(GuitarAmp.ar(sig),3);
	sig = sig + CombC.ar(sig, ~dur,~dur/3,~dur*4,0.6);
	// sig = LeakDC.ar(sig);
	Out.ar(\out.kr(90),sig*gain)
}).add;

SynthDef(\fx_del4,{
	var sig;
	sig = In.ar(\in.kr(80),2);
	sig = sig
	+ PanStereo.ar(DelayL.ar(HPF.ar(sig,220),~dur*4,~dur*4,0.9), LFNoise0.kr(1/~dur).range(-0.25,0.25))
	+ PanStereo.ar(DelayL.ar(LPF.ar(sig,1333)*LFPulse.ar(3/~dur,0,0.66).range(0,1),~dur*8,~dur*8,0.9), LFNoise0.kr(1/~dur).range(-0.25,0.25));
	Out.ar(\out.kr(90),sig);
}).add;


SynthDef(\fx_del,{
	var sig;
	sig = In.ar(\in.kr(70),2);
	sig = sig + CombN.ar(LowShelf.ar(sig,120,1,4),~dur/2,~dur/2,~dur*4,0.2);
	Out.ar(\out.kr(0),sig);
}).add;


SynthDef(\fx_jazz,{
	var sig;
	sig = In.ar(\in.kr(90),2);
	sig = sig
	+ PanStereo.ar(DelayC.ar(HPF.ar(sig,150)  ,~dur,~dur*1/3,0.15), LFNoise0.kr(1/~dur).range(-0.5,0.5))
	+ PanStereo.ar(DelayC.ar(HPF.ar(sig,750)  ,~dur,~dur*2/3,0.25), LFNoise0.kr(1/~dur).range(-0.5,0.5))
	+ PanStereo.ar(DelayC.ar(HPF.ar(sig,1250)  ,~dur,~dur*3/3,0.25), LFNoise0.kr(1/~dur).range(-0.5,0.5))
	+ PanStereo.ar(DelayC.ar(HPF.ar(sig,2500)  ,~dur,~dur*4/3,0.3), LFNoise0.kr(1/~dur).range(-0.5,0.5))
	;
	sig = sig + Width0.ar(LPF.ar( CombN.ar(DelayN.ar(sig,~dur*2,~dur*2,0.2),~dur,~dur,~dur*8,0.7)),0)+DelayN.ar(sig,~dur,~dur,0.1);
	Out.ar(\out.kr(0),sig);
}).add;




)

