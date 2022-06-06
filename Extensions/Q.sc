Q { *uant {
	arg quant,input;
	^Pbind(
		\amp, Pseq([0],1),
		\foo,Pfunc{input.value()}
	).play(quant:quant)
}
}

Qt { *uant {
	arg quant,offset,t,input;
	^Pbind(
		\amp, Pseq([0],1),
		\foo,Pfunc{input.value()}
	).play(t,quant:[quant,offset])
}
}