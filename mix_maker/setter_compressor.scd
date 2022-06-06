
(
// ~comp = Synth.after(1,\fx_compressor,[\in,300,\in_car,310]);

~ctrl_order = Order.newFromIndices([
	[\attack, 0.0000001,0.1],
	[\release, 0.0000001,0.4],
	[\threshhold, 0,-120],
	[\trim, 0,60],
	[\gain, 0,60],
	[\ratio, 1,20],
	[\lookahead, 0.0,1],
	[\dry_wet, 0,1],
	[\hpf, 10, 1000],
	[\lpf, 15000, 100],
	[\knee, 0.0, 10],
	[\bias, 0.0, 0.5],
	[\saturate, 0, 1],
	[\amp, 0, 1],

], (8..19));
~ctrl_order_info = Dictionary.new();
MIDIdef.cc(\semichki_nn1,{
	|vel,nn,ch|
	var name, min, max, value;
	var map = ~ctrl_order[nn];
	if((ch == 15)&&(nn<=19)&&(nn>=8)){
		name = map[0]; min = map[1]; max = map[2];
		value = vel.linlin(0,127,min,max);
		[name, value].postln;
		//here is the comressor!!!!
		~effects[\compressor].set(name, value);
		~ctrl_order_info['\\'++name]=value;
	};
});
)
~ctrl_order_info.getPairs