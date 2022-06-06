(
~bpm=71.04.durtempo;
~load_b.value(\buddha,\bassline);
~load_b.value(\buddha_kit,\drumkit);
~load_b.value(\amen,\amen);
~load_b.value(\record,\record);
);

(
~b0 = Buffer.alloc(s, s.sampleRate * 8 * ~dur,2);
~dur=71.04.durtempo;
SynthDef(\fx,{
	arg blend = 0.2, length=1, duration=0.217375;
	var sig, lfo0, lfo1, rvrb;
	sig  = In.ar(\out.kr(0),2);
	rvrb = sig;
	rvrb = DelayC.ar(rvrb, 0.03,0.03);
	rvrb = HPF.ar(rvrb,80);
	rvrb = NHHall.ar(rvrb,0.3,1,100,0.2,4400,0.66,0.9,0.3);
	rvrb = rvrb + LPF.ar(rvrb,80);
	sig = sig + CombL.ar(HPF.ar(LPF.ar(sig,10000),80),duration,duration,duration*3,0.2);
	// sig = sig + CombL.ar(HPF.ar(LPF.ar(sig,440),220),duration,duration,duration*4,0.4);
	sig = sig.blend(rvrb,blend);
	sig = sig.blend(Width1.ar(sig,1,0.015,0.005),0.1);
	sig = LeakDC.ar(sig);
	// sig = LowShelf.ar(sig,110,1,3);
	ReplaceOut.ar(\out.kr(0),sig* \amp.kr(1));
}).add;

SynthDef(\fx_delay,{
	arg blend = 0.3, length=1, pan0=0, pan1=0;
	var sig, wet;
	sig  = In.ar(\in.kr(330),2);
	wet = PanStereo.ar(CombN.ar(sig,length,length,length*4),pan0)+ DelayN.ar(PanStereo.ar(sig + CombN.ar(sig,length,length,length*3),pan1),length,length);
	wet = HPF.ar(LPF.ar(wet,1233),99);
	sig = sig.blend(wet,blend);
	// sig = sig.blend(Width1.ar(sig,1,0.015,0.005),0.1);
	Out.ar(\out.kr(0),sig* \amp.kr(1));
}).add;

SynthDef(\sin,{
	arg freq=110, amp=0.3, gain=0.7, atk=0.1, rel=4, cur=100, len= 1, t_gate=1, lpf=1290;
	var sig, e, f, wet, count, detect;
	e   = EnvGen.kr(Env.perc(atk, rel, 1, cur),t_gate);
	f   = freq!2;
	detect = In.ar(\in_detect.kr(310),2);
	detect = (EnvDetect.ar(detect, 0.01, 0.1)*20).tanh;

	sig = SinOsc.ar(f);
	sig = sig + SinOsc.ar(f/2,mul:2);
	sig = sig + SinOsc.ar(f/2,mul:sig);
	sig = sig + SinOsc.ar(f*1.5,mul:0.4);
	sig = sig + BPeakEQ.ar(BrownNoise.ar(detect.linlin(0,1,0.3,0.1)!2),f);
	sig = sig+  BPeakEQ.ar(PinkNoise.ar(detect.linlin(0,1,0.3,0.1)!2),f*2);
	sig = sig+BPeakEQ.ar(WhiteNoise.ar(detect.linlin(0,1,0.3,0.1)!2),f/2);

	count = 3;
	wet = DelayC.ar(sig, 0.03, SinOsc.ar(1/len, (0..count - 1) / count * 2pi).linexp(-1, 1, 1e-5, 30e-4)).sum / sqrt(count);
	sig = (sig + (1*wet)) / sqrt(2);
	sig = sig.blend(GuitarAmp.ar(sig,3,0.99,50,2000,f,16),detect.linlin(0,1,1,0));
	sig = sig.blend(Decimator.ar(sig,  detect.linlin(0,1,f*32,f),1),detect.linlin(0,1,0.5,0));
	sig = Width1.ar(sig,1,0,0.01);
	sig = (sig*gain).tanh;
	sig = HighShelf.ar(sig,lpf/2,1,-4);

	sig = RLPF.ar(sig,detect.linlin(0,1,3900,lpf).lag(0.1),0.7);

	sig = RHPF.ar(sig,f/2,0.2);
	sig = sig.blend(HPF.ar(sig,detect.linlin(0,1,10,100)),0.5);
	sig = sig * amp * e;
	Out.ar(\out.kr(0),sig);
}).add;


Pdef(\drums, Pbind(
	\instrument, \sampler,
	\buf, Pswitch(~b[\buddha_kit],Pseq([0,1,0,0,1],inf)),
	\dur, ~dur*Pseq([1,0.5,1,0.5,1],inf),
	\amp,1.2*Pseq([1,0.8,1,0.9,0.8],inf),
	// \lpf, 330,
	\out, 340,
));

~stats_ds = Dictionary.new();
// ~stats_ds[\eqs] =[ 3.0708661417323, 3.8582677165354, -1.496062992126, 2.2834645669291, -1.488188976378, 7.4330708661417, 8.5826771653543, 8.8976377952756 ];
// ~stats_ds[\rq] = 0.6367;
// ~stats_ds[\amp]= 1.09;
// ~stats_ds[\blend]= 1;
~stats_ds[\eqs] = [ 3.3858267716535, 5.9055118110236, 4.9606299212598, 4.9606299212598, 6.6929133858268, 3.5433070866142, 5.1181102362205, -0.078740157480315 ];
~stats_ds[\amp] = 0.74645669291339;
~stats_ds[\blend] = 0.54330708661417;
~stats_ds[\rq] = 1.5612598425197;
Pdef(\dubstep,Pbind(
	\instrument, \sampler_eq,
	\buf, Pswitch(~b[\buddha],Pn(Pseries(0,1,29).clip(0,24))),
	\dur, ~dur*Pseq([
		0.5,0.5,1.75,0.5,0.75,
		0.5,0.5,0.5,0.5,
		1,1,1.5,0.5,
		1.5,2.5,
		3,3,1,2,
		1,1,2,1,1.5,
		0.5,0.5,0.5,0.5,0.5
	],inf),
	\cur, 100,
	\rel, 10,
	\amp, Pfunc{~stats_ds[\amp]},
	\out, 310,
	\eq_db, Pfunc{[~stats_ds[\eqs]]},
	\eq_rq, Pfunc{~stats_ds[\rq]},
	\w0, 0.13,
	\w1, 0.08,
	\wb, 0.2,
	\blend, Pfunc{~stats_ds[\blend]},
));
~subamp=0.05;
Pdef(\sub,Pmono(
	\sin,
	\gate, 1,
	\midinote, Pseq([
		40,43,40,39,
		35,35,37,38,
		40,38,37,33,
		45
	],inf),
	\dur, ~dur*Pseq([
		7,0.5,0.5,3.5,//-0.25
		0.5, //-0.25
		3,1,//-0.25
		7,0.5,0.5,
		3.5, //-0.25,
		0.5,4//-1
	],inf),
	\rel, Pkey(\dur),
	\amp, Pfunc{~subamp},
	\out, 300,
	\duration, ~dur*2,
	\len, ~dur*8,
));




Pdef(\sub2,Pmono(
	\sin,
	\gate, 1,
	\midinote, Pseq([
		40,42,43,
		38,36,34,
		40,44,
	],inf),
	\dur, ~dur*Pseq([
		2,2,2,
		2,4,4,
		2,6,
	],inf),
	\rel, Pseq([
		1,1,1,
		2,4,4,
		2,2
	],inf),
	\amp,0.04,
	\out, 300,
	\duration, ~dur*2,
	\len, ~dur*8,
));


Pdef(\sub3,Pmono(
	\sin,
	\gate, 1,
	\midinote, Pseq([
		59,60,59,59,57,
		Pseq([
			57,63,59,57,59,
			56,63,59,57,63,
		],inf)-[12,0]
	],inf),
	\dur, ~dur*Pseq([
		2,1,1,2,2,
		Pseq([2,0.5,0.5,0.5,0.5],inf)
	],inf),
	\rel, ~dur*Pseq([
		2,1,0.75,2,1.5,
		Pkey(\dur,5)
	],inf),
	\amp,[0.03,0.01]*Pseq([Pseries(0.05,0.05,5),Pseq([1],inf)],inf),
	\out, 300,
	\len, ~dur*8,
));


SynthDef(\guitar_buddha,{
	arg amp=1, out=0, amount = 0.1, hi_f = 440, hi_db =3, lo_f =165, lo_db =(-0.5), blend = 0.125,length = 0.844, length_mult =8, blend_dist =0.02;
	var sig, wet;
	sig = (SoundIn.ar(0)!2);

	sig = (sig*\pre_gain.kr(20)).tanh;
	sig = GuitarAmp.ar(sig,1,amount);

	sig = LPF.ar(sig,\lpf.kr(10000));
	sig = HighShelf.ar(sig,hi_f,1,hi_db);
	sig = LowShelf.ar(sig,lo_f,1,lo_db);
	sig = BPeakEQ.ar(sig,\p_f.kr(1200), \p_rq.kr(1), \p_db.kr(0));

	wet = LPF.ar(DelayN.ar(sig+CombL.ar(sig,length,length,length*8),length/2,length/2))+CombL.ar(HPF.ar(sig),length,length,length*length_mult);
	wet = HPF.ar(LPF.ar(wet,6000),100);
	sig = sig.blend(wet,blend);
	sig =  HPF.ar(sig, 80);
	sig = sig+Reflector.ar(sig*1,5);
	sig = sig+HPF.ar(Width1.ar(sig,1,0.01,0.02),100,0.1);
	sig = ((sig*\post_gain.kr(1)).tanh)*amp;
	Out.ar(out,sig);
}).add;
/*SynthDef(\guitar_buddha,{
	arg amp=1, out=0, amount = 0.5, hi_amp =4, lo_amp =(-2), blend = 0,length = 0.844, blend_dist =0.02;
	var sig, wet;
	sig = (SoundIn.ar(0)!2);

	sig = (sig*\gain.kr(20)).tanh;
	sig = sig.blend(LPF.ar(LowShelf.ar(GuitarAmp.ar(sig,1,amount,meqa:15),330,1,-5),5000),blend_dist);
	sig = LPF.ar(sig,\lpf.kr(10000));
	sig = HighShelf.ar(sig,880,1,hi_amp);
	sig = LowShelf.ar(sig,220,1,lo_amp);
	wet = LPF.ar(DelayN.ar(sig+CombL.ar(sig,length,length,length*8),length/2,length/2))+CombL.ar(HPF.ar(sig),length,length,length*8);
	wet = HPF.ar(LPF.ar(wet,6000),60);
	sig = sig.blend(wet,blend);
	sig = HPF.ar(sig,\hpf.kr(90));
	sig = LowShelf.ar(sig,109,1,-1.5);
	sig = BPeakEQ.ar(sig,\p_f.kr(1200), \p_rq.kr(1), \p_db.kr());
	sig = sig+Reflector.ar(sig*1,5);
	sig = (sig.tanh)*amp;
	Out.ar(out,sig);
}).add;*/

)

(
/*
SynthDef(\fx_comp,{
	arg cgain=25, catk=0.01, crel=0.1, ctresh=0.5, cabove= 0.0;
	var sig, car;
	sig = In.ar(\in.kr(300),2);
	car = In.ar(\in_car.kr(310),2);
	// sig = Compander.ar(sig,(car*cgain).tanh,ctresh,1,cabove,catk,crel);
	// sig = Compressor.ar(sig,(car*cgain).tanh,catk,crel,ctresh,cabove);
	sig = CompressorReflectivesCar.ar(sig,(car*cgain).tanh,catk,crel,ctresh,0,50,cabove);
	sig = sig + car;
	Out.ar(\out.kr(0),sig);
}).add;

SynthDef(\sin,{
	arg freq=110, amp=0.3, gain=1, atk=0.01, rel=4, cur=4, len= 1, t_gate=1, lpf=1000;
	var sig, e, f, wet, count;
	e   = EnvGen.kr(Env.perc(atk, rel, 1, cur),t_gate);
	f   = freq!2;
	sig = SinOsc.ar(f);
	sig = sig + SinOsc.ar(f/2,mul:2);
	sig = sig + SinOsc.ar(f/2,mul:sig*2);
	sig = sig + SinOsc.ar(f*1.5,mul:0.4);
	sig = sig + SinOsc.ar(f*5,mul:0.1);
	sig = sig + SinOsc.ar(sig*f*5,mul:0.4);
	sig = sig + SinOsc.ar(f*16,mul:0.01);
	sig = sig + SinOsc.ar(f*12,mul:0.03);
	sig = sig.blend(AnalogVintageDistortion.ar(sig*0.3,1,0.3,0.03,0.3,f*8),0.5);


	count = 3;
	wet = DelayC.ar(sig, 0.03, SinOsc.ar(1/len, (0..count - 1) / count * 2pi).linlin(-1, 1, 1e-4, 5e-4)).sum / sqrt(count);
	sig = (sig + (1*wet)) / sqrt(3);

	sig = Width1.ar(sig,1,0,0.01);
	sig = (sig*gain).tanh;
	sig = LPF.ar(sig,lpf);
	sig = RHPF.ar(sig,f/2,0.3);
	sig = sig * amp * e;
	Out.ar(\out.kr(0),sig);
}).add;


a = Pmono(
	\sin,
	\gate, 1,
	\midinote, Pseq([
		40,43,40,39,
		35,35,37,38,
		40,38,37,33,
		45
	],inf),
	\dur, ~bpm*Pseq([
		7,0.5,0.5,3.5,//-0.25
		0.5, //-0.25
		3,1,//-0.25
		7,0.5,0.5,
		3.5, //-0.25,
		0.5,4//-1
	],inf),
	\cur, 100,
	\atk, 0.1,
	\rel, Pkey(\dur),
	\amp,0.2,
	// \out, 300,
	\duration, ~bpm*2,
).play(quant:0);
)

*/