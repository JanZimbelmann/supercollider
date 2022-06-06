//making a SynthDef
(
//simple Synth
SynthDef(\sins, {
	|freq=440, out = 0, amp=1, gain=1|
	Out.ar(out,amp*(gain*SinOsc.ar(freq!2)).tanh*((Saw.kr(1).range(0,1))**10))
}).add;
)
//This is on one way of making it work with synths
b=Synth(\sins,[\gain:100]);
a.free;b.free;
//now i want this with ndefs
Ndef(\sinn).add(\sins);
Ndef(\sinn).play;

Ndef(\sqrn).add(\sins);
Ndef(\sqrn).set(\gain,10)
Ndef(\sqrn).play;
Ndef(\sqrn).put(100,\filter -> {|in|in+DelayN.ar(in)})

Ndef(\sqrn2).add(\sins);
Ndef(\sqrn2).set(\gain,10)
Ndef(\sqrn2).play;
Ndef(\sqrn2).put(100,\filter -> {|in|in+DelayN.ar(in)})

Ndef(\sqrn2).clear
Ndef(\sinn).clear
//the next commented line is one way of making it work
//Ndef(\sinn).put(100,\filter -> {arg in; FreeVerb.ar(in,0.6)})

//however I want to make it work with the \rev SynthDef
//it doesn't work yet, but i hope the point gets accross...
Ndef(\sinn).put(10,\filter -> c/*something \rev SynthDef*/)


(
Ndef(\sinn).put(10,\filter -> {
	|in, amp=0.2, out=0|
	var sig;
	//instead of the In.ar, the in argument of the filter
	//could also be used? somehow? i dont know...
	sig = in;
	sig = FreeVerb.ar(sig,1);
	Out.ar(out,sig)
}
)
)


//clear the Ndef
Ndef(\sinn).clear