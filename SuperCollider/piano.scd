
"piano_exe available.".postln;
(
~piano_exe = Dictionary.new();




~piano_exe['init']={
	~samples = Array.new;
	~folder = PathName.new("/home/kaoboi/studio/superc/piano/steinberg/");

	// ~folder = PathName.new("/home/kaoboi/studio/superc/piano/tedagame/");
	~folder.entries.do({
		arg path;
		~samples = ~samples.add(Buffer.read(s, path.fullPath));
	});

	SynthDef.new(\piano, {
		arg buf, vel=64, gate=0, rate=1, gain=2, out=0;
		var sig, env, amp;
		env = EnvGen.kr(Env.asr(0.1,1,0.5), gate, doneAction:2);
		sig = PlayBuf.ar(2, buf, rate*BufRateScale.ir( buf ));
		sig = (sig * gain).tanh;
		amp = LinExp.kr(vel, 1, 127, 0.01, 1);
		sig = sig * env * amp* 0.4;
		Out.ar(out, sig);
	}).add;
	~keys = Array.newClear(128);
	~pedal = Array.fill(128,0);
};






~piano_exe['start']={
	arg out=0;
	~pedal = Array.fill(128,0);

	MIDIdef.noteOn(\piano_on, {
		arg vel, note, ch, src;
		note.postln;
		~pedal.postln;
		~keys[note].set(\gate, 0);
		~pedal[note] = ~pedal[note] +1;
		~keys[note] = Synth.new(\piano, [
			\buf, ~samples[note-21].bufnum,
			\vel, vel,
			\gate, 1,
			\gain,1,
			\out, out,
		]
		);
	});

	MIDIdef.noteOff(\piano_off, {
		arg vel, note, ch, src;
		~pedal[note] = ~pedal[note] - 1;
		if(~pedal[note]==0){
			~keys[note].set(\gate, 0);
		}
	});

	MIDIdef.cc(\piano_cc, {
		arg vel, note, ch, src;
		//[vel,note,ch,src].postln;
		if(vel==127){
			~pedal = ~pedal +1;
		};
		if(vel==0){
			~pedal = ~pedal -1;
			128.do({|i|
				if((~pedal[i]<=0)){
					~pedal[i]=0;
					~keys[i].set(\gate, 0);
				}
			})
		};

	});
};




~piano_exe['free']={
	MIDIdef.cc(\piano_on).free;
	MIDIdef.cc(\piano_off).free;
	MIDIdef.cc(\piano_cc).free;
};



~piano_exe['out']={
	arg out=0;
	~piano_exe['free'].value;
	~piano_exe['start'].value(out);
};


)