//test
Pdef(\drum).play(quant:0);
s.options.memSize_(2**14)
s.scope
(
//

// s.record;
~b0.zero;

~stage = 0;
~dur = 0.16;
~looper0 = Synth.after(1,\looper_fix,[\buf,~b0.bufnum,\in,50,\out,0,\mic_amp,1]);
~guitar = Synth(\guitar_semichki);
// ~vocal = Synth(\vocal_semichki);
~git_clean= {~guitar.set(\amp,~amps[\clean],\out,50,\gain,0.8,\amount,0.5,\hi_amp,4,\blend,0, \wet,0, \del_dist, 0.01)};
~git_dist0 = {~guitar.set(\amp,~amps[\dist0],\out,50,\gain,5,\amount,0.99,\hi_amp,(-3), \blend,0,\wet,1,\del_dist, 0.018)};
~git_dist1 = {~guitar.set(\amp,~amps[\dist1],\out,50,\gain,5,\amount,0.99,\hi_amp,(-3), \blend,0,\wet,1,\del_dist, 0.018)};
~git_chor = {~guitar.set(\amp,~amps[\chor],\out,50,\gain,1,\amount,0.5,\hi_amp,1,\blend,0, \wet,0,\del_dist, 0)};
~git_clean.value();
// ~git_dist1.value();
// ~git_chor.value();

Synth.tail(nil,\fx);


~stage_order_content = [
	//0
	{
		t = TempoClock.default();
		t.beats=30*~dur;
		Qt.uant(~dur*30,0,t,{
			Pdef(\bass0).play(quant:0);
			~bass0_hpf=50;
		});
	},
	//1
	{
		Qt.uant(~dur*30,0,t,{
			~setter_idx=0;
			Pdef(\drum).play(quant:0);
		});
	},
	//2
	{
		Qt.uant(~dur*30,0,t,{
			Pdef(\drum).play(quant:0);
			Pdef(\pad0).play(quant:0);
			~setter_idx=1;
			(~dur*30).wait;
			~looper0.set(\trig, 1, \run, 1, \rec_lev, 1, \pre_lev, 1, \xfade, 0.01, \mic_amp, 1);
			Pdef(\bass0).stop;
		});
	},
	//3
	{
		~looper0.set(\rec_lev, 0);
		~git_dist0.value;
		Qt.uant(~dur*30,0,t,{
			Pdef(\bass1).play(quant:0);
		});
	},
	//4
	{
		Qt.uant(~dur*15,0,t,{
			Pdef(\bass1).stop;
		});
		Qt.uant(~dur*30,0,t,{
			Pdef(\drum).stop;
			Pdef(\pad1).play(quant:0);
			Pdef(\bass2).play(quant:0);
			~git_chor.value()
		});
	},
	//5
	{
		~git_dist1.value();
		},
	//6
	{
		~looper0.set(\xfade, 0.3, \loop_amp, 0);
		},
	//7
	{
		Pdef(\pad1).stop;
	},
	//8
	{
		Pdef(\bass2).stop;
		Pdef(\pad0).stop;
	},
	//8
	{
		~git_clean.value;
	},
];


~stage_order = Order.newFromIndices([
	{//ctrl1
		if(~stage%4==0){
			~stage_order_content[~stage].value();
			~stage=~stage+1;
		};
	},
	{//ctrl2
		if(~stage%4==1){
			~stage_order_content[~stage].value();
			~stage=~stage+1;
		};
	},
	{//ctrl3
		if(~stage%4==2){
			~stage_order_content[~stage].value();
			~stage=~stage+1;
		};
	},
	{//ctrl2
		if(~stage%4==3){
			~stage_order_content[~stage].value();
			~stage=~stage+1;
		};
	},
], (0..3));

MIDIdef.cc(\semichki_nn1,{
	|vel,nn,ch|
	// [vel,nn,ch].postln;
	if((vel==127)&&(~stage ==0)){
		m.program(3,0);
	}
});
MIDIdef.program(\semichki_stage,{
	|nn,ch|
	var map = ~stage_order[nn];
	[nn,ch].postln;
	if(ch == 3){
		map.value;
		~stage.postln;

	};
});
)
s.scope

MIDIdef.trace(false)
(~dur/8).durtempo;