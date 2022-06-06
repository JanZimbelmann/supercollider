PhasorSin : Object {
	*kr { arg
		gate=1,
		dur=1,
		pos=0,
		mul=1;
		var sig, period, reset_pos, rate, trig;
		period = 2 * pi;
		trig = Impulse.kr(1/dur);
		rate = period/ControlRate.ir;
		reset_pos = period*(pos+(3/4));
		sig = Phasor.kr(gate+trig,rate/dur,0,period,reset_pos);
		sig = sin(sig).range(0,mul);

		^sig
	}
}