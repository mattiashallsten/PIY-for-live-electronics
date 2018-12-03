(
/*
|-------------SELECT WHAT TO CONTROL----------|
Here you select what to control. Change the control variable (currently says '/freq') to one of the following:

* '/freq'					controls the "middle pitch"
* '/time'					controls the tempo
* '/freqRange'				controls the pitch range
* '/timeChance'				controls the probability of 16th notes instead of 8th notes
* '/legato'					controls the legato parameter
* '/velCenter'				controls the velocity
* '/reverb'					controls the amount of reverb
*/
var control = '/freq';

/*
|----------WHERE TO SEND OSC---------|
Here you select where to send the control. Change the destination variable (currently says \sc) to one of the following:

* \sc						send to SuperCollider
* \pd						send directly to PD
*/
var destination = \pd;

var ipOut = "127.0.0.1";
var toPD = NetAddr.new(
	ipOut,
	switch(destination,
		\sc, {57120},
		\pd, {8000}
	)
);
var window = Window("params", Rect(100,100,100,400));

var font = Font.monospace(13);

var slider,ccSelector,listen,listenFunc,sliderFunc,ipSelect;


var listening = 0;

var ccNum = 41;

var freqState = 0.5;
var tempoState = 0.5;
var freqRangeState = 0.5;
var tempoChanceState = 0.5;
var legatoState = 0.5;

MIDIClient.init;
MIDIIn.connectAll;

window.layout = VLayout(
	HLayout(
		StaticText().string_("IP: " ++ ipOut).font_(Font.monospace(16)).align_(\center),
	),

	HLayout(
		StaticText().string_("cc: ").font_(font),
		ccSelector = PopUpMenu().items_(Array.fill(128, {|i| i.asString})).allowsReselection_(true).font_(font),
		listen = Button().states_([["Listen", Color.black, Color.white], ["Listening", Color.black, Color.green]]).font_(font),

	),
	slider = Slider();
);



slider.action = {|i|
	toPD.sendMsg(control, i.value);
};

listen.action = {|i|
	if(i.value == 1, {
		/*listenFunc = MIDIdef.cc(\listen, {|val,num|
			{ccSelector.valueAction_(num)}.defer;
			{listen.value = 0}.defer;
			listenFunc.free;

		})*/
		listenFunc = MIDIFunc.cc({|val,num|
			{ccSelector.valueAction_(num)}.defer;
			{listen.value = 0}.defer;
			listenFunc.free
		})
	}, {
		if(listenFunc, {
			listenFunc.free;
		})
	}
	)

};


ccSelector.action = {|i|
	ccNum = i.value;
};

sliderFunc = MIDIFunc.cc({|val,num|
	if(num == ccNum, {
		{slider.valueAction_(val/127)}.defer
	});
});

window.front;
)
