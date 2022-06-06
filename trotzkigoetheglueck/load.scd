
~midi.value()

MIDIdef.trace(true)
(
~load_b.value(\piano,\quiet_update);
~load_b.value(\bass,\bass);
~load_b.value(\bass2,\bass2);
~load_b.value(\jazz,\jazz);
~load_b.value(\records,\records);
~a = Buffer.readChannel(s,
	"/home/kaoboi/studio/sanmples/camo.wav",
	// "/mnt/4/sound/Drumdrops Drops In The Bronx/BRONXDROPS-WAV/96-99 bpm/99-RBRK-04.wav",
	// channels:0
~setting = 1;
);
)
(
~dur= 0.8695/2;
~slice = 8;
~bass = [~b[\bass][0],~b[\bass][1],~b[\bass][2]];
~bass = ~bass ++ ~b[\bass2];
~p = Dictionary.new;
~p[\amp] = 0.8;
~p[\buf] = ~b[\piano];
~p[\lo_db] = 6;
~p[\hi_db] = 6;
~out = Dictionary.new;
~out[\piano] = 500;
~vamp = 1;

SynthDef(\sampler_trotzki,{
	arg out=0,buf=0, amp=1, atk=0.01, rel=2, cur=3,
	rate=1, start=0, end=1, pan=0, lpf=18000, hpf=100, gain=1,
	ls_f = 220, ls_db =0, hs_f=2400, hs_db =0, hits=1, hits_dur=1, rq=0.5,lfo0_d=0,lfo0_min=10000, lfo0_p=0, lfo0_max=10000, sli_dur = 100, sli_amp =0,sli_lag=0;
	var sig, ptr, hitter, lfo0;

	e = EnvGen.kr(Env.perc(atk,rel,1,cur),doneAction:2);
	hitter = Impulse.kr(hits/hits_dur)*Line.kr(1,0,hits_dur);
	sig = PlayBuf.ar(2,buf,BufRateScale.kr(buf)*rate,hitter,start);

	sig = (gain*sig).tanh;
	lfo0= SinOsc.ar(1/lfo0_d,((lfo0_p+0.25)*2*pi)).range(lfo0_min,lfo0_max);
	sig = RLPF.ar(sig,lfo0,rq);
	sig = LPF.ar(sig,lpf);
	sig = HPF.ar(sig,hpf);
	sig = LowShelf.ar(sig,ls_f,1,ls_db);
	sig = HighShelf.ar(sig,hs_f,1,hs_db);

	sig = Balance2.ar(sig[0],sig[1],pan);

	sig = sig * LFPulse.kr(1/sli_dur).range((1-sli_amp),1).lag(sli_lag);
	sig = sig * e * amp;
	Out.ar(out,sig);
}).add;

~bass0 = Pbind(
	\instrument,\sampler_trotzki,
	\buf,Pswitch(~bass,Pseq([0,1,2,2],1)),
	\dur, ~dur*Place([12,4,2,2],inf),
	// \sliRate, 3,
	\gain, Pseq([2,1,1,1],inf),
	\rel, ~dur*Place([[12,4],2,2,2],inf),
	// \cur, 10,
	\rate, Pseq([1,0.5,1,1],inf),
	\pan, Pseq([0,0,-0.5,0.5],inf),
	\amp, 0.3 * Pseq([1,1,1,1],inf),
	\hpf, 50,
	\hs_f, 5000,
	\lfo0_d, Pseq([8,0.5,0.5,0.5],inf),
	// \lfo0_d, Pkey(\rel).trace,
	\lfo0_min, 666,
	\lfo0_max, Pseq([2660,6000,6000],inf),
	\lfo0_p, Pseq([0,0.5,0.5,0],inf),
	\rq, 0.3,
	\sli_dur, ~dur*Pseq([24,24,24,1/6],inf),
	\sli_amp, 1,
	\sli_lag, 0.01,
	\atk, Pseq([0.3,0,0,0],inf),

	\cur, \sine,
	\hs_db, Pseq([-5,0,0,0],inf),
	\hits_dur, ~dur*0.5,
	\hits, Pseq((1!6)++[5,3],inf),
	\out, 310,
);

~bass1 = Pbind(
	\instrument,\sampler_trotzki,
	\buf,Pswitch(~bass,Pseq([3,3,3,4],1)),
	\dur, ~dur*Place([4,2,4,4],inf),
	// \sliRate, 3,
	\rate, Pseq([1,2,1,2],inf),
	\gain, Pseq([2,1,1,1],inf),
	\rel, ~dur*Place([4],inf),
	// \cur, 10,
	\pan, Pseq([-0.6,0.6,0,0],inf),
	\amp, 0.3 * Pseq([1,1,1,1],inf),
	// \hpf, 150,
	\hs_f, 5000,
	\lfo0_d, Pseq([8,0.5,0.5,0.5],inf),
	// \lfo0_d, Pkey(\rel).trace,
	\lfo0_min, 666,
	\lfo0_max, Pseq([4500,6000,6000],inf),
	\lfo0_p, Pseq([0,0.5,0.5,0],inf),
	\rq, 0.3,
	\sli_dur, ~dur*Pseq([24,24,24,1/6],inf),
	\sli_amp, 1,
	\sli_lag, 0.01,
	\cur, \sine,
	\hs_db, Pseq([-5,0,0,0],inf),
	\hits_dur, ~dur*2,
	\hits, Pseq([1,4,1],inf),
	\out, 310,
);
Pdef(\bass,Pseq([~bass0,~bass1]));

SynthDef(\slidebass,{
	arg freq=110, amp=0.3, atk=0.01, rel=1, cur=(-4), dec = 0.01, t_gate=1, lev=1, lg=1, lg_e=0.1, len = 0.2, dist_amp = 0.3, hld=0.1;
	var sig, e, f, dist, wet, count, elinlin;
	// e   = EnvGen.kr(Env.perc(atk, rel, lev, cur),t_gate.poll);
	e   = EnvGen.kr(Env.new([0,0,lev,lev,0],[0,atk,hld,rel],cur),t_gate).lag(lg_e);
	f   = SinOsc.kr(1/len,0,0.01,1)*freq.lag(lg);
	elinlin = e.linlin(0,lev,0,1);
	sig = SinOsc.ar(f,mul:2);
	sig = sig + SinOsc.ar(f*2,mul:0.5);
	sig = sig + SinOsc.ar(f*1.5,mul:0.2);
	sig = sig + SinOsc.ar(f/1.5,mul:0.2);
	sig = sig + SinOsc.ar(f*3,mul:0.3);
	sig = sig + SinOsc.ar(f*5,mul:0.1);
	sig = sig + SinOsc.ar(f*4,mul:0.2);
	sig = sig + SinOsc.ar(f/2,mul:0.5);
	sig = sig!2;

	// dist = Pulse.ar(f!2);
	dist = sig;
	dist = sig + GuitarAmp.ar(dist,meqf:f*2,meqa:8,mul:elinlin);
	dist = (dist*5).tanh;
	dist = LPF.ar(dist,(e**0.2).linlin(0,lev,1000,6000));
	dist = dist + RHPF.ar(CombC.ar(dist,len*2,len*e.linlin(0,lev,2,1),len*12,0.3),e.linlin(0,lev,f*8,f),0.1);
	// dist = dist.fold(MouseX.kr(-1.0,1.0), MouseY.kr(-1.0,1.0));
	dist = dist + HPF.ar(LPF.ar(Decimator.ar(dist,(f*64),1,2*elinlin),f*24),110);
	dist = (dist*0.3).tanh;

	sig = (sig*(1-(dist_amp*elinlin))) + (dist_amp*dist);

	// sig = HighShelf.ar(sig,f*6,1,-1);
	// sig = LPF.ar(sig,(f*64).clip(1000,10000));
	count = 3;
	wet = DelayC.ar(sig, 0.03, SinOsc.ar(len, (0..count - 1) / count * 2pi).linlin(-1, 1, 10e-3, 20e-3)).sum / sqrt(count);
	sig = (sig + (2*wet)) / sqrt(3);
	// sig = sig + HPF.ar(LPF.ar(Decimator.ar(sig,(f*36),1,1*elinlin),f*48),110);
	sig = BPeakEQ.ar(sig, (f*24).clip(100,20000),4,5);
	sig = sig + Width1.ar(HPF.ar(sig,400,1+e),1,0.01);
	// sig = sig + HPF.ar(LPF.ar(Decimator.ar(sig,(f*12),1,1*elinlin),f*48),110);
	// sig = HighShelf.ar(sig,f*4,1,-4);
	// sig = HighShelf.ar(sig,f*16,1,-4);
	sig = (sig *(1+e)).tanh * amp.lag(lg);

	sig = HPF.ar(sig,20);
	Out.ar(\out.kr(0),sig);
}).add;

Pdef(\sub,Pmono(
	\slidebass,
	\gate, Pseq([1,0,1,0],inf),
	\midinote, Pseq([
		51,55,51,55,
		53,50,
		48,
		// 53, 54, 56,
		12
	],1)-12,
	\dur, ~dur * Pseq([
		6,6,6,12,
		6,12,
		6,
		// 2,2,2,
		2
	],inf)//+Pseq([0-~dur/2]++(0!6)++[~dur/2],inf)
	,
	\rel, 0.1,
	\hld, ~dur*Pseq([0 , 0, 0, 0, 0, 0,0,0],inf),
	\atk, ~dur*Pseq([12,12,18,18,15,15,0.5,0.5]-0.5,inf),
	// \atk, ((Pkey(\dur)-Pkey(\rel)-Pkey(\hld))).clip(0,~dur*7),
	// \cur, Pseq([3,3,3,-1,3,3,3,3],inf),
	\cur, \sine,
	\amp, 0.05*Pseq([1,0.7],inf),
	\lg, ~dur*Pseq([1,1,1,1,2,1.5,1,4],inf),
	\lg_e, 0.03,
	// \lag, Pseq([0,Pseq([~dur],inf)]),
	\len, ~dur/6,
	\out, 300,
));

SynthDef(\anotherbass,{
	arg freq=110, amp=0.3, atk=0.01, rel=1, cur=(-4);
	var sig, e, f;
	e   = EnvGen.kr(Env.perc(atk, rel, 1, cur),doneAction:2);
	f   = freq!2;
	sig = SinOsc.ar(f);
	sig = sig.blend(SineShaper.ar(SinOsc.ar(sig*f).range(985,1000)),0.1);
	sig = HighShelf.ar(sig, 69, 2, -4);
	sig = sig * amp * e;
	Out.ar(\out.kr(0),sig);
}).add;

Pdef(\nother,Pbind(
	\instrument, \anotherbass,
	// \gate, Pseq([1,0,1,0],inf),
	\lag, ~dur*4,
	\midinote, Pseq([
		57,57,53,51,50,53,59
	])-24,
	\dur, ~dur * Pseq([
		12,2,12,8,8,8,5
	],inf),
	\rel, Pkey(\dur),
	// \rel, ~dur*Pseq([12,2,8,2,8],inf),
	\cur, 10*Pseq([1,1,1,1,1,1,10]),
	\amp, 0.4,
	\len, ~dur/6,
));

SynthDef(\voc,{
	arg out = 0, in=1, amp=0.7, gain=60, len=0.25*~dur;
	var sig;
	sig = SoundIn.ar(in)!2*gain;
	sig = Compander.ar(Compander.ar(sig,sig,0.5,1,0.75),sig,0.8,1,0.75);
	sig = sig.tanh;
	sig = LowShelf.ar(sig,333,1,-4);
	sig = BPeakEQ.ar(sig, 3600,5,5);
	sig = HighShelf.ar(sig,6800,1,-2);
	sig = sig.blend(DelayN.ar(sig,len,len),0.2);
	sig = sig.blend(4*Reflector.ar(LPF.ar(sig,4000),scaleDelays:1),0.3);

	sig = sig * amp;
	Out.ar(out,sig)
	// sig = FreeVerb.ar(sig);
}).add;



Pdef(\break,Pbind(
	\instrument, \stairstep_loop_old,
	// \instrument, \sampler_loop,
	\buf, Pstutter(8,Pseq([~a],inf)),
	\length,~slice,
	\gate,1,
	// \lag, ~dur*7,
	\rate, Pstutter(6,Pseq([1,1,0.5,0.25,0.75,0.75,0.5,0.5,0.25,0.125],inf)),
	\reset, Pseq([1,2,4,5,6,7,8,8],inf),
	\dur, ~dur*8/~slice,
	// \amp, 0.7,
	// \amp, 0.6 * Pseq((1!12)++(0.7!12)++(0.5!32),inf)*(Place([[1,0.4],0.5,0.8,[0.7,0.4]],inf) * Pseq((1!32)++Pseries(0.5,-0.4/32,32),inf)*Pseq((1!4)++[Pseries(0.35,0.5/8,4)],inf))**0.6,
	\amp, 0.4 *Pseq((1!12)++(0.75!18)++(0.5!26),inf) * Pseq((1!4)++(0.7!4),inf),
	\wet, 0.6*Pseq([0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1],inf)**0.4,
	// \pan, Pfunc{|ev| if(ev[\amp]<0.2){0.3}{0.2}}*Prand([-1,1],inf),
	\pan, Pseq([Pwhite(0.0,0.1,4),Pwhite(0.3,0.5,4)],inf)*Pseq([1,-1],inf),
	\reldur, 0.8,
	\hits,
	1
	*Pseq([Pseq([1,1,Pwhite(5,6,2),1,1,1,Pwhite(10,40,1)],1),Pseq([1],inf)])
	*Place([[1,1],1,1,[2,3,4,5]],inf)
	*Pstutter(8,Pseq([1,1,2,2,3,3,6],1))
	,
	\seriesArray, Pstutter(32,Pseq([[[0,1,2,-5]],[0,-2,5,1]],inf)),
	\lpf, 0.8*Pseq([3000,5000,4000,5000],inf),
	\hpf, Pseq((150!8)++(300!4),inf),
	\slewrate, Pwhite(5000,30000),
	\shrate, 21000-Pexprand(8000,1000),
	\jitterScale, Pstutter(8,Pwhite(0.2,2)),
	\jitter, 1,
	\lpfscale, Pwhite(0.2,0.8),
	\hs_f, 1500,
	\hs_db, -1,
	\ls_f, 220,
	\ls_db, 3,
	\out, 320,
));

SynthDef(\piano_sampler,{
	arg freq, buf, gate=1, amp=1, amp2=0.4, pan=0, hi_f=800, hi_db=0, lo_f=440, lo_db=0;
	var sig;
	sig = PlayBuf.ar(2, buf)*0.65;
	sig = EnvGen.kr(Env.adsr(0.01,0.3,1,0.4,1,-4),gate,doneAction: 2) * sig;
	sig = Compander.ar(sig,sig,0.7,1,0.4);
	sig = HighShelf.ar(sig,hi_f,1,hi_db);
	sig = LowShelf.ar(sig,lo_f,1,lo_db);
	sig = HPF.ar(sig,70);
	sig = LPF.ar(sig,10000);
	Out.ar(\out.kr(0), PanStereo.ar(sig,pan,amp*amp2));
}).add;



~piano = {
// Synth.tail(nil,\fx);
~keys  = Array.newClear(128);
~pedal = Array.fill(128,0);

MIDIdef.sysex(\piano_volume,{
	|array|
	~p[\amp]=array[6]/127;
	~p[\amp].postln;
});
MIDIdef.cc(\piano_control,{
	|vel,ch,nn|
	var db;
	if(nn==1){
		db = vel.linlin(0,127,-12,12);
		~p[\lo_db] = db;
	};
	if(nn==2){
		db = vel.linlin(0,127,-12,12);
		~p[\hi_db] = db;
	};
},7);

MIDIdef.cc(\notePedal,{
	arg vel, nn, ch;
	if((ch==4) && (nn ==64)){
		if(vel==127){
			~pedal = ~pedal+1;
		}{
			~pedal = ~pedal-1;
			128.do{|i|
				if((~pedal[i]==0)&&(~keys[i].notNil)){
					~keys[i].release;
					~keys[i] = nil;
				}
			};
		}
	}
});
MIDIdef.noteOn(\noteOn,{arg vel, num, chan;
	var node, nn;
	nn = num-23;
	if(~keys[nn].notNil){
		~keys[nn].release;
		~keys[nn] = nil;
		};
	~keys[nn] = Synth(\piano_sampler, [\buf, ~p[\buf][nn], \amp, (vel/127)**2 * ~p[\amp],\lo_db,~p[\lo_db],\hi_db,~p[\hi_db],\out,~out[\piano]]);
	// ~b[\piano][nn].path.postln;
	~pedal[nn] = ~pedal[nn]+1;
	[nn,vel/127].postln;
});

MIDIdef.noteOff(\noteOff,{
	arg vel, num, ch;
	var node, nn;
	nn = num-23;
	~pedal[nn] = ~pedal[nn]-1;
	if((~keys[nn].notNil) && (~pedal[nn]==0)){
		~keys[nn].release;
		~keys[nn] = nil;
	};
});
};





SynthDef(\fx,{
	arg blend = 0.2, length=1, duration=0.217375;
	var sig, lfo0, lfo1, rvrb;
	sig  = In.ar(\out.kr(0),2);
	rvrb = sig;
	rvrb = HPF.ar(rvrb,80);
	rvrb = NHHall.ar(rvrb,1,0.7,100,0.6,3400,0.3,0.8,0.6,0.1);
	rvrb = rvrb + LPF.ar(rvrb,80);
	sig = sig + CombL.ar(HPF.ar(LPF.ar(sig),80),duration,duration,duration*3,0.35);
	sig = sig + CombL.ar(HPF.ar(sig),duration/3,duration/3,duration*2,0.15);
	sig = sig.blend(rvrb,blend);
	sig = LeakDC.ar(sig);
	ReplaceOut.ar(\out.kr(0),sig*\amp.kr(1));
}).add;

SynthDef(\fx_comp,{
	arg cgain=25, catk=0.01, crel=0.1, ctresh=0.5, cabove= 0.0;
	var sig, car;
	sig = In.ar(\in.kr(300),2);
	car = In.ar(\in_car.kr(310),2);
	sig = Compander.ar(sig,(car*cgain).tanh,ctresh,1,cabove,catk,crel);
	sig = sig + car;
	Out.ar(\out.kr(0),sig);
}).add;

SynthDef(\fx_delay,{
	arg amp=0.5, len=0.1, len_tot= 1, hpf=100, lpf= 8000;
	var sig, car;
	sig = In.ar(\in.kr(310),2);
	sig = HPF.ar(sig,hpf);
	sig = LPF.ar(sig,lpf);
	sig = Width0.ar(sig,0);
	sig = Width1.ar(sig,1,0.01,0);
	sig =       DelayN.ar(HPF.ar(sig,1000),len/3,len/3,0.2);
	sig = sig + PanStereo.ar(DelayN.ar(HPF.ar(sig,200),4*len,3*len,0.8),0.5);
	sig = sig + PanStereo.ar(DelayN.ar(HPF.ar(sig,100) ,2*len,2*len,0.7),-0.5);
	sig = sig + CombN.ar(HPF.ar(sig,440),1*len,1*len,len*8,0.8);
	// sig = DelayN.ar(sig,len,len,0.8);
	sig = sig + DelayN.ar(HPF.ar(sig,1000),len/3,len/3,0.2);

	Out.ar(\out.kr(0),sig*amp);
}).add;

SynthDef(\fx_piano,{
	arg amp=1, len=0.1, len_tot= 1, hpf=440, lpf= 3200, blend=0.5;
	var sig, wet;
	sig = In.ar(\in.kr(310),2);
	wet = sig;
	// wet = CombN.ar(HPF.ar(LPF.ar(wet,lpf/2),hpf*2),len/2,len/2,len*3/2,1);
	wet = wet+DelayN.ar(HPF.ar(LPF.ar(wet,lpf),hpf),len,len,2);
	wet = wet+CombN.ar(LPF.ar(sig),len*2,len*2,len*6,0.1);
	sig = sig.blend(wet,blend);
	Out.ar(\out.kr(0),sig*amp);
}).add;


)

MIDIdef.trace(false)