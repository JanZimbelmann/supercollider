
(	// to be put to Platform.userConfigDir +/+ "startup.scd"

~serverBootFunc = { |server|

        var wtsize, wtpaths, wtbuffers;

	"-----------wavetables begin-----------".postln;


	wtsize = 4096;
	wtpaths = "/home/kaoboi/studio/superc/wavetable/akwavefiles/AKWF_0002/4096/*".pathMatch;
	// wtbuffers = Buffer.allocConsecutive(wtpaths.size, s, 2048, 1, );
	wtbuffers = Buffer.allocConsecutive(wtpaths.size, s, wtsize * 2, 1, );
	wtpaths.do { |it i| wtbuffers[i].read(wtpaths[i])};


	~wtbufnums = List[];
	~wavetables = ();


	wtpaths.do { |it i|
		var name = wtbuffers[i].path.basename.findRegexp(".*\.wav")[0][1].splitext[0];
		var buffer = wtbuffers[i].bufnum;
		~wavetables[name.asSymbol] = buffer;
		~wtbufnums.add(buffer);
	};


	"-----------wavetables end-----------".postln;
};

ServerBoot.add(~serverBootFunc, \default);
);