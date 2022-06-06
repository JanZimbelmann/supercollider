(
SynthDef(\fmbell, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 2.6706 + 0.13) * 2 + 1;
	sig2 = SinOsc.ar(freq * 0.9998 * sig1);
	sig3 = SinOsc.ar(freq * 2.6629 * sig1 + 2.04);
	sig4 = LFCub.ar(freq * 0.9991 * sig1 + 2.14);
	sig5 = SinOsc.ar(freq * 2.6656 * sig1 - 2);
	sig6 = SinOsc.ar(freq * 1 * sig1 + 1.84);
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0,0.5,0.5, 0.5,0.5,0.5]);
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,2.1,1,-1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + [ 0, -0.5, -0.5, 0.5, 0.5, 0], amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\chorus, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(100), 2);
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0001) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.kr(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\fmbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq / 4;
	freq = freq * ((0..1)/1 - 0.5 * 0.0007 + 1);
	env1 = EnvGen.kr(Env([0,1,0.051,0],[0.001,0.01,0.8], [4,-8]), 1);
	env2 = EnvGen.kr(Env([0,1,0.051,0],[0.005,0.5,1.5], [0,-8], releaseNode:2), 1);
	env3 = EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.2], [0,0,-4], releaseNode:2), gate);
	env4 = EnvGen.kr(Env([0,1,0],[0.002,2.8], [0,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.8], [4,0,-4], releaseNode:2), gate);
	env6 = EnvGen.kr(Env([0,1,0],[0.001,3.0], [0,-4]), 1);
	//freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 11 + 0) * env1;
	sig2 = SinOsc.ar(freq * 6 * ( sig1 * 2.5 + 1 )) * env2;
	sig3 = SinOsc.ar(freq * 2 * 1 + 0) * env3;
	sig4 = SinOsc.ar(freq * 1 * ( sig3 * 2.5 + 1 ) + 0) * env4;
	sig5 = SinOsc.ar(freq * 1 * ( sig2 * 2.5 + 1 ) * (sig4 * 2.5 + 1)) * env5;
	sig6 = SinOsc.ar(freq * 2) * env6;
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0.0, 0.0, 0.0,  0.0, 0.5, 0.5]);
	sig.debug("sig");
	sig = sig /2;
	sig = sig.flop.sum;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.001,0,1,0.01, 1,-1) ),gate,doneAction:2);
	sig = sig * AmpComp.kr(freq);
	sig.debug("sigx");
	sig = Pan2.ar(sig, pan + [ 0, 0, 0, 0, 0, 0], amp).sum;
	Out.ar(out, sig);
}).add;

~fxbus = ~fxbus ?? { Bus.audio(s,2) };
~t = 135/4/60; TempoClock.default.tempo = ~t;
);
(
(
Pdef(\fm,
	Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pseq([
				0,5,2,3,1,-12,-5,1,-2,0,1,
			],inf),
			\legato, Pseq([
					4,0,0,0, 0,0,1,1,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				2,9,5,-4,
			],inf),
			\octave, 4,
			\sustain, 0.1,
			\dur, 1,
			\out, ~fxbus,
			\amp, 0.1/2,
		),
		Pmono(\chorus,
			\inbus, ~fxbus,
			\delay, Pseq([
				0.003,
				0.00007,
			],inf).stutter(8),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)