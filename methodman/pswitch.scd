(
p = Pbind(
	\degree, Pswitch([Pseq([1,2]),2,3],Pseq([0,1,2],inf)),
    \dur,0.25,
).play;
)


(
TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pswitch1([Pwhite(7, 14, inf), Pwhite(-7, 0, inf)], Pfunc { 0.7.coin.binaryValue }),
    \dur, 0.25
).play;
)

p.stop;