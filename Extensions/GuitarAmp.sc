GuitarAmp : Object {
	*ar { arg
		input,
		gain=1,
		amount=0.99,
		hpf=50,
		lpf=3800,
		meqf=120,
		meqa=8,
		mul=1
		;

		var sig, amCoef;

		sig = HPF.ar(input, hpf)*gain;
		amCoef= 2*amount/(1-amount);
		sig = MidEQ.ar(LPF.ar((1+amCoef)*sig/(1+(amCoef*sig.abs)), [lpf, lpf*1.025])*0.5, meqf, 0.7, meqa);
		sig = sig * mul;
		^sig
	}
}

