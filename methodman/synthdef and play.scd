(
{ | dur = 0.15, atk = 0.015, amp = 0.8, pan = 0 |
    Pan2.ar(
        SinOsc.ar(
            EnvGen.ar(Env(\freq_l.kr([2960, 70, 90]), \freq_d.kr([0.07, 0.15]), \freq_c.kr([-13, -1]))),
            mul:EnvGen.ar(
                Env.perc( atk, max(dur - atk, atk), curve: \amp_c.kr([-1, 5])),
                doneAction: 2 ) ),
        pan, amp )
}.asSynthDef.name_("ckick").add.play;
)
