(
SynthDef(\delharm, {
	var sig, phs, del, env, rate, maxdel=0.05;
	rate = \n.kr(0).midiratio - 1 /maxdel;
	sig  = In.ar(\in.ir(0),2);
	phs  = LFSaw.ar(rate.neg, [1,0]).range(0,maxdel);
	env  = SinOsc.ar(rate,[3pi/2,pi/2]).range(0,1)**(1/2);
	del  = DelayC.ar(sig, maxdel, phs) * env;
	del  = del.sum!2 * \amp.kr(0.85);
	Out.ar(\out.ir(0),del);
}).add;
)
{LFSaw.ar(-1,1)}.plot;

~del = Synth(\delharm,[\n, 0, \in, 80])
{Out.ar(0,SinOsc.ar(220!2)*0.1*(LFSaw.kr(1,1).range(1,0)**3))}.play
~del.set(\n,-0);
s.scope

{DelHamr}

s.scope
(
{
	var sig;
	sig = SinOsc.ar(MouseX.kr(10,10000).poll!2);
	sig = sig + DelHarm.ar(sig,[12,-12,3,5,6],0.1);
	sig = sig * 0.1 * (LFSaw.kr(1,1).range(1,0)**3);

	// sig = FreeVerb.ar(sig,0.33,1);
	Out.ar(0,sig)
}.play
)
s.scope