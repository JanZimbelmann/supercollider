~load_b.value(\piano,\quiet_update);

(
s.record;
Synth.tail(nil,\fx,[\amp, 0.4, \length,0.125, \in, 0, \out, 0,\blend, 0.02]);
Synth(\voc,[\amp, 0.2]);
~piano.value();
)

(

~p = Dictionary.new;
~p[\amp] = 0.8;
~p[\buf] = ~b[\piano];
~p[\lo_db] = 6;
~p[\hi_db] = 6;
~p[\out] = 0;


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
	~keys[nn] = Synth(\piano_sampler, [\buf, ~p[\buf][nn], \amp, (vel/127)**2 * ~p[\amp],\lo_db,~p[\lo_db],\hi_db,~p[\hi_db],\out,~p[\out]]);
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

)