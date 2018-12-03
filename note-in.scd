(
/*
|--------------NOTE IN----------|

Connect all the MIDI equipment and change to the correct IP address before evaluating.

*/
var ipOut = "127.0.0.1";


var toPD = NetAddr.new(ipOut, 57120);
var window = Window("params", Rect(100,100,200,300));

var text;
var state = '';

var chrom = [
	"C ",
	"C#",
	"D ",
	"D#",
	"E ",
	"F ",
	"F#",
	"G ",
	"G#",
	"A ",
	"A#",
	"B "
];

MIDIClient.init;
MIDIIn.connectAll;

MIDIFunc.noteOn({|val,num|

	var str = "key: " ++ chrom[num%12];

	defer { text.string_(str) };

	toPD.sendMsg('/transpose', num%12)
});

window.layout = VLayout(
	text = StaticText().string_("key: C ").align_(\center).font_(Font.monospace(30)),
);

window.front;
)
