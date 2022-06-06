+ UGen {
	tempodur {
		var tempo, beatdur;
		tempo = this;
		beatdur = 60/tempo;
		^beatdur;
	}

	range1 {
		arg from, to;
		^ this.linlin(0,1,from,to)
    }
}

+ String {
	convert {

		var string, array;
		string = this.replace(" ", "").replace("\n", "");
		array = [];
		string.do{|i|
			var it;
			it = i.asString.asInteger;
			if(it>0){
				array = array ++ it;
			}{
				array = array ++ \rest
			}
		};
		^array;

	}
}


+ SimpleNumber {
​
	range1 {
		arg from, to;
		^ this.linlin(0,1,from,to)
    }

    tempodur {
		var tempo, beatdur;
		tempo = this;
		beatdur = 60/tempo;
		^beatdur;
    }
​
    durtempo {
		var beatdur, tempo;
		beatdur = this;
		tempo = 60/beatdur;
		^tempo;
    }
​
	play{
		arg out =0;

		{
			var sig;
			sig = SinOsc.ar(this.midicps);
			sig = sig * EnvGen.ar(Env.perc(0.001,0.2),doneAction:2);
			sig = sig * 0.5!2;
			Out.ar(out,sig);
		}.play;
		^this.midicps;
	}

}

+ Env {
	*rand {
		arg numSec, dur = 1, bipolar = false;
		var env, levels, times, curves, minLevel;
		levels = {rrand(-1.0,1.0)}!(numSec+1);
		minLevel = bipolar.asInteger.neg;
		levels = levels.normalize(minLevel, 1);
		times  = {exprand(1,10)}!numSec;
		times  = times.normalizeSum * dur;
		curves = {rrand(-4.0,4.0)}!numSec;
		env = Env.new(
			levels,
			times,
			curves
		);
		^env;
	}

}