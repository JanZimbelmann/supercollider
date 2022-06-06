Zs.scope
~midi.value()
(

~dur=71.04.durtempo;
~b0.zero;
// Pdef(\v1, Pseq([~v1_0,~v1_1,~v1_0,~v1_2],inf)).play;
// s.record;
~subamp=0.05;
~stage = 2;
~offset=4;
~vamp= 1;
Synth.after(1,\fx,[\blend, 0.3,\duration, ~dur/16, \amp, 0.15]);

~comp = Synth.after(1,\fx_compressor,[\in,290,\in_car,290,\out,0,\dry_wet, 0, \release, 0.037795366141732, \trim, 4.7244094488189, \lpf, 686.61417322835, \ratio, 12.070866141732, \threshhold, 0, \knee, 0.0, \attack, 0.030708730708661, \gain, 8.503937007874, \hpf, 251.65354330709, \lookahead, 0.0, \bias, 0.24803149606299,\amp,1]);
~side = Synth.after(1,\fx_compressor,[\in,300,\in_car,310,\out,290, \dry_wet, 0.031496062992126, \trim, 15.11811023622, \lpf, 1155.905511811, \ratio, 7.1338582677165, \threshhold, (-28.346456692913), \knee, 0.078740157480315, \attack, 0.014173314173228, \release, 0.10598432047244, \gain, 1.4173228346457, \hpf, 25.590551181102, \lookahead, 0.0, \bias, 0.090551181102362,\amp,1]);

~looper0 = Synth.after(1,\looper_fix,[\buf,~b0.bufnum,\in,50,\out,0,\mic_amp,1]);
~delay0 = Synth.after(1,\fx_delay,[\in, 330, \out, 0, \pan0, -0.8, \pan1, 0.8,\length, ~dur/3,\blend,0.04]);
~delay1 = Synth.after(1,\fx_delay,[\in, 340, \out, 0, \pan0, 0.8, \pan1, -0.8,\length, ~dur/3,\blend,0.04]);

~guitar = Synth(\guitar_buddha,[\out, 50]);
~guitar_clean = {~guitar.set(\amp, 2.9, \amount, 0.06, \pre_gain, 13, \post_gain,0.3, \hi_db, 7, \lo_db, 3,\blend,0.3,\length,~dur,\length_mult,8,\pf, 440,\p_rq,4,\p_db,6)};
~guitar_dist = {~guitar.set(\amp, 1.8, \amount, 0.95, \pre_gain, 20, \post_gain, 0.5, \hi_db, 1, \lo_db, -1.5, \blend,0.125,\length,~dur,\length_mult,8,\pf, 880,\p_rq,2,\p_db,2)};
~guitar_solo = {~guitar.set(\amp, 1.42, \amount, 0.99, \pre_gain, 20, \post_gain, 1, \hi_db, 1, \lo_db, 0.5, \blend,0.25,\length,~dur/2,\length_mult,16,\pf, 2880,\p_rq,2,\p_db,2)};
// s.record;

~guitar_clean.value();
// ~guitar_dist.value();
// ~guitar_solo.value();
~stage_order_content = [
//0
	{
		0.postln;
	},
//1
	{
		0.postln;
	},
//2
	{
		t = TempoClock.default();
		t.beats=16*~dur;
		Qt.uant(~dur*16,0,t,{
			Pdef(\drums).play(quant:0);
			Pdef(\v0).play(quant:0);

			(~dur*4).wait;
			~offset = (t.beats/~dur)%16;
			Pdef(\v0).stop;
			Pdef(\drums).stop;
			Pdef(\v0).play(quant:0);
			Pdef(\drums).play(quant:0);
			Pdef(\dubstep).play(quant:0);
			Pdef(\sub).play(quant:0);
		});
	},
//3
	{
		Qt.uant(~dur*16,~offset*~dur-0.01,t,{
			// Pdef(\drums).stop;
			Pdef(\v0).stop;
			Pdef(\dubstep).stop;
			Pdef(\sub).stop;
			0.01.wait;
			Pdef(\sub2).play(quant:0);
			Pdef(\v1).play(quant:0);
			~offset = (t.beats/~dur)%24;
		});
	},
//4
	{
		Qt.uant(~dur*24,~offset*~dur-0.01,t,{
			Pdef(\sub2).stop;
			Pdef(\v1).stop;
			// Pdef(\drums).stop;
			0.01.wait;
			Pdef(\v0).play(quant:0);
			Pdef(\dubstep).play(quant:0);
			Pdef(\sub).play(quant:0);
			~offset = (t.beats/~dur)%16;
		});
	},
//5
	{
		Qt.uant(~dur*16,~offset*~dur-0.01,t,{
			Pdef(\v0).stop;
			Pdef(\drums).stop;
			Pdef(\dubstep).stop;
			Pdef(\sub).stop;
			Pdef(\sub2).stop;
			0.01.wait;
			Pdef(\v2).play(quant:0);
			((16+16+4+4+8)*~dur).wait;
			Pdef(\sub3).play(quant:0);
			((8*~dur).wait);
			~looper0.set(\trig, 1, \run, 1, \rec_lev, 1, \pre_lev, 1, \xfade, 0.01, \mic_amp, 1);
		});
	},
//6
	{
		~guitar_dist.value();
	},
//7
	{
		~looper0.set(\rec_lev, 0);
		~guitar_solo.value();
	},
//8
	{
		t = TempoClock.default();
		t.beats=16*~dur;
		Qt.uant(~dur*16,0,t,{
			Pdef(\v2).stop;
			Pdef(\sub3).stop;
			~looper0.set(\xfade, 0.3, \loop_amp, 0);
			Pdef(\drums).play(quant:0);
			(~dur*4).wait;
			~subamp= 0.04;
			~offset = (t.beats/~dur)%16;
			Pdef(\drums).stop;
			Pdef(\v0).play(quant:0);
			Pdef(\drums).play(quant:0);
			// Pdef(\dubstep).play(quant:0);
			Pdef(\sub).play(quant:0);
		});
	},
//8
	{
		Pdef(\v0).stop;
		Pdef(\drums).stop;

	},
//9
	{
		Qt.uant(~dur*16,~offset*~dur-0.01,t,{
			~guitar_clean.value();
			Pdef(\v0).stop;
			Pdef(\drums).stop;
			Pdef(\dubstep).stop;
			Pdef(\sub).stop;
			Pdef(\sub2).stop;
			0.01.wait;
		});
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

MIDIdef.cc(\buddha_nn1,{
	|vel,nn,ch|
	(1-(vel/127)).postln;
	~comp.set(\amp,1-(vel/127));
	// ~b0.zero;
},chan:3);
MIDIdef.program(\buddha_stage,{
	|nn,ch|
	var map = ~stage_order[nn];
	[nn,ch].postln;
	if(ch == 3){
		map.value;
		~stage.postln;
	};
});


)
43.midicps