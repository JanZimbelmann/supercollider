(
SynthDef(\hat,{
	var sig;
	sig = GrayNoise.ar()* Line.kr(1,0,0.1,\amp.kr(0.2),doneAction:2);
	Out.ar(\out.kr(0),sig!2);
}).add;
)
//this is what it is supposed to do:
(
Pbind(
	\instrument, \hat,
	\stutter, Pstutter(Pseq([1,2,3,4],inf),Pseq([1,2,3,4],inf)),
	\dur, 1/Pkey(\stutter).trace,
).play;
)
//this is the theortical way i want to have it done, but it doesnt work:
(
Pbind(
	\instrument, \hat,
	\stutter_reference,Pseq([1,2,3,4],inf), //here is some possibly later random reference for the \stutter key
	\stutter, Pstutter(Pkey(\stutter_reference),Pkey(\stutter_reference)), //this does not get the right stutter reference, because its moving independetly
	\dur, 1/Pkey(\stutter).trace,
).play
)


(
Pbind(
	\instrument, \hat,
	\stutter, Pdup(Pseq([1,2,3,4],inf),Pseq([1,2,3,4],inf)),
	\dur, 1/Pkey(\stutter).trace,
).play
)


(
Pbind(
	\instrument, \hat,
	\stutter_reference,Pseq([1,2,3,4],inf),
	\stutter, Pn(Prout({var n; n=1.rrand(4).debug('n'); n.do{ n.yield}})),
	\dur, 1/Pkey(\stutter),
).play
)

(

~ctrl=Pseq([1,2,3,4],inf).asStream;

Pbind(
	\instrument, \hat,
	\stutter, Pn(Prout({ var n=~ctrl.next.debug("n"); n.do{ n.yield}})),
	\dur, 1/Pkey(\stutter).trace,
).play
)




(
Pbind(
    \instrument, \hat,
    \dur, Psubdivide(Pseq([1,2,3,4], inf), 1)
).play;
)


(
Pbind(
    \instrument, \hat,
    \dur, Psubdivide(Prand([1,3,8], inf), 1)
).play;
)
