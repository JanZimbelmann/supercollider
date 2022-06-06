
(
~comp = Synth.after(1,\fx_compressor,[\in,300,\in_car,310]);

~ctrl_order = Order.newFromIndices([
	[\amp,0,1],
	[\amp,0,1],
	[\amp,0,1],
	[\amp,0,1],
], (16..19));

MIDIdef.cc(\semichki_nn1,{
	|vel,nn,ch|
	var name, min, max, value;
	var map = ~ctrl_order[nn];
	name = map[0]; min = map[1]; max = map[2];
	value = vel.linlin(0,127,min,max);
	if(ch == 15){
		[name, value].postln;
		~comp.set(name, value);
	};
});
)