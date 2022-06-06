~midi.value()
(
// s.record;
Synth.tail(nil,\fx_comp,[\catk, 0.1, \crel, 0.4, \ctresh, 0.1, \cabove, 0.1, \in, 300, \in_car, 310,\out, 290]);//bass
Synth.tail(nil,\fx_comp,[\catk, 0.01, \crel, 0.05, \in, 290, \ctresh,0.3, \cabove, 0.3, \in_car, 320, \cgain, 100, \out,0]);//breaks
Synth.tail(nil,\fx_delay,[\amp, 1, \len,~dur/4, \blend, 0.18]);
Synth.tail(nil,\fx_piano,[\amp, 1, \len,~dur/2,\in, 500,\blend,0.28]);
// Synth.tail(nil,\fx_piano,[\amp, 1, \len,~dur/2,\in, 500,\blend,0  ]);
Synth(\voc);
Synth.tail(nil,\fx,[\amp, 0.5, \length,0.25*~dur, \in, 310, \out, 0]);


(
// Pdef(\sub).play(quant 5:0);
// Pdef(\bass).play(quant:0);
// Pdef(\break).play(quant:0);
// ~record_loop.value(~b[\records][2],~b[\records][2].duration,1);
// Pdef(\nother).play(quant:0);
);

~piano.value;

~going = 0;
// ~record_loop.value(~b[\records][1],100*~b[\records][1].duration,1.5);

MIDIdef.noteOn(\get_going,{
	|vel, nn, ch|
	[vel, nn, ch].postln;
	if((nn == 43)&&(~going == 0)){
		//full
		if(~setting == 2){
			Pdef(\sub).play(quant:0);
			Pdef(\bass).play(quant:0);
			Pdef(\break).play(quant:0);
			~going = 1;
			Routine{
				(~dur*56).wait;
				~going = 0;
			}.play;
		};
		//drums
		if(~setting == 3){
			Pdef(\break).play(quant:0);
			~going = 1;
			Routine{
				(~dur*56).wait;
				~going = 0;
			}.play;
		};
		//drums
		if(~setting == 4){
			Pdef(\break).play(quant:0);
			Pdef(\nother).play(quant:0);
			~going = 1;
			Routine{
				(~dur*56).wait;
				~going = 0;
			}.play;
		};
	};
	if(nn==24){
		"stop".postln;
		Pdef(\sub).stop;
		Pdef(\bass).stop;
		Pdef(\break).stop;
		Pdef(\nother).stop;
	};
	if(nn==24){
		~going=0;
	};
});

MIDIdef.program(\get_program,{
	|nn, ch, id|
	~setting = nn;
	("setting:" + ~setting).postln;
},4);


)
s.scope

