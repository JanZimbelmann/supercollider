(
// additional UGens needed:
// AnalogTape, LockhartWavefolder and AnalogVintageDistortion are from
// "ported plugins" https://github.com/madskjeldgaard/portedplugins
// JPverb is in sc3-plugins

Ndef(\test, {
	var snd,freq=50;
	var noise;

	noise = WhiteNoise.ar * LFPulse.kr(freq * [0.5,2],0,0.01).range(0,0.3);
	noise = BPF.ar(noise, LFNoise0.kr([1/5,1/4]).range(1000,8000).lag(1));
	noise = Splay.ar(noise, LFNoise1.ar(1/3).range(-1,1));
	freq = [freq,freq*1.01];
	snd = Pulse.ar(freq);
	snd = snd + Pulse.ar(freq*2.001,LFNoise1.ar(1/3).range(0.01,0.05));
	snd = LeakDC.ar(snd);
	snd = AnalogTape.ar(snd, 0.9, LFNoise1.kr(1/4).range(0,1), 0.5,0,2);
	snd = snd.fold(-0.5,0.9);
	snd = LockhartWavefolder.ar(snd[0] * LFNoise1.kr(1/4).range(1,10), 4) +
	((LockhartWavefolder.ar(snd[1] * LFNoise1.kr(1/4).range(1,10), 4)) * [-1,1]);
	snd = RLPF.ar(snd, LFNoise1.ar(1/4).exprange(200,9000),	LFNoise1.ar(1/3).range(0.1,0.9));
	snd = snd + noise;

	// snd = AnalogVintageDistortion.ar(snd,0,1, oversample:3);
	snd = LeakDC.ar(snd);
	snd = snd * LFPulse.ar(1/7, width:0.2).lag(0.001);
	snd = JPverb.ar(snd*0.4, 10, 0, 5, low:0.5) + snd;
	snd = Limiter.ar(snd*1, 0.9) * 0.8;

	snd;
}).play
)

// copyright: https://unlicense.org/ //