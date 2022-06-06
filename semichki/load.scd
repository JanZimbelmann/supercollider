MIDIdef.trace(false)
m = MIDIOut(0);
m.connect(0);
m.program(3,0);
s.scope
~load_b.value(\metal,\metal);
~b[\metal][0]
//load twice~

(
~amps= Dictionary.new();
~amps[\clean] = 0.37;
~amps[\dist0] = 0.31;
~amps[\dist1] = 0.245;
~amps[\chor] = 0.48;
~amps[\drum] = 0.5775;
~amps[\bass0] = 0.08;
~amps[\bass1] = 0.225;
~amps[\bass2] = 0.215;
~amps[\pad0] = 0.24;
~amps[\pad1] = 0.21;
~amps[\full] = 0.5;

~dur=0.16;
~slice = 16;
~b0 = Buffer.alloc(s, s.sampleRate * 30 * 2 * ~dur,2);
~stage = 0;
~setter_idx=0;
~setter = [];
~setter = ~setter ++ [[
	\reset, Place([1,13,14,12,4,11,2,10,10,6,11,7,6,7,8],inf),
	\amp, Pfunc{~amps[\drum]}*Pbjorklund(4,5).linlin(0,1,0.2,1)*Pseq([1,0.8,0.8],inf)*Pseq([1.1]++(1!8)++[0]++(1!5),inf)*Pseq([1,0.93,0.93,0.93,0.95],inf),
	\hits, Prand([1,1,1,2,3],inf),
	\seriesArray, Prand([[[0,12,0,0]],[[0,-1,1,0]]],inf),
	// \lag, Pseq([0,0,0,0,0.1],inf),
	\lpf, Pseq([15000,15000,15000,15000,2000],inf),
	\hpf, Pseq([30,1000,30,50,30],inf),
	]];
~setter = ~setter ++ [[
	\reset, Pswitch1([1,Place([[6,15],[7,11,16,14],[8,12,15]],inf)],Pseq([0,1,0]++(1!12),inf)),
	\amp, Pfunc{~amps[\drum]}*Pseq([1,0.85,0.92,0.85,0.92],inf),
	\hits, Prand([1,2,3,4,1,5,2,1],inf),
	\seriesArray, Prand([[[0,-1,-2,-3]],[[0,-2,-4,-6]],[[0,-7,-12,-18]],[[0,-12,-24,12]]],inf),
	\lpf, Pseq([9500,5500],inf),
	// \lag, -0.02,
	\sliRate, Place([1,1,[4,6,8],1,2],inf),
	// \hpf, Pseq([130,1000,130,150,130],inf),
]];
Pdef(\drum,Pbind(
	\instrument, \sampler_loop_old,
	\buf, Pstutter(3,Pwrand([~b[\metal][5],~b[\metal][0]],[0.7,0.3],inf)),
	\length, ~slice,
	\gate,1,
	\dur, ~dur*32/~slice,
	\rate, Pwhite(0.95,1.05),
	\reldur, 0.95,
	\hs_db, 3,
	\setter, Prout(~rout),
	// \lag, -0.03,
));
Pdef(\bass0,Pbind(
	\instrument, \bsz,
	\dur, ~dur*Pbjorklund2(4,5),
	\freq, 110,
	\rel, 1
	*Pseq([1,0.3,0.25,0.3],inf),
	\lpf, 180*Pn(Pgeom(1.0,1.23,24))*Place([1,0.1,0.2],inf),
	\hpf, Pfunc{~bass0_hpf},
	\ff0, Pn(Pseries(1,1.2,24))*Pseq([500,100,1300],inf),
	\ff1, Pn(Pseries(3,-0.1,24))*Pseq([2000,50,3600],inf),
	\bwf0, 4500,
	\bwf1, 2400,
	\cur, Pseq([-2,-2,4],inf),
	\amp, [0,1]*Pfunc{~amps[\bass0]}*Pseq([1,0.8,0.8,0.8],inf)*Pseq([1]+(0.8!15),inf),
));
Pdef(\bass1,Pbind(
	\instrument, \bsz,
	\dur, ~dur*Pseq([20,10/3,10/3,10/3],inf),
	\midinote, Pseq([
		49,54,56,57,
		47,57,56,52,
	],inf)-12,
	\atk, ~dur*3,
	\rel, Pkey(\dur)-Pkey(\atk),
	\cur, 3,
	\amp, Pfunc{~amps[\bass1]},
	\ff0, Pexprand(10.0,1000.0),
	\ff1, Pexprand(10.0,1000.0),
	\bwf0, Pexprand(10.0,3000.0),
	\bwf1, Pexprand(10.0,1000.0),
	\lpf, 1890,
	\hidb, 5,
));

Pdef(\bass2,Pbind(
	\instrument, \bsz,
	\dur, ~dur*Pseq([30],inf),
	\midinote, Pseq([30,32+12],inf),
	\atk, ~dur*7,
	\rel, Pkey(\dur)-Pkey(\atk),
	\cur, 1,
	\amp, Pfunc{~amps[\bass2]},
	\ff0,  1000,
	\ff1,  200,
	\bwf0, 100,
	\bwf1, 1000,
	\lpf, Pseq([1090,1500],inf),
	\boost, Pseq([2,2],inf),
	\hidb, Pseq([3,1],inf),
	\lodb, 0,
	\line_start, Pseq([2,0.5],inf),
	\line_dur, 15*~dur,
	\line_cur, Pseq([3,0],inf)
));

Pdef(\pad0,Pbind(
	\instrument, \pad,
	\lag, ~dur,
	\dur, ~dur*30,
	\atk, Pkey(\dur)-Pkey(\lag),
	\cur, 4,
	\rel,0.05,
	\midinote, Pseq([[54,56,61,69,73,78],[53,56,61,68,72,75]],inf),
	\amp, Pfunc{~amps[\pad0]}*Pseq([1],inf),
));
Pdef(\pad1,Pbind(
	\instrument, \pad,
	\lag, 0,
	\dur, ~dur/2,
	// \atk, Pkey(\dur),
	\cur, Pseq([1,-1],inf)*(3+Pwhite(-1.0,1.0)),
	\atk, 0,
	\rel, 0.7*Pstutter(2,Place([[0.2,0.1],[0.1,0.05],[0.05,0.1]],inf)),
	\midinote, Pstutter(30,Pseq([[54,56,61,69,73,78],[54,56,61,69,73,78],[54,66,61,68,73,77],[53,66,61,68,75,77]],inf)),
	\amp, Pfunc{~amps[\pad1]}*Pstutter(2,Pseq([1,0.5,0.3,0.7,0.5],inf))*Pseq([1,Pwhite(0.0,0.8,1)**2],inf)*Pstutter(2,Pseq([1]++(0.7!14),inf)),
	\pitch_dur, Pkey(\rel),
));



SynthDef(\guitar_semichki,{
	arg amp=1, out=50, gain=1, amount = 0.5, hi_amp =10, blend = 0, wet=0.1, del_dist =0.018;
	// arg amp=0.9, out=50, gain=10, amount = 0.99, hi_amp=(-3), blend=0, wet=1;
	var sig, root, decimator;
	root = (SoundIn.ar(0)!2)*9;
	sig = root;
	sig = Compander.ar(sig,sig,0.5,1,0.3);
	sig = HPF.ar(sig,80);
	sig = BLowShelf.ar(sig,440,1,MouseX.kr(0,-10));
	sig = Compander.ar(sig,sig,0.5,1,0.3);
	sig = sig+Reflector.ar(sig*2,10);
	// sig = (sig*gain).tanh;
	sig = sig*gain;
	sig = sig.blend(GuitarAmp.ar(sig,1,amount),wet);
	sig = sig + CombC.ar((sig*15).tanh,~dur*30,~dur*5,~dur*30,del_dist);
	sig = sig + CombC.ar(LPF.ar(sig,~dur*30),[~dur*3,~dur*2],15*~dur,0.6);
	sig = sig + CombC.ar(HPF.ar(sig),~dur*30,~dur,15*~dur,0.7);
	decimator = sig;
	decimator = decimator.blend(PitchShift.ar(decimator,0.1,2,0.0,0.1),0.3);
	// decimator = decimator.blend(PitchShift.ar(decimator,0.1,2,0,0.1),0.3);
	decimator = decimator.blend(DelHarm.ar(decimator,12,0.2),0.3);
	// decimator = PitchShift.ar(decimator,0.1,2);
	decimator = Decimator.ar(decimator*100,5000,1,1);
	decimator = Compander.ar(decimator,root,0.3,2,1,0.01,0.03,0.3);
	sig = sig.blend(decimator, blend);
	sig = (sig).tanh;
	sig = LPF.ar(sig,10000);
	sig = BHiShelf.ar(sig,700,1,hi_amp);
	sig = Compander.ar(sig,root,0.01,2,1,0.01,0.3);
	sig = (sig.tanh)*amp;
	Out.ar(out,sig);
}).add;




SynthDef(\bsz,{
	arg freq=110, amp=0.3, atk=0.01, rel=1, cur=(-1), lpf=2400,
	ff0= 100,ff1=2400,bwf0=100,bwf1=2400, hidb=(-2), lodb=(0), boost=1, hpf=10,line_start=1,line_end=1,line_dur=0,line_cur=3;

	var sig, e, f;
	e   = EnvGen.kr(Env.perc(atk, rel, 1, cur),doneAction:2);
	f   = freq*SinOsc.kr(4,0,0.01*e,1);
	f   = f*(Line.kr(0,1,line_dur)**line_cur).linlin(0,1,line_start,line_end);

	sig = SinOsc.ar(f,e**1.7)+SinOsc.ar(f/2,0,e**1.9);
	sig = sig + LFSaw.ar(f*sig.range(0.0,1),mul:1);
	sig = sig + Formant.ar(f,e.linlin(0,1,ff0,ff1),e.linlin(0,1,bwf0,bwf1));

	sig = (sig*3).tanh!2;
	sig = RLPF.ar(sig,e.linlin(0,1,f,lpf));
	sig = HPF.ar(sig,hpf);
	sig = (sig + RLPF.ar(sig,lpf))/2;
	sig = HighShelf.ar(sig,2440,3,hidb);
	sig = LowShelf.ar(sig,140,3,lodb);
	sig = BPeakEQ.ar(sig,f,2,boost*(e**0.5));
	sig = sig * amp * e;
	Out.ar(\out.kr(0),sig);
}).add;

SynthDef(\pad,{
	arg pitch_dur=5;
	var sig, f, w, e;
	e   = EnvGen.kr(Env.new([0,\lev.kr(0),1,0],[0,\atk.kr(1),\rel.kr(0)],\cur.kr(0)),doneAction:2);
	f   = \freq.kr(440)* (LFNoise2.kr(6!4)*0.5*Sweep.kr(\t_gate.kr(1),1/pitch_dur).clip(0,1)).midiratio;
	w   = 0.5+(0.3*LFNoise2.kr(0.3));
	sig = Pulse.ar(f,w);
	sig = Splay.ar(sig);
	sig = LPF.ar(sig, \freq.kr(440)*4);
	sig = sig * e;
	Out.ar(\out.kr(0),sig*\amp.kr(0.2));
}).add;

SynthDef(\vocal_semichki,{
	arg out=0,amp=0.9,gain=50;
	var sig, root;
	root = (SoundIn.ar(1)!2)*gain;
	root = root.tanh;
	sig = root;
	// sig = sig.tanh;
	sig = Compander.ar(sig,sig,0.05,2,1);
	sig = HPF.ar(sig,100);
	sig = BLowShelf.ar(sig,330,1,-5);
	// sig = BLowShelf.ar(sig,180,1,-5);
	sig = BHiShelf.ar(sig,1200,1,2);
	// sig = BPeakEQ.ar(sig,4000,2.5,-4);
	sig = Compander.ar(sig,sig,0.95,1,0.3);
	sig = sig.blend(GuitarAmp.ar(sig,hpf:130,mul:0.3),0.9);
	sig = Compander.ar(sig,root,0.1,3);
	sig = sig + DelayC.ar(LPF.ar(HPF.ar(sig,4960),216),0.1,0.1,0.75);
	sig = sig + Reflector.ar(sig,5,0.02,2);
	sig = (sig).tanh;
	sig = sig*amp;
	Out.ar(out,sig);
}).add;

SynthDef(\fx,{
	var sig;
	sig = In.ar(\out.kr(0),2);
	sig = sig.blend(NHHall.ar(sig.blend(GuitarAmp.ar(sig,0.1,lpf:1000),0.2),0.63,0.95,130,0.5,5000,0.5,0.75,0.65,0.6));
	// sig = sig.blend(GuitarAmp.ar(sig,0.1,lpf:1000),0.05);
	ReplaceOut.ar(\out.kr(0),sig*~amps[\full]);
}).add;

~ctrl = Dictionary.new;
~ctrl[\amp] = 0.4;
~ctrl[\amp_exp] = 0.5;
~ctrl[\buf_weight] = 0.5;//buf ratio
~ctrl[\lpf] = 17000;
~ctrl[\hpf] = 20;

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
			val = vals[~setter_idx];
			ev.putAll(val);
			ev = 1.yield;
		}
};
)





