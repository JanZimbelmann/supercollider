(
~drumkit = Dictionary.new;
~drumkit['buddha']={
	~b['buddha_kit'] = Array.new;
	~folder = PathName.new("/home/kaoboi/studio/superc/thatfatbuddhabad/drumkit/");

	~folder.entries.do({
		arg path;
		path.postln;
		~b['buddha_kit'] = ~b['buddha_kit'].add(Buffer.read(s, path.fullPath));
	});
};

/*~drumkit['init']={
	~samples['dk'] = Array.new;
	~folder = PathName.new("/home/kaoboi/studio/superc/kick/_samples/");

	~folder.entries.do({
		arg path;
		~samples['dk'] = ~samples['dk'].add(Buffer.read(s, path.fullPath));
	});
};*/
)