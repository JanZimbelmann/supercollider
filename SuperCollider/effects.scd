(
SynthDef(\reverb,{
	arg in= 80, out = 0, wetdry=0.5, time = 1, damp=0.3,size=0.8, diff=0.707, amp=1;
	var sig, sig2;
	sig = In.ar(80,2);
	// sig = FreeVerb.ar(sig,0.25,0.6,0.4,1.2);
	sig2 = 0.8*(sig + (4*Reflector.ar(sig)));
	sig = (sig * (1-wetdry)) + (0.5*(sig2+(wetdry * JPverb.ar(sig2,time,damp,size,diff))));
	sig = LeakDC.ar(sig);
	Out.ar(0,sig*amp);
}).store;

SynthDef(\distortion,{
	arg in = 70, out = 0, amp=1, gain=2;
	var sig;
	sig = In.ar(in,1);
	sig = [sig,DelayC.ar(sig,0.02,0.02)];
	sig = (sig*[5,6]).sinh;
	sig = (sig*[6,5]).tanh;
	sig = LeakDC.ar(sig);
	sig = DFM1.ar(sig,2000);
	sig = (sig*gain).tanh;
	Out.ar(out,sig*amp);
}).store;


Routine{~b_sus = Buffer.alloc(s, s.sampleRate * 0.1,1);
	0.01.wait;
	SynthDef(\sus_universal,{
		arg in=0, out=0, buf, amp=1, lev=0.15, run=0, lag=0.5;
		var sig, rec, loop, ptr;
		// run = MouseX.kr(1,0).round;
		// buf=~b_sus;
		rec = In.ar(in);
		ptr = Phasor.ar(1, BufRateScale.kr(buf), 0, BufFrames.kr(buf));
		loop = BufRd.ar(1,buf,ptr);
		loop = (rec*(1-run))+(loop*(run));
		BufWr.ar(loop, buf, ptr);
		sig = 0.15*GrainBuf.ar(
			numChannels:1,
			trigger:Dust.ar(200),
			dur:0.08,
			sndbuf:buf,
			rate:1,
			pos:LFSaw.ar(0.1).range(0,0.1)
		);
		sig = HPF.ar(sig,120);
		sig = (sig*(run.lag(lag))) + rec;
		Out.ar(out,sig);
		Out.ar(\out_rec.ir(660),sig!2);
	}).store;
}.play;



SynthDef(\looper_fix, {arg buf;
	var sig, mic, trig, max, ptr, loop, rec, mix, dont_stop=1;
	var xfade = \xfade.kr(0.02), bufdur;
	bufdur = BufDur.kr(buf);
	//stops the synth once dont_stop is turned to 0
	//could be extended by a trigger to reset the counter but what ever
	// EnvGen.kr(Env.perc(0.001,1,bufdur,1000),dont_stop*Impulse.kr(1/bufdur),doneAction:2);
	//the actual synth
	mic = In.ar(\in.kr(0));
	sig=mic;
	trig = Trig1.ar(\trig.tr(0),bufdur);
	max = Sweep.ar(trig, SampleRate.ir * \run.kr(0));
	ptr = Phasor.ar(trig, 1, 0, max, 0);
	loop = BufRd.ar(2, buf, ptr);
	rec = sum(	[
		sig * \rec_lev.kr(0).varlag(xfade,-2),
		loop * \pre_lev.kr(0).varlag(xfade,-2)
	]);
	rec = rec * \rec_amp.kr(1).varlag(xfade,-2);
	BufWr.ar(rec, buf, ptr);
	mix = sum([
		loop * \loop_amp.kr(1).varlag(xfade,-2),
		sig * \mic_amp.kr(1).varlag(xfade,-2)
	]);
	mix = mix * \amp.kr(1).varlag(xfade,-2);
	sig = mix;
	Out.ar(\out.kr,sig);
	Out.ar(\out_rec.ir(660), mix!2);
}).add;

SynthDef(\looper_flex, {
	var mic, trig, max, ptr, loop, rec, mix;
	var xfade = \xfade.kr(0.02);
	var buf = \buf.kr(0);
	mic = In.ar(\in.ir(50));
	trig = Trig1.ar(\trig.tr(0), ControlDur.ir);
	max = Sweep.ar(trig, SampleRate.ir * \run.kr(0));
	ptr = Phasor.ar(trig+\retrig.tr(0), 1, 0, max, 0);
	loop = BufRd.ar(2, buf, ptr);
	rec = sum([
		mic * \rec_lev.kr(0).varlag(xfade,-2),
		loop * \pre_lev.kr(0).varlag(xfade,-2)
	]);
	rec = rec * \rec_amp.kr(1).varlag(xfade,-2);
	BufWr.ar(rec, buf, ptr);
	mix = sum([
		loop * \loop_amp.kr(1).varlag(xfade,-2),
		mic * \mic_amp.kr(1).varlag(xfade,-2)
	]);
	mix = mix * \amp.kr(1).varlag(xfade,-2);
	Out.ar(\out.ir(0), mix!2);
	Out.ar(\out_rec.ir(660), mix!2);
}).add;
);
// ~looper.set(\trig, 1, \run, 1, \reclev, 1, \prelev, 1, \xfade, 0.02);
// ~looper.set(\run, 0, \reclev, 0, \prelev, 1);
// ~looper.set(\run, 0, \reclev, 1, \prelev, -1.dbamp);

//
// ~effects_exe['reverb']={
// 	arg in=80, out=0;
// 	~effect_reverb.free;
// 	~effect_reverb = Synth.after(1,\rvrb,[\in,in,\out,out]);
// };
//
//
// ~effects_exe['distortion']={
// 	arg in=70, out=0;
// 	~effect_distortion.free;
// 	~effect_distortion = Synth.after(1,\distortion,[\in,in,\out,out]);
// };
//
//
//
// ~effects_exe['stop']={
// 	~effects.do{|effect| effect.free;}
// };
// );
//










//
//
//
// (
// ~effects_exe['comp_sc']={
// 	Ndef(\comp_sc, {
// 		arg in=100,in_car=105,out=80;
// 		var attack = \attack.kr(0.01);
// 		var release = \release.kr(0.1);
// 		var dry, drywet, sig, t, o, r, c, e, lookahead;
// 		var kneelag;
// 		var bias;
// 		var car;
// 		t = \threshhold.kr(-6);
// 		dry = In.ar(in,2);
// 		sig = dry;
// 		car = In.ar(in_car,2);
// 		e = car + CombC.ar(car,0.2,0.02,\relax.kr(0),\relax_amp.kr(0));
// 		e = (e * \trim.kr(0).dbamp).mean;
// 		e = HPF.ar( e, \hpf.kr(50) );
// 		e = LPF.ar( e , \lpf.kr(10000));
// 		e = EnvDetect.ar(e, attack, release);
// 		o = e.ampdb.excess(t);
// 		// scale the excess value by ratio
// 		r = \ratio.kr(4);
// 		c = ( max(o, 0.0) ) * (r.reciprocal - 1);
// 		kneelag = attack * \knee.kr(0.0);
// 		c = c.lag( kneelag );
// 		c = c.dbamp;
// 		c = ((c**\expo.kr(1)).linlin(0,1,\min.kr(0),\max.kr(1))).poll;
// 		sig = (sig * c).tanh
// 		;
// 		sig = sig * \gain.kr(0).dbamp;
// 		sig = sig + car;
// 		sig = LeakDC.ar(sig);
// 		Out.ar(out,sig);
// 	} ).play;
// 	Ndef('comp_sc').set('max', 1.0, 'relax_amp', 0.7906976744186, 'relax', 0.16744186046512, 'attack', 0.0069480104843934, 'lpf', 1788.628253456, 'knee', 3.2325581395349, 'ratio', 8.0852852375082, 'threshhold', -49.674418604651, 'trim', 2.5116279069767, 'min', 0.055813953488372, 'gain', 12.837209302326, 'release', 0.036142092662243, 'expo', 0.35168377060776, 'hpf', 28.418604651163);
// };
//
// ~effects_exe[\comp_sc_edit]={Ndef(\comp_sc).edit;}
// );
//
//
//
//





//
//
// (
// ~effects_exe['comp']={(
// 	Ndef( \comp, {
// 		arg in=90,out=80;
// 		var local;
// 		var attack = \attack.kr(0.01);
// 		var release = \release.kr(0.1);
// 		var dry, drywet, sig, t, o, r, c, e, lookahead;
// 		var kneelag;
// 		var bias;
// 		t = \threshhold.kr(-6);
// 		dry = In.ar(in,2);
// 		sig = dry * \trim.kr(0).dbamp;
// 		e = sig.mean;
// 		e = HPF.ar( e, \hpf.kr(50) );
// 		e = EnvDetect.ar(e, attack, release);
// 		o = e.ampdb.excess(t);
// 		// scale the excess value by ratio
// 		r = \ratio.kr(4);
// 		c = ( max(o, 0.0) ) * (r.reciprocal - 1);
// 		kneelag = attack * \knee.kr(0.0);
// 		c = c.lag( kneelag );
// 		c = c.dbamp;
// 		lookahead = \lookahead.kr(0);
// 		sig = DelayC.ar( sig, 0.5, ( attack + release + kneelag * lookahead).lag(0.4) ); // lookahead
// 		sig = sig * c;
// 		sig = sig * \gain.kr(0).dbamp;
// 		bias = K2A.ar(\bias.kr(0.0));
//
// 		sig = Select.ar( \saturate.kr(1), [sig, (sig + bias).softclip - bias] );
// 		drywet = \dry_wet.kr(1);
// 		sig = Mix([
// 			dry * drywet,
// 			DelayC.ar( dry * (1 - drywet), 0.5, ( attack + release + kneelag * lookahead).lag(0.4) )
// 		]);
// 		sig = LeakDC.ar(sig);
//
// 		Out.ar(out,sig);
// 	} ).play;
// 	Ndef(\compressor).addSpec(
// 		\attack, [0.0000001,0.1, \exp],
// 		\release, [0.0000001,0.4, \exp],
// 		\threshhold, [0,-120],
// 		\trim, [0,60],
// 		\gain, [0,60],
// 		\ratio, [1,20, \exp],
// 		\lookahead, [0.0,1],
// 		\saturate, \switch,
// 		\dry_wet, [0,1],
// 		\hpf, [10, 1000] ,
// 		\knee, [0.0, 10] ,
// 		\bias, [0.0, 0.5] ,
// 		\out, [0, 100] ,
// 	);
// )};
// ~effects_exe[\comp_edit]={Ndef(\compressor).edit;}
// )
//
//
