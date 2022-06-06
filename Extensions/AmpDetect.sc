//needs 2 channel input
AmpDetect : Object {
	*ar { arg
		input,
		ratio      = 4,
		threshhold = 0.5,
		knee       = 0.0,
		trim       = 1,
		attack     = 0.01,
		release    = 0.1,
		hpf        = 50
		;
		var in, t, e, o, r, c, kneelag;

		in = input * trim;
		t = threshhold;
		e = in.mean;
		e = HPF.ar( e, hpf );
		e = EnvDetect.ar(e, attack, release);
		o = e.ampdb.excess(t);
		r = ratio;
		c = ( max(o, 0.0) ) * (r.reciprocal - 1);
		kneelag = attack * knee;
		c = c.lag( kneelag );
		c = c.dbamp;
		^in
	}
}