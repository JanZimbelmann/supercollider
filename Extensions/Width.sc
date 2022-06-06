Width0 : Object {
	*ar { arg
		input,
		width=1,
		mul=1
		;

		var sig;
		sig = input;
		sig = sig.blend([sig[0]+sig[1],sig[0]+sig[1]]/2,1-width);
		sig = sig*mul;
		^sig
	}
}

Width1 : Object {
	*ar { arg
		input,
		width=1,
		delay0=0,
		delay1=0,
		mul=1
		;

		var sig, sig0, sig1;
		sig = input;
		sig0= DelayC.ar(sig[0],delay0,delay0);
		sig1= DelayC.ar(sig[1],delay1,delay1);
		sig = [sig0,sig1].blend([sig0+sig1,sig0+sig1]/2,1-width);
		sig = sig*mul;
		^sig
	}
}

PanStereo : Object {
	*ar { arg
		input,
		pan,
		mul=1
		;

		var sig;
		sig = input;
		sig = Balance2.ar(sig[0],sig[1],pan);
		sig = sig*mul;
		^sig
	}
}

