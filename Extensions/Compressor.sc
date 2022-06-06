Compressor : Object {
	*ar { arg
		input, carrier, attack=0.01, release=0.1, threshold=0.5, ratio=0.5,
		mul=1
		;

		var sig, amplitudeDb, gainDb;
		amplitudeDb = Amplitude.ar(carrier, attack, release).ampdb;
		gainDb = ((amplitudeDb - threshold) * (1 / ratio - 1)).min(0);
		sig = input * gainDb.dbamp;

		^sig
	}
}

CompressorReflectives : Object {
	*ar {
		arg input, attack = 0.01, release= 0.1, threshhold=(-6), trim = 0, hpf = 50, ratio = 4, knee = 0, lookahead= 0, gain = 0, bias = 0, saturate = 1, dry_wet = 1;
		var local;
		var dry, drywet, in, t, o, r, c, e;
		var kneelag;

		t = threshhold;

		dry = input;

		in = dry * trim.dbamp;

		e = in.mean;

		e = HPF.ar( e, hpf );

		e = EnvDetect.ar(e, attack, release);
		// e = e.abs.lagud(attack, release);

		// how much we are over by
		o = e.ampdb.excess(t);

		// scale the excess value by ratio
		r = ratio;
		c = ( max(o, 0.0) ) * (r.reciprocal - 1);

		kneelag = attack * knee;

		c = c.lag( kneelag );
		c = c.dbamp;

		lookahead = lookahead;
		in = DelayC.ar( in, 0.5, ( attack + release + kneelag * lookahead).lag(0.4) ); // lookahead
		in = in * c;
		in = in	* gain.dbamp;
		bias = K2A.ar(bias);

		in = Select.ar( saturate, [in, (in + bias).softclip - bias] );
		in = LeakDC.ar(in);

		drywet = dry_wet;
		^ Mix([in * drywet,DelayC.ar( dry * (1 - drywet), 0.5, ( attack + release + kneelag * lookahead).lag(0.4) )]);

	}

}


CompressorSidechain : Object {
	*ar 	{
		arg input, carrier, attack=0.01, release = 0.1, threshhold=(-6), trim=0, hpf=50, lpf=15000, ratio=4, knee=0, lookahead=0, gain=0, bias=0, saturate=1, dry_wet=0, mul=1;
		var local;
		var dry, drywet, in, t, o, r, c, e;
		var kneelag;
		var sig, car, wet;

		t = threshhold;

		sig = input;
		car = carrier;
		wet = car * trim.dbamp;

		e = wet.mean;

		e = HPF.ar( e, hpf);
		e = LPF.ar( e, lpf);

		e = EnvDetect.ar(e, attack, release);
		// e = e.abs.lagud(attack, release);

		// how much we are over by
		o = e.ampdb.excess(t);

		// scale the excess value by ratio
		r = ratio;
		c = ( max(o, 0.0) ) * (r.reciprocal - 1);

		kneelag = attack * knee;

		c = c.lag( kneelag );
		c = c.dbamp;

		wet = DelayC.ar( sig, 0.5, ( attack + release + kneelag * lookahead).lag(0.4) ); // lookahead
		wet = wet * c;
		wet = wet * gain.dbamp;
		bias = K2A.ar(bias);

		wet = Select.ar( saturate, [wet, (wet + bias).softclip - bias] );
		wet = LeakDC.ar(wet);

		drywet = dry_wet;
		sig = Mix([
			sig * drywet,
			DelayC.ar( wet * (1 - drywet), 0.5, ( attack + release + kneelag * lookahead).lag(0.4) )
		]);
		sig = sig * mul;
		^sig;
	}

}