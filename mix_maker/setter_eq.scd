~midi.value()
MIDIdef .trace(true)
(
// ~comp = Synth.after(1,\fx_compressor,[\in,300,\in_car,310]);

~ctrl_order = Order.newFromIndices([
	4,0,5,1,6,2,7,3,], (8..15)
);
// ~ctrl_order_info = Dictionary.new();
MIDIdef.cc(\semichki_nn1,{
	|vel,nn,ch|
	var name, value;
	var map = ~ctrl_order[nn];
	if((ch == 15)&&(nn<=15)&&(nn>=8)){
		value = vel.linlin(0,127,-10,10);

		['eqs', [55,110,330,880,1760,2640,4800,7040][map], value].postln;
		~stats_ds[\eqs][map] = value;
	};
	if((ch == 15)&&(nn==19)){
		value = vel.linlin(0,127,0.01,2);
		['rq', map, value].postln;
		~stats_ds[\rq] = value;
	};
	if((ch == 15)&&(nn==18)){
		value = vel.linlin(0,127,0.01,2);
		['amp', map, value].postln;
		~stats_ds[\amp] = value;
	};
	if((ch == 15)&&(nn==17)){
		value = vel.linlin(0,127,0.0,1.0);
		['blend', map, value].postln;
		~stats_ds[\blend] = value;
	};
});
)
)
~ctrl_order_info.getPairs
~eqs

~stats_ds[\eqs] = [ 3.3858267716535, 5.9055118110236, 4.9606299212598, 4.9606299212598, 6.6929133858268, 3.5433070866142, 5.1181102362205, -0.078740157480315 ];
~stats_ds[\amp] = 0.74645669291339;
~stats_ds[\blend] = 0.54330708661417;
~stats_ds[\rq] = 1.5612598425197;