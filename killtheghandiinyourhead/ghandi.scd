Synth(\guitar_danny,[\out,0,\wet,1,\gain,2,\amp,0.4,\tresh,0.00, \del_amp,0.6]);
Synth(\guitar_danny,[\amp,0.4,\out,0,\gain,15,\amount,0.99,\hi_freq,1400,\hi_amp,(-1.5),\wet,1,\del_dist,0.0,\del_long,0.7,\tresh,0,\del_amp,0.2])
s.record;
t.beats
s.scope
(
s.record;
~guitar = Synth(\guitar_danny);
// ~guitar.set(\amp,~amps[\guitar],\out,0,\gain,0.7,\amount,0.3,\hi_f, 1200,\hi_db,3,\lo_f,110,\lo_db,4,\wet,0.0,\del_dist,0.0,\del_long,0.1,\tresh,0,\del_amp,1);
~guitar_clean = {~guitar.set(\amp,~amps[\guitar],\out,0,\pre_gain, 9, \gain,1,\amount,0.04,\del_amp,1, \hpf, 90,\hi_db, 1, \hi_f, 330, \len, ~dur)};
~guitar_dist  = {~guitar.set(\amp,~amps[\dist],\out,0,\pre_gain, 9, \gain,1,\amount,0.99,\del_amp,1, \hpf, 90,\hi_db, 1, \hi_f, 330, \len, ~dur,\tresh,0.003, \del_long, 0.5)};
~effects = Dictionary.new();
~effects[\universal] = Synth.tail(nil,\fx, [\amp, 0.4]);
// Pdef(\bass5).play(quant:0);
~guitar_clean.value();
// ~guitar_dist.value();
// ~guitar.set(\amp,~amps[\dist],\out,0,\gain,1,\amount,0.99,\hi_f,440,\hi_db,(8),\lo_f,120,\lo_db,-5,\wet,1,\del_dist,0.0,\del_long,0.7,\tresh,0,\del_amp,0.2))
~stage = 0;
// ~stage = 6;

~offset = 4;
~stage_order_content = [
//0
	{
		t = TempoClock.default();
		t.beats=42*~dur;
		Qt.uant(42*~dur,0,t,{
			~effects[\jazz]       = Synth.head(nil,\fx_jazz);
			~effects[\brutalize1] = Synth.head(nil,\fx_brutalize1);
			~effects[\brutalize0] = Synth.head(nil,\fx_brutalize0);
			~effects[\fx_del4]    = Synth.head(nil,\fx_del4);
			~effects[\fx_del]     = Synth.head(nil,\fx_del);
			~effects[\compressor] = Synth.head(nil,\fx_compressor,[\in, 170, \in_car, 70]++[ \dry_wet, 0.6, \release, 0.034094577165354, \trim, 26.204724409449, \lpf, 15000, \ratio, 11.322834645669, \threshhold, -8.5590551181102, \knee, 0.0, \attack, 0.00078750078740157, \gain, 0, \hpf, 10, \lookahead, 0.0, \bias, 0.10236220472441 ]);
			Pdef(\kick00).play(quant:0);
			(~dur*4).wait;
			~offset = (t.beats/~dur)%42;
			Pdef(\kick00).stop;
			Pdef(\kick0).play(quant:0);
			Pdef(\drm_noise).play(quant:0);
		})
	},
//1
		{
		Qt.uant(42*~dur,~offset*~dur-0.01,t,{
			0.01.wait;
			// ~record_loop.value(~b[\record][1], ~dur*42, 1);
			Pdef(\drm_jazz1).play(quant:0);
			Pdef(\bass1).play(quant:0);
			Pdef(\toms1).play(quant:0);
			});
	},
//2
	{
		Qt.uant(42*~dur,~offset*~dur-0.01,t,{
			// ~record_loop.value(~b[\record][2], ~dur*16, 0.5);
			Pdef(\drm_noise).stop;
			Pdef(\drm_jazz1).stop;
			Pdef(\kick0).stop;
			Pdef(\bass1).stop;
			Pdef(\toms1).stop;
			Pdef(\kick0).stop;
			0.01.wait;
			Pdef(\drm_jazz2).play(quant:0);
			Pdef(\bass2).play(quant:0);
			(16*~dur).wait;
			Pdef(\kick2).play(quant:0);
			(16*~dur-0.01).wait;
			Pdef(\bass2).stop;
			0.01.wait;
			Pdef(\bass02).play(quant:0);
			Pdef(\stick2).play(quant:0);
			(16*~dur-0.01).wait;
			Pdef(\bass02).stop;
			Pdef(\stick2).stop;
			Pdef(\drm_jazz2).stop;
			Pdef(\kick2).stop;
			0.01.wait;
			Pdef(\kick02).play(quant:0);
			// Pdef(\kick0).play(quant:0);
			(15.5*~dur-0.01).wait;
			Pdef(\kick2).stop;
			Pdef(\kick02).stop;
			Pdef(\bass02).stop;
			0.01.wait;
			~offset = (t.beats/~dur)%42;
			Pdef(\drm_jazz1).play(quant:0);
			Pdef(\kick3).play(quant:0);
			Pdef(\toms1).play(quant:0);
			Pdef(\bass3).play(quant:0);
		});
	},
//3
	{
		Qt.uant(42*~dur,~offset*~dur-0.01,t,{
			Pdef(\kick3).stop;
			Pdef(\toms1).stop;
			0.01.wait;
			~offset = (t.beats/~dur)%42;
			~effects['universal'].set(\blend,0.3);
			(42*~dur-0.01).wait;
			Pdef(\drm_jazz1).stop;
		})
	},
//4
	{
		Qt.uant(42*~dur,~offset*~dur-0.01,t,{
			Pdef(\kick3).stop;
			Pdef(\drm_jazz1).stop;
			Pdef(\toms1).stop;
			Pdef(\bass3).stop;
			Pdef(\drm_jazz1).stop;
			0.01.wait;
			~offset = (t.beats/~dur)%16;
			Pdef(\drm_jazz2).play(quant:0);
			(32*~dur).wait;
			Pdef(\bass4).play(quant:0);
			(32*~dur).wait;
			Pdef(\kick4).play(quant:0);
			(32*~dur-0.01).wait;
			Pdef(\kick4).stop;
			0.01.wait;
			Pdef(\stick2).play(quant:0);
			Pdef(\kick2).play(quant:0);
			Pdef(\drm_jazz2).stop;
			(32*~dur-0.01).wait;
			Pdef(\stick2).stop;
			Pdef(\drm_jazz2).stop;
			Pdef(\bass4).stop;
			~dur.wait;
			Pdef(\kick2).stop;
		});
	},
//5
	{
		// ~guitar.set(\out,0,\wet,1,\gain,2,\amp,0.45*~amps[\guitar],\tresh,0.00, \del_amp,0.6)
		// ~guitar.set(\amp,~amps[\dist],\out,0,\gain,15,\amount,0.99,\hi_f,1200,\hi_db,(8),\lo_f,180,\lo_db,-2,\wet,1,\del_dist,0.0,\del_long,0.7,\tresh,0,\del_amp,0.2);
		~guitar.set(\amp,~amps[\dist],\out,0,\gain,1,\amount,0.99,\hi_f,440,\hi_db,(8),\lo_f,120,\lo_db,-5,\wet,1,\del_dist,0.0,\del_long,0.7,\tresh,0,\del_amp,0.2);
	},
//6
	{
		// t = TempoClock.default();
		t.beats=32*~dur;
		Q.uant(0,{
			~effects[\brutalize1].set(\gain,~amps[\amen]*1.2);
			Pdef(\amen5).play(quant:0);
			(~dur*0.5).wait;
			Pdef(\amen5).stop;
			(~dur*0.5).wait;
			Pdef(\amen5).play(quant:0);
			(~dur*0.5).wait;
			Pdef(\amen5).stop;
			(~dur*0.5).wait;
			~offset = (t.beats/~dur)%16;
			(t.beats/~dur).postln;
			Pdef(\amen5).stop;
			Pdef(\amen5).play(quant:0);
			Pdef(\bass5).play(quant:0);
			Pdef(\kick5).play(quant:0);

		});
	},
//7
	{
		Qt.uant(32*~dur,~offset*~dur-0.01,t,{
			(t.beats/~dur).postln;
			Pdef(\amen5).stop;
			Pdef(\bass5).stop;
			Pdef(\kick5).stop;
0.01.wait;
			Pdef(\amen6).play(quant:0);
			(~dur*8).wait;
			Pdef(\bass6).play(quant:0);
			Pdef(\kick6).play(quant:0);
			(~dur*8).wait;
			(~dur*8).wait;
			(~dur*8).wait;
			Pdef(\bass6).stop;
			Pdef(\kick6).stop;
			Pdef(\bass7).play(quant:0);
			Pdef(\kick7).play(quant:0);
		})
	},
//8
	{
		Qt.uant(32*~dur,~offset*~dur-0.01,t,{
			Pdef(\bass7).stop;
			Pdef(\kick7).stop;
			0.01.wait;
			Pdef(\bass8).play(quant:0);
			Pdef(\kick8).play(quant:0);
			(~dur*32-0.01).wait;
			Pdef(\amen6).stop;
			Pdef(\bass8).stop;
			Pdef(\kick8).stop;
		})
	},
//9
	{
		t.beats=32*~dur;
		Q.uant(0,{
			Pdef(\amen5).play(quant:0);
			(~dur*0.5).wait;
			Pdef(\amen5).stop;
			(~dur*0.5).wait;
			Pdef(\amen5).play(quant:0);
			(~dur*0.5).wait;
			Pdef(\amen5).stop;
			(~dur*0.5).wait;
			~offset = (t.beats/~dur)%16;
			(t.beats/~dur).postln;
			Pdef(\amen5).stop;
			Pdef(\amen5).play(quant:0);
			Pdef(\bass9).play(quant:0);
			Pdef(\kick9).play(quant:0);
		})
	},
//10
	{
		Qt.uant(32*~dur,~offset*~dur-0.01,t,{
			Pdef(\amen5).stop;
		});
	},
//11
	{
		Pdef(\bass9).stop;
		Pdef(\kick9).stop;
	}
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
	{//ctrl4
		if(~stage%4==3){
			~stage_order_content[~stage].value();
			~stage=~stage+1;
		};
	}
], (0..3));

MIDIdef.program(\danny_stage,{
	|nn,ch|
	var map = ~stage_order[nn];
	[nn,ch].postln;
	if(ch == 3){
		map.value;
		~stage.postln;

	};
});

if(~stage!=0){
	~effects[\jazz]       = Synth.head(nil,\fx_jazz);
	~effects[\brutalize1] = Synth.head(nil,\fx_brutalize1);
	~effects[\brutalize0] = Synth.head(nil,\fx_brutalize0);
	~effects[\fx_del4]    = Synth.head(nil,\fx_del4);
	~effects[\fx_del]     = Synth.head(nil,\fx_del);
	~effects[\compressor] = Synth.head(nil,\fx_compressor);
}
)
s.recordb