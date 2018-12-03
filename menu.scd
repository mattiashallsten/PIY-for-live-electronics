(
/*
|-------------SELECT WHAT TO CONTROL----------|
Here you select what to control. Change the control variable (currently says '/freq') to one of the following:

* '/onOff'					turn it on or off
* '/suspedal'				turn on or off the sustain pedal
* '/chord'					controls if there can be chords played
* '/transpose'				change the root note
* '/scale'					change modality: major, minor och harmonic minor
*/
var control = '/chord';

/*
|----------WHERE TO SEND OSC---------|
Here you select where to send the control. Change the destination variable (currently says \sc) to one of the following:

* \sc						ésend to SuperCollider
* \pd						send directly to PD
*/
var destination = \sc;
var ipOut = "127.0.0.1";
var toPD = NetAddr.new(
	ipOut,
	switch(destination,
		\sc, {57120},
		\pd, {8000}
	)
);
var window = Window("selections", Rect(100,100,200,150));

var font = Font.monospace(16);

var menu,selector,ipSelect;
var state = '/onOff';

var onOffState = 0;
var scaleState = 0;
var keyState = 0;

var label = control.asString.replace("/", "");

label = label.replace(label[0], label[0].toUpper);

window.layout = VLayout(
	HLayout(
		StaticText().string_("ip: " ++ ipOut).align_(\center).font_(font),

	),

	StaticText().string_(label).align_(\center).font_(font),
	menu = PopUpMenu().items_(
		switch(control,
			'/onOff', {["Off", "On"]},
			'/suspedal', {["Off", "On"]},
			'/chord', {["Off", "On"]},
			'/scale', {["Major", "Minor", "Harmonic Minor"]},
			'/transpose', {[
				"C",
				"C#",
				"D",
				"Eb",
				"E",
				"F",
				"F#",
				"G",
				"G#",
				"A",
				"Bb",
				"B"
			]}
		)
	)
	.allowsReselection_(true)
	.font_(font)

);



menu.action = {|i|
	switch(control,
		'/onOff', {
			toPD.sendMsg(control, i.value);
			onOffState = i.value;
		},
		'/scale', {
			toPD.sendMsg(control, i.value + 1);
			scaleState = i.value;
		},
		'/transpose', {
			toPD.sendMsg(control, i.value);
			keyState = i.value;
		},
		'/chord', {
			toPD.sendMsg(control, i.value);
		},
		'/suspedal', {
			toPD.sendMsg(control, i.value);
		}
	)

};

window.front;
)
