~path_tiktok = "/home/kaoboi/.local/share/SuperCollider/tiktoks/";
~path = PathName(thisProcess.nowExecutingPath).parentPath;
(~path++"wavetable.scd").load;
(~path++"piano.scd").load;
(~path++"guitar.scd").load;
(~path++"effects.scd").load;
(~path++"exe_synthdefs.scd").load;
(~path++"exe_drumkit.scd").load;
(~path++"buffers.scd").load;
(~path++"SLCOrchestra.scd").load;

s.options.numInputBusChannels = 6;
s.options.memSize_(2**15);
(
~midi = {
MIDIClient.init;
m = MIDIOut(0);
m.connect(0);
MIDIIn.connectAll;
};
);
~midi.value();