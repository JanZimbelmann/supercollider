(
s.latency = nil;            // for immediate response;
~sin = ~sin?();
~sin[\name].stop
)
(~sin[\name]=
Ndef(\sinu,{
	arg out=0, amp=0.01, freq=220, gain=2;
	var sig;
	sig = SinOsc.ar(freq!2);
	sig = (sig*gain).tanh;
	sig = sig * amp;
	Out.ar(out,sig);
}).play
)

(
Spec.add(\amp, [0, 1]);
Spec.add(\gain, [0, 10]);
Spec.add(\freq, [55, 440]);
m = NdefMixer(s, 3);
ProxyMeter.addMixer(m)
)


(
~sin[\ctrl] = Order.newFromIndices(
	[
		\amp,
		\freq,
		\gain
	], (8..19)
);
)
(
MIDIdef.cc(\sin_ctrl,{
	arg vel, num;
	var val;
	var control = ~sin[\ctrl][num];
	val = (vel-1).clip(0,126);
	[val,num].postln;
	~sin[\name].set(
		control,
		~sin[\name].getSpec(control).map(val/126),
	)
}
).fix;
)

Ndef(\sinu).set(\amp,0.2)


Pdef(\sinu_play).stop
(
Pdef(\dfamDefault, Pbind(*Ndef(\dfam).controlNames.collect({arg ctrl; [ctrl.name, ctrl.defaultValue]}).flatten));
Pdef(\sinu, Pbind(
	\type, \set,
	\args, ~sin[\name].controlNames.collect({arg ctrl;ctrl.name}),
	// \id, Pfunc({ ~sin[\name].group.nodeID }),
	\trig, Pkey(\velocity, inf) / 128,
));

Pdef(\sinu_play,Ppar([
	Pbind(
		\freq,Pwhite(50,440),
		\dur, 0.1,
	)

]) <> Pdef(\sinu)).play
)