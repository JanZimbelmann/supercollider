{Crackle.ar(1., 0.5)}.play

(
SynthDef(\drums, {|out = 0, bassLevel = 0 , snareLevel = 0, hatLevel = 0, tomLevel = 0, pan1 = 0, pan2 = 0, pan3 = 0, pan4 = 0|

    var  env1, env2, env3, env4, bass, snare, hat, tom, bassOut, snareOut, hatOut, tomOut, mixer;
    env1 = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);
    env2 = EnvGen.kr(Env.perc(0.001, 0.5, 1, -1), 1, doneAction:2);
    env3 = EnvGen.kr(Env.perc(0.002, 0.3, 1, -2), 1, doneAction:2);
    env4 = EnvGen.kr(Env.perc(0.001, 0.1, 1, -5), 1, doneAction:2);
    bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);
    bassOut = Pan2.ar(bass*env1, pan1, bassLevel);

    snare = SinOsc.ar(120) - WhiteNoise.ar(0.5, 0.5);
    snareOut = Pan2.ar(snare*env4, pan2, snareLevel);

    hat = Klank.ar(`[ [ 6563, 9875 ],
               [ 0.6, 0.5 ],
               [ 0.002, 0.003] ], PinkNoise.ar(1));
    hatOut = Pan2.ar(hat*env3, pan2, hatLevel);

    tom =  SinOsc.ar(440);
    tomOut = Pan2.ar(tom*env4, pan4, tomLevel);

    mixer = Mix.new([bassOut, snareOut, hatOut, tomOut]);


    Out.ar(out, mixer);

    }).store

)

s.scope

(
        SynthDef("bitcrush", { arg out;
    var audio, efx, f;

    audio = In.ar(20,2);
	efx=  Decimator.ar(audio, SinOsc.ar(0.05, 0, 9000, 1000).abs, 1);
	// efx= audio;
	efx= Decimator.ar(audio, MouseX.kr(0,44100), MouseY.kr(1,24));
	efx= LeakDC.ar(efx);
	efx=efx.tanh;
	efx= FreeVerb.ar(efx);
    Out.ar(out, efx);
}).store;

f.free;
f = Synth.after(1, "bitcrush");
)

(
p.stop;





    a = Pseq  ([1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0]);
    b = Pseq  ([0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0]);
    c = Pseq  ([0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0]);
    d = Pseq  ([0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1]);
    e = Pwhite (0.14, 0.16, inf);

    p = Pbind(
       \instrument, \drums,
       \out, [20],
       \dur, e*0.75,
	\bassLevel,  Pseq ([a], inf),
	\snareLevel, Pseq ([b], inf),
	\hatLevel,   Pseq ([c], inf),
	\tomLevel,   Pseq ([d], inf)

                       ).play;


            )

(
p.stop;





    a = Pseq  ([1, 0, 0, 0]);
    b = Pseq  ([0, 1, 0, 0]);
    c = Pseq  ([0, 0, 1, 0]);
    d = Pseq  ([0, 0, 0, 1]);
    e = Pwhite (0.14, 0.16, inf);

    p = Pbind(
       \instrument, \drums,
       \out, [20],
       \dur, 0.15,
	\bassLevel,  Pseq ([a], inf),
	\snareLevel, Pseq ([b], inf),
	\hatLevel,   Pseq ([c], inf),
	\tomLevel,   Pseq ([d], inf)

                       ).play;


         )   