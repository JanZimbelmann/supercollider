//https://www.youtube.com/watch?v=fTzLDERTxWo(
(
~metronom = {
	|dur=1|
	{GrayNoise.ar(Linen.kr(Impulse.kr(1/dur),0,1,0.1)!2**3)}.play;
};

SynthDef(\sampler,{
	arg out=0,buf=0, amp=1, atk=0.01, rel=2, cur=3,
	rate=1, start=0, end=1, pan=0, lpf=18000, hpf=100, gain=1,
	low_f = 220, low_db =0, high_f=2400, high_db =0;
	var sig, ptr;
	e = EnvGen.kr(Env.perc(atk,rel,1,cur),doneAction:2);
	sig = PlayBuf.ar(2,buf,BufRateScale.kr(buf)*rate,1,start);
	sig = (gain*sig).tanh;
	sig = LPF.ar(sig,lpf);
	sig = HPF.ar(sig,hpf);
	sig = LowShelf.ar(sig,low_f,1,low_db);
	sig = HighShelf.ar(sig,high_f,1,high_db);
	sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig * e * amp;
	Out.ar(out,sig);
}).add;

SynthDef(\sampler_eq,{
	arg out=0,buf=0, amp=1, atk=0.01, rel=2, cur=3,
	rate=1, start=0, end=1, pan=0, lpf=18000, hpf=100, gain=1,
	low_f = 220, low_db =0, high_f=2400, high_db =0, eq_f=#[55,110,330,880,1760,2640,4800,7040], eq_db=#[0,0,0,0,0,0,0,0], eq_rq=1;
	var sig, ptr, wet;
	e = EnvGen.kr(Env.perc(atk,rel,1,cur),doneAction:2);
	sig = PlayBuf.ar(2,buf,BufRateScale.kr(buf)*rate,1,start);
	sig = (gain*sig).tanh;
	sig = LPF.ar(sig,lpf);
	sig = HPF.ar(sig,hpf);
	sig = LowShelf.ar(sig,low_f,1,low_db);
	sig = HighShelf.ar(sig,high_f,1,high_db);
	sig = Balance2.ar(sig[0],sig[1],pan);
	wet = sig;
	6.do{|i| wet = BPeakEQ.ar(wet,eq_f[i],eq_rq,eq_db[i])};
	sig = sig.blend(wet,\blend.kr(1));
	sig = sig.blend(HPF.ar(Width1.ar(sig,1, \w0.kr(0), \w1.kr(0)),80), \wb.kr(0));
	sig = sig * e * amp;
	Out.ar(out,sig);
}).add;

~record_loop = {
arg buf, dur, amp;
~record_looper = Pbind(
	\instrument, \sampler,
	\buf, buf,
	\dur, dur,
	\atk, 0,
	\rel, dur,
	\cur, 1000,
	\amp, amp,
).play(quant:0)
};

SynthDef("zampler_mono", {
	arg amp=1,out=0, buf=1, duration =0.46, trig=0.25;
	var in, sig, bufnum, ptr;
	bufnum = {LocalBuf.new(1024)}!2;
	ptr = Sweep.ar(Impulse.ar(1/trig),1/duration).clip(0,1);
	sig = PV_BufRd(bufnum, buf, ptr);
	Out.ar(out, IFFT(sig, 1)*amp);
}).add;

SynthDef.new(\sampler_loop, {
	arg amp = 1, doneAction = 2, out = 0, buf, rate=1, reset = 1, dur =1, length =1, hits=1, seriesArray = #[0,-12,12,0], sliRate=1, lpf= 17000, hpf=20,reldur=1, hs_f=1200,hs_db=0,ls_f=1200,ls_db=0, amp_lag =0, atk=0, rel=100,cur=(-4), pan=0, w=1, w_delay0=0, w_delay1=0;
	var sig, ptr, ptrInd, noClip, series, bufSup, e;
	//an envelope to avoid .linlin mapping clips of the ptr:
	noClip = EnvGen.kr(Env.new([0,1,0],[reldur*dur/2,reldur*dur/2],[-100,100]),doneAction:2);
	e = EnvGen.kr(Env.perc(atk,rel,1,cur),Impulse.kr(hits/dur));

	//repeating pattern of the pointer + the pointer:
	hits   = hits/rate;
	ptrInd = LFSaw.kr(hits*(1/(dur)),1,0.5/hits,0.5/hits); // this is a copy from below
	series = Dser(seriesArray.midiratio,inf);
	series = Demand.kr(ptrInd-0.01,0,series);
	ptrInd = LFSaw.ar(series*rate*hits*(1/(dur)),1,0.5/hits,0.5/hits);
	// ptrInd = LFSaw.ar(series*rate*hits*0.25,1,0.5/hits,0.5/hits);
	ptr = IEnvGen.ar(Env.new([0,1]),ptrInd).linlin(0,1,(reset-1),reset)/length;
	sig = BufRd.ar(2, buf, ptr*(BufFrames.kr(buf)),0);
	//slicer
	sig = LFPulse.kr(sliRate/(2*dur),0,0.5).lag(0.005)*sig;
	//final configuration
	sig = LPF.ar(sig,lpf);
	sig = HPF.ar(sig,hpf);
	sig = HighShelf.ar(sig,hs_f,1,hs_db);
	sig = LowShelf.ar(sig,ls_f,1,ls_db);
	sig = Width1.ar(sig,w,w_delay0,w_delay1);
	sig = PanStereo.ar(sig,pan);
	sig = sig * amp.lag(amp_lag) * noClip *e;
	Out.ar(out, sig);
}).add;


SynthDef(\stairstep_loop, {
	arg amp = 1, doneAction = 2, out = 0, buf, rate=1, reset = 1, dur =1, length =1, hits=1, seriesArray = #[0,-12,12,0], sliRate=1, lpf= 17000, hpf=20,reldur=1, hs_f=1200,hs_db=0,ls_f=1200,ls_db=0, amp_lag =0, atk=0, rel=100,cur=(-4), pan=0, w=1, w_delay0=0, w_delay1=0, wet=0;
	var root, sig, ptr, ptrInd, noClip, series, bufSup, e;
	var nfilters, shrate, trigFreq, trig;

	//an envelope to avoid .linlin mapping clips of the ptr:
	noClip = EnvGen.kr(Env.new([0,1,0],[reldur*dur/2,reldur*dur/2],[-100,100]),doneAction:2);
	e = EnvGen.kr(Env.perc(atk,rel,1,cur),Impulse.kr(hits/dur));
	//repeating pattern of the pointer + the pointer:
	hits   = hits/rate;
	ptrInd = LFSaw.kr(hits*(1/(dur)),1,0.5/hits,0.5/hits); // this is a copy from below
	series = Dser(seriesArray.midiratio,inf);
	series = Demand.kr(ptrInd-0.01,0,series);
	ptrInd = LFSaw.ar(series*rate*hits*(1/(dur)),1,0.5/hits,0.5/hits);
	// ptrInd = LFSaw.ar(series*rate*hits*0.25,1,0.5/hits,0.5/hits);
	ptr = IEnvGen.ar(Env.new([0,1]),ptrInd).linlin(0,1,(reset-1),reset)/length;
	sig = BufRd.ar(2, buf, ptr*(BufFrames.kr(buf)),0);
	//slicer
	sig = LFPulse.kr(sliRate/(2*dur),0,0.5).lag(0.005)*sig;
	//final configuration
	sig = LPF.ar(sig,lpf);
	sig = HPF.ar(sig,hpf);
	sig = HighShelf.ar(sig,hs_f,1,hs_db);
	sig = LowShelf.ar(sig,ls_f,1,ls_db);
	sig = Width1.ar(sig,w,w_delay0,w_delay1);
	sig = PanStereo.ar(sig,pan);
	sig = sig * amp.lag(amp_lag) * noClip *e;
	root = sig;



	nfilters = 6;
	shrate = \shrate.kr(22050).lag(0.2);
	trigFreq = LFDNoise3.ar(shrate * \jitterScale.kr(1) !2).range(shrate * ( 1 - \jitter.kr(0.1)), shrate);
	trig = Impulse.ar(trigFreq);
	sig = Latch.ar(root, trig);
	sig = Slew.ar(sig, \slewrate.kr(4410), \slewrate.kr);

	nfilters.do { |i| // steep LPF
		sig = LPF.ar(sig, ( shrate * \lpfscale.kr( 0.25 ) ).clip(100, SampleRate.ir * 0.45), mul:1.2).atan;
	};

	sig = Mix([root * ( 1 - wet.abs ), sig * wet  ]);
	Out.ar(out,sig);
}).add;

SynthDef.new(\sampler_loop_old, {
	arg amp = 1, doneAction = 2, out = 0, buf, rate=1, reset = 1, dur =1, length =1, hits=1, seriesArray = #[0,-12,12,0], sliRate=1, lpf= 17000, hpf=20,reldur=1, hs_f=1200,hs_db=0,ls_f=1200,ls_db=0, amp_lag =0, atk=0, rel=100,cur=(-4), pan=0, w=1, w_delay0=0, w_delay1=0;
	var sig, ptr, ptrInd, noClip, series, bufSup, e;
	//an envelope to avoid .linlin mapping clips of the ptr:
	noClip = EnvGen.kr(Env.new([0,1,0],[reldur*dur/2,reldur*dur/2],[-100,100]),doneAction:2);
	e = EnvGen.kr(Env.perc(atk,rel,1,cur));
	//repeating pattern of the pointer + the pointer:
	// hits   = hits/rate;
	ptrInd = LFSaw.kr(hits*(1/(dur)),1,rate/hits,0.5/hits); // this is a copy from below
	series = Dser(seriesArray.midiratio,inf);
	series = Demand.kr(ptrInd-0.01,0,series);
	ptrInd = LFSaw.ar(series*rate*hits*(1/(dur)),1,0.5/hits,0.5/hits);
	// ptrInd = LFSaw.ar(series*rate*hits*0.25,1,0.5/hits,0.5/hits);
	ptr = IEnvGen.ar(Env.new([0,1]),ptrInd).linlin(0,1,(reset-1),reset)/length;
	sig = BufRd.ar(2, buf, ptr*(BufFrames.kr(buf)),0);
	//slicer
	sig = LFPulse.kr(sliRate/(2*dur),0,0.5).lag(0.005)*sig;
	//final configuration
	sig = LPF.ar(sig,lpf);
	sig = HPF.ar(sig,hpf);
	sig = HighShelf.ar(sig,hs_f,1,hs_db);
	sig = LowShelf.ar(sig,ls_f,1,ls_db);
	sig = Width1.ar(sig,w,w_delay0,w_delay1);
	sig = PanStereo.ar(sig,pan);
	sig = sig * amp.lag(amp_lag) * noClip *e;
	Out.ar(out, sig);
}).add;

SynthDef(\stairstep_loop_old, {
	arg amp = 1, doneAction = 2, out = 0, buf, rate=1, reset = 1, dur =1, length =1, hits=1, seriesArray = #[0,-12,12,0], sliRate=1, lpf= 17000, hpf=20,reldur=1, hs_f=1200,hs_db=0,ls_f=1200,ls_db=0, amp_lag =0, atk=0, rel=100,cur=(-4), pan=0, w=1, w_delay0=0, w_delay1=0, wet=0;
	var root, sig, ptr, ptrInd, noClip, series, bufSup, e;
	var nfilters, shrate, trigFreq, trig;

	//an envelope to avoid .linlin mapping clips of the ptr:
	noClip = EnvGen.kr(Env.new([0,1,0],[reldur*dur/2,reldur*dur/2],[-100,100]),doneAction:2);
	e = EnvGen.kr(Env.perc(atk,rel,1,cur));
	//repeating pattern of the pointer + the pointer:
	// hits   = hits/rate;
	ptrInd = LFSaw.kr(hits*(1/(dur)),1,0.5/hits,0.5/hits); // this is a copy from below
	series = Dser(seriesArray.midiratio,inf);
	series = Demand.kr(ptrInd-0.01,0,series);
	ptrInd = LFSaw.ar(series*rate*hits*(1/(dur)),1,0.5/hits,0.5/hits);
	// ptrInd = LFSaw.ar(series*rate*hits*0.25,1,0.5/hits,0.5/hits);
	ptr = IEnvGen.ar(Env.new([0,1]),ptrInd).linlin(0,1,(reset-1),reset)/length;
	sig = BufRd.ar(2, buf, ptr*(BufFrames.kr(buf)),0);
	//slicer
	sig = LFPulse.kr(sliRate/(2*dur),0,0.5).lag(0.005)*sig;
	//final configuration
	sig = LPF.ar(sig,lpf);
	sig = HPF.ar(sig,hpf);
	sig = HighShelf.ar(sig,hs_f,1,hs_db);
	sig = LowShelf.ar(sig,ls_f,1,ls_db);
	sig = Width1.ar(sig,w,w_delay0,w_delay1);
	sig = PanStereo.ar(sig,pan);
	sig = sig * amp.lag(amp_lag) * noClip *e;
	root = sig;

	nfilters = 6;
	shrate = \shrate.kr(22050).lag(0.2);
	trigFreq = LFDNoise3.ar(shrate * \jitterScale.kr(1) !2).range(shrate * ( 1 - \jitter.kr(0.1)), shrate);
	trig = Impulse.ar(trigFreq);
	sig = Latch.ar(root, trig);
	sig = Slew.ar(sig, \slewrate.kr(4410), \slewrate.kr);

	nfilters.do { |i| // steep LPF
		sig = LPF.ar(sig, ( shrate * \lpfscale.kr( 0.25 ) ).clip(100, SampleRate.ir * 0.45), mul:1.2).atan;
	};

	sig = Mix([root * ( 1 - wet.abs ), sig * wet  ]);
	Out.ar(out,sig);
}).add;


SynthDef.new(\latch_loop, {
	arg amp = 1, doneAction = 2, out = 0, buf, rate=1, reset = 1, dur =1, length =1, hits=1, seriesArray = #[0,-12,12,0], sliRate=1, lpf= 17000, hpf=20,reldur=1, hs_f=1200,hs_db=0,ls_f=1200,ls_db=0, amp_lag =0, atk=0, rel=100,cur=(-4), pan=0, w=1, w_delay0=0, w_delay1=0;
	var sig, ptr, ptrInd, noClip, series, bufSup, e;
	var shrate, trig, root;
	//an envelope to avoid .linlin mapping clips of the ptr:
	noClip = EnvGen.kr(Env.new([0,1,0],[reldur*dur/2,reldur*dur/2],[-100,100]),doneAction:2);
	e = EnvGen.kr(Env.perc(atk,rel,1,cur));
	//repeating pattern of the pointer + the pointer:
	ptrInd = LFSaw.kr(hits*(1/(dur)),1,0.5/hits,0.5/hits); // this is a copy from below
	series = Dser(seriesArray.midiratio,inf);
	series = Demand.kr(ptrInd-0.01,0,series);
	ptrInd = LFSaw.ar(series*rate*hits*(1/(dur)),1,0.5/hits,0.5/hits);
	// ptrInd = LFSaw.ar(series*rate*hits*0.25,1,0.5/hits,0.5/hits);
	ptr = IEnvGen.ar(Env.new([0,1]),ptrInd).linlin(0,1,(reset-1),reset)/length;
	sig = BufRd.ar(2, buf, ptr*(BufFrames.kr(buf)),0);
	//slicer
	sig = LFPulse.kr(sliRate/(2*dur),0,0.5).lag(0.005)*sig;


	//latch stuff
	root = sig;
	shrate = Array.fill(8, { |i| \sh_rate.kr(2050) / (i+1) });
	trig = Impulse.ar(shrate);
	sig = [Latch.ar(sig[0], trig),Latch.ar(sig[1], trig)]/2;
	sig = root.blend(Splay.ar(sig[0],0.5,1,0.5)+Splay.ar(sig[1],0.5,1,-0.5),\wet.kr(0.5));


	//final configuration
	sig = LPF.ar(sig,lpf);
	sig = HPF.ar(sig,hpf);
	sig = HighShelf.ar(sig,hs_f,1,hs_db);
	sig = LowShelf.ar(sig,ls_f,1,ls_db);
	sig = Width1.ar(sig,w,w_delay0,w_delay1);
	sig = PanStereo.ar(sig,pan);


	sig = sig * amp.lag(amp_lag) * noClip *e;
	Out.ar(out, sig);
}).add;

SynthDef(\fx_compressor, {
	var local;
	var attack = \attack.kr(0.01);
	var release = \release.kr(0.1);
	var dry, drywet, in, t, o, r, c, e, lookahead;
	var kneelag;
	var bias;
	var sig, car, wet;

	t = \threshhold.kr(-6);

	sig = In.ar(\in.kr(300),2);
	car = In.ar(\in_car.kr(310),2);
	wet = car * \trim.kr(0).dbamp;

	e = wet.mean;

	e = HPF.ar( e, \hpf.kr(50) );
	e = LPF.ar( e, \lpf.kr(15000) );

	e = EnvDetect.ar(e, attack, release);
	// e = e.abs.lagud(attack, release);

	// how much we are over by
	o = e.ampdb.excess(t);

	// scale the excess value by ratio
	r = \ratio.kr(4);
	c = ( max(o, 0.0) ) * (r.reciprocal - 1);

	kneelag = attack * \knee.kr(0.0);

	c = c.lag( kneelag );
	c = c.dbamp;

	lookahead = \lookahead.kr(0);
	wet = DelayC.ar( sig, 0.5, ( attack + release + kneelag * lookahead).lag(0.4) ); // lookahead
	wet = wet * c;
	wet = wet * \gain.kr(0).dbamp;
	bias = K2A.ar(\bias.kr(0.0));

	wet = Select.ar( \saturate.kr(1), [wet, (wet + bias).softclip - bias] );
	wet = LeakDC.ar(wet);

	drywet = \dry_wet.kr(1);
	sig = Mix([
		sig * drywet,
		DelayC.ar( wet * (1 - drywet), 0.5, ( attack + release + kneelag * lookahead).lag(0.4) )
	]);
	sig = sig + car;
	Out.ar(\out.kr(0),sig * \amp.kr(1));
}).add;

);