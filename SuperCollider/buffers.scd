(
SynthDef("pvrec", { arg recBuf=1, soundBufnum=2;
	var in, sig, bufnum;
	bufnum = {LocalBuf.new(1024)}!2;
	Line.kr(1, 1, BufDur.kr(soundBufnum), doneAction: 2);
	in = PlayBuf.ar(2, soundBufnum, BufRateScale.kr(soundBufnum), loop: 0);
	sig = FFT(bufnum, in, 0.25, 1);
	sig = PV_RecordBuf(sig, recBuf, 0, 1, 0, 0.25, 1);
}).add;

//test synth:
SynthDef("pvplay", { arg out=0, recBuf=1;
	var in, sig, bufnum;
	bufnum = {LocalBuf.new(1024)}!2;
	sig = PV_BufRd(bufnum, recBuf, LFSaw.kr(0.2,1).range(0,1));
	Out.ar(out, IFFT(sig, 1));
}).add;

~b = Dictionary.new;
~b_fft = Dictionary.new;
~b_grain = Dictionary.new;
~b_grain_right = Dictionary.new;

~load_b={arg key=\key, folder=\samples, full=0;
	var frameSize = 1024, hop = 0.25;

	// s.makeBundle(nil,{
	Routine{
		~b[key]       = Array.new;
		if(full!=0){
			~b_fft[key]   = Array.new;
			~b_grain[key]       = Array.new;
			~b_grain_right[key] = Array.new;
		};
		~folder = thisProcess.nowExecutingPath.dirname +/+ folder;
		~folder.postln;
		~folder = PathName.new(~folder);
		~folder.entries.do({
			arg path;
			~b[key]=~b[key].add(Buffer.read(s, path.fullPath));
			if(full!=0){
				~b_grain[key]=~b_grain[key].add(Buffer.readChannel(s, path.fullPath,channels:[0]));
				~b_grain_right[key] = ~b_grain_right[key].add(Buffer.readChannel(s, path.fullPath,channels:[1]));
				0.1.wait;
				~b_fft[key] = ~b_fft[key].add( Buffer.alloc(s,~b[key].last.duration.calcPVRecSize(frameSize, hop),~b[key].last.numChannels));
				0.1.wait;
				Synth("pvrec", [\recBuf, ~b_fft[key].last, \soundBufnum, ~b[key].last]);
				0.1.wait;
			};
		}
		);
	}.play;
}


)


/*


~load_b={arg key=\key, folder=\samples;
	~b[key] = Array.new;
	~folder = thisProcess.nowExecutingPath.dirname +/+ "samples/";
	~folder.postln;
	~folder = PathName.new(~folder);
	~folder.entries.do({
		arg path;
		~b[key]=~b[key].add(Buffer.read(s, path.fullPath));
		}
	);
}


(
SynthDef("pvrec", { arg recBuf=1, soundBufnum=2;
	var in, sig, bufnum;
	bufnum = {LocalBuf.new(1024)}!2;
	Line.kr(1, 1, BufDur.kr(soundBufnum), doneAction: 2);
	in = PlayBuf.ar(2, soundBufnum, BufRateScale.kr(soundBufnum), loop: 0);
	sig = FFT(bufnum, in, 0.25, 1);
	sig = PV_RecordBuf(sig, recBuf, 0, 1, 0, 0.25, 1);
}).add;
)
*/