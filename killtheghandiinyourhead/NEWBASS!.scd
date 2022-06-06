(
~effects[\universal] = Synth.tail(nil,\fx, [\amp, 0.4]);
~effects[\jazz]       = Synth.head(nil,\fx_jazz);
~effects[\brutalize1] = Synth.head(nil,\fx_brutalize1);
~effects[\brutalize0] = Synth.head(nil,\fx_brutalize0);
~effects[\fx_del4]    = Synth.head(nil,\fx_del4);
~effects[\fx_del]     = Synth.head(nil,\fx_del);
~effects[\compressor] = Synth.head(nil,\fx_compressor,[\in, 170, \in_car, 70]++[ \dry_wet, 0.1992125984252, \release, 0.044094577165354, \trim, 26.204724409449, \lpf, 15000, \ratio, 11.322834645669, \threshhold, -8.5590551181102, \knee, 0.0, \attack, 0.00078750078740157, \gain, 7.5590551181102, \hpf, 10, \lookahead, 0.0, \bias, 0.10236220472441 ]);
// Pdef(\drm_noise).play(quant:0);
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

)