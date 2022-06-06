DelHarm : Object {
	*ar { arg
		input,
		n = 0,
		maxdel = 0.05
		;

		var rate, sig, phs, env, del;

		rate = n.midiratio - 1 /maxdel;
		sig  = input;
		phs  = LFSaw.ar(rate.neg, [1,0]).range(0,maxdel);
		env  = SinOsc.ar(rate,[3pi/2,pi/2]).range(0,1)**(1/2);
		del  = DelayC.ar(sig, maxdel, phs) * env;
		del  = del.sum!2;

		^del
	}
}