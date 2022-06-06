(
SynthDef.new(\zampler, {
	arg amp = 1, doneAction = 2, out = 0, buf, rate=1, reset = 1, dur =1, length =1, hits=1, seriesArray = #[0,1,2,3], sliRate=1, style=0;
	var sig, ptr, ptrInd, noClip, series, bufSup;
	//an envelope to avoid .linlin mapping clips of the ptr:
	noClip = EnvGen.kr(Env.new([0,1,0],[dur/2,dur/2],[-100,100]),doneAction:2);
	//repeating pattern of the pointer + the pointer:
	ptrInd = LFSaw.kr(hits*(1/(dur)),1,0.5/hits,0.5/hits); // this is a copy from below

	series = Dser(seriesArray.midiratio,inf);
	series = Demand.kr(ptrInd-0.01,0,series);

	ptrInd = LFSaw.ar(series*rate*hits*(1/(dur)),1,0.5/hits,0.5/hits);
	// ptrInd = LFSaw.ar(series*rate*hits*0.25,1,0.5/hits,0.5/hits);

	ptr = IEnvGen.ar(Env.new([0,1]),ptrInd).linlin(0,1,(reset-1),reset)/length;

	sig = BufRd.ar(2, buf, ptr*(BufFrames.kr(buf)),0);
	//slicer
	sig = LFPulse.kr(sliRate/(2*dur),0,0.5)*sig;

	//final configuration
	sig = sig * amp * noClip;
	Out.ar(out, sig!2);
}).add;
)

~b[\brass][0][3].play

(
~amen=~b[\amen][0][1];
~brasz0=~b[\brass][0][2];
~brasz1=~b[\brass][0][3];
Pbind(
	\instrument, \zampler,
	\length, 8,

	// \buf, Ptuple([~b[\amen][~drmNm], Pstutter(2,Pwrand(~b[\brasz][0..2],[0,1,1].normalizeSum))],inf),
	// \buf, Pseq([Ptuple([~b[\amen][~drmNm],Pstutter(8,Pseq([~b[\brasz],~b[\brass][0][2]],2))],1),Pkey(\buf)]),
	\buf, Ptuple([~amen,Pstutter(8,Pseq([~brasz0,~brasz1],inf))]),

	\reset, Pseries(0,1).asStream,
	\reset, Pseq([Pn(Pkey(\reset),1),Pseq([2,6],8)],1),
	\reset, (Pkey(\reset)%Pkey(\length))+1, //modulo replaces the loop in the envelope

	\dur,1/((Pkey(\length)/4))*0.5, //I expect the buffer to be a 4/4 and reconfigure the dur to length

	\hits,Pstutter(Pwrand((1..3),[0.3,0.6,0.1],inf),Pwrand([1,1.5,2,3,4,6,8,16,32],([256,32,16,32,1,0.5,0.25,0.125,0.0625]**(8/9)).normalizeSum,inf)),

	\rate, [1,0.5]*Pstutter(Pwrand((1..5),[0.5,0.4,0.04,0.03,0.03],inf),Pwrand([0.5,-1,1,0.5,Pn(0.5,2),2,Pseq([1.5,2,1.5]),Pseq([2,2,2]),Prand([2,2,-2],4)],([2,8,256,1,2,1,0.25,0.25,0.125]**(3)).normalizeSum,inf)),

	\rate, [1,0.5],


	\sliRate, Pstutter(Pwrand((1..6),[3,5,2,5,2,2].normalizeSum,inf),Pwrand([1,2,3,4,6,8],([256,16,8,4,2,1]**(1.5)).normalizeSum,inf)),

	\seriesArray, Pwrand([[(0..3)],[[0,3,2,1]],[(0!4)],[[0,3,3,1]],[[0,-1,-2,-3]],[[0,-3,3,-1]]],[1,1,4,2,4,2].normalizeSum,inf),

	// \amp, Pfunc{~amp},
	\amp, 1,
).play;
)
~bpm=2
~amp=1