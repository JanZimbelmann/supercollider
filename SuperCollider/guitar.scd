~guitar  = Synth(\guitar_opeth,[\out,0,\amp,0.1,\gain,5]);
44.play

~guitar.set(\amp, ~gamp_d,\gain,2);
~reverb = Synth.after(1,\reverb,[\in,80,\out,0,\wetdry,0.3]);
~dnb.value(1)
(
~b0.zero;
~b1.zero;
~b2.zero;
~b3.zero;
~b4.zero;
~out_loop = 0;
~voc = Synth(\vocal,[\out,0,\gain, 10,\amp,1]);
~reverb = Synth.after(1,\reverb,[\in,80,\out,0,\wetdry,0.3]);

~looper0 = Synth.after(1,\looper_flex,[\buf,~b0.bufnum,\in,50,\out,~out_loop]);
~looper1 = Synth.after(1,\looper_fix,[\buf,~b1.bufnum,\in,50,\out,~out_loop,\mic_amp,0]);
~looper2 = Synth.after(1,\looper_fix,[\buf,~b2.bufnum,\in,50,\out,~out_loop,\mic_amp,0]);
~looper3 = Synth.after(1,\looper_fix,[\buf,~b3.bufnum,\in,50,\out,~out_loop,\mic_amp,0]);
~looper4 = Synth.after(1,\looper_fix,[\buf,~b4.bufnum,\in,50,\out,~out_loop,\mic_amp,0]);
~amp=0.5;
~gamp_a = 0.5*~amp;
~ggain_a = 0.02;
~gamp_d = 0.15*~amp;
~ggain_d = 2;
~gamp_s = 1.2*~gamp_d;
~guitar  = Synth(\guitar_opeth,[\out,190,\amp,~gamp_a,\gain,~ggain_a]);
~sus_guitar = Synth.after(1,\sus_universal,[\in, 190,\out, 50,\lev,0.4]);
~stage=0;
~eff1=0.0;
~sus = 0;
// {FreeVerb.ar(HPF.ar((SoundIn.ar(1)!2*25).tanh,120))}.play;
MIDIdef.cc(\cc_pedal,{
	arg vel, nn , b, c;
	if((vel>0)&&(nn==3)&&(~sus==0)){~sus=1;~sus.postln;
		~sus_guitar.set(\run, ~sus);
	};
	if((vel==0)&&(nn==3)&&(~sus==1)){~sus=0;~sus.postln;
		~sus_guitar.set(\run, ~sus);
	};

	if((vel==127)&&(nn==1)){
		[vel,~stage].postln;
		if(~stage==0){
			~looper0.set(\trig, 1, \run, 1, \rec_lev, 1, \pre_lev, 1, \xfade, 0.02);
		};
		if(~stage==1){
			~looper0.set(\run, 0, \rec_lev, 0, \pre_lev, 1);
		};
		if(~stage==2){
			~guitar.set(\eff1, ~eff1);
			~looper0.set(\loop_amp, 0,\xfade, 0.3);
		};
		if(~stage==3){
			~looper0.set(\loop_amp, 1,\retrig, 1, \xfade, 0);
		};
		if(~stage==4){
			~looper0.set(\loop_amp,0,\xfade,1);
		};
		if(~stage==5){
			Routine{
				~looper0.free;
				~looper1.set(\mic_amp,1);
				a = Pbind(\amp, 0.2,\dur,~dur*6*Pseq([1],2)).play(quant:12*~dur);
				(~dur*12).wait;
				Q.uant(~dur*12,{
					~guitar.set(\amp, ~gamp_d,\gain,~ggain_d);

					~looper1.set(\trig, 1, \run, 1, \rec_lev, 1, \pre_lev, 1, \xfade, 0.02, \mic_amp, 1);
					~dnb.value(1);
				});
			}.play;
		};
		if(~stage==6){
			~looper1.set(\mic_amp,1,\rec_lev,0);
			~guitar.set(\eff1, 1);
		};
		if(~stage==7){
			~looper1.set(\mic_amp,0,\rec_lev,0);
			~looper2.set(\trig, 1, \run, 1, \rec_lev, 1, \pre_lev, 1, \xfade, 0.02, \mic_amp, 1);
		};
		if(~stage==8){
			~looper2.set(\mic_amp,1,\rec_lev,0);
			~guitar.set(\amp, ~gamp_s, \eff1, 1);
		};
		if(~stage==9){
			Q.uant(~dur*12,{
				~looper1.set(\mic_amp,0);
				~looper1.set(\loop_amp,0,\xfade,1);
				~looper2.set(\mic_amp,0);
				~looper2.set(\loop_amp,0,\xfade,1);
				~looper3.set(\trig, 1, \run, 1, \rec_lev, 1, \pre_lev, 1, \xfade, 0.02, \mic_amp, 1);
				~guitar.set(\amp, ~gamp_d, \eff1, 0.2);
				~dnb.value(2);
			});
		};
		if(~stage==10){
			~looper1.free;
			~looper2.free;
			~looper3.set(\mic_amp,1,\rec_lev,0);
			~guitar.set(\amp, ~gamp_d, \eff1, 1);
		};
		if(~stage==11){
			~looper3.set(\mic_amp,1,\rec_lev,1);
		};
		if(~stage==12){
			~looper3.set(\mic_amp,1,\rec_lev,0);
			~guitar.set(\amp, ~gamp_s, \eff1, 1);
		};
		if(~stage==13){
			Q.uant(~dur*12,{
				~looper3.set(\mic_amp,0);
				~looper3.set(\loop_amp,0,\xfade,1);
				~looper4.set(\trig, 1, \run, 1, \rec_lev, 1, \pre_lev, 1, \xfade, 0.02, \mic_amp, 1);
				~guitar.set(\amp, ~gamp_d,\gain,~ggain_d,\eff1,0);

				~dnb.value(3);
			});
		};
		if(~stage==14){
			~looper3.free;
			~looper4.set(\mic_amp,1,\rec_lev,0);
			~guitar.set(\eff1, 0);
		};
		if(~stage==15){
			Q.uant(~dur*12,{
				~looper4.set(\loop_amp, 0,\xfade, 0.3);
				~dnb.value(4);
			});
		};

		~stage = ~stage+1;

	}
})
)
s.scope
s.makeWindow