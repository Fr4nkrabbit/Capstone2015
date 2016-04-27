function durToWhole(inFloat) //.125 > 8
{
	return parseInt(1 / inFloat)
}

function pitToStr(inHex) //5C > G#6
{
	if (inHex == -1)
	return 'B/4' //rest position


	var note = Vex.Flow.integerToNote(parseInt(inHex, 16) % 12)
	var octave = parseInt(parseInt(inHex, 16) / 12) - 1

	return note + '/' + octave
}

function quantizeNote(inDec) //0.5598958333333334 => 0.5625
{
	var step = 1 / 128
	var skew = inDec % step

	if (skew)
	{
		inDec -= skew
		
		if (skew > step / 2) //round up?
			inDec += step
	}

	return inDec
}


function drawSheets(inM)
{
	//console.log('inM')
	//console.log(inM)
	//console.log(timeSig)

	var timesig =
	{
		top: 4,
		bottem: 4
	};

	var timesig = inM[0].time;

	var keysig =
	{
		name: "C",
		acidentals:[]
	}

	var stoppingPoint = Math.min(inM.length, (LINE_COUNT+STARTING_MEASURE)* MEASURES_PER_LINE)

	for (var mC = STARTING_MEASURE; mC < stoppingPoint; mC++) //loop through measures
	{
		//console.log('measure ' + mC)
		
		var canvas = document.querySelector("canvas")

		//var canvas = $("canvas")[mC]
		var renderer = new Vex.Flow.Renderer(canvas, Vex.Flow.Renderer.Backends.CANVAS)
		var ctx = renderer.getContext()

		//Decide where to draw the measure, or "staff" as Vexflow calls it
		var offsetX = STAFF_OFFSET_X + (mC % MEASURES_PER_LINE) * STAFF_WIDTH
		var offsetY = STAFF_OFFSET_Y * Math.floor((mC-STARTING_MEASURE) / MEASURES_PER_LINE)
		var stave = new Vex.Flow.Stave(offsetX, offsetY, STAFF_WIDTH)

		// Add a treble clef if it's the first measure of the line
		if (mC % MEASURES_PER_LINE == 0)
			stave.addClef("treble")

		if(inM[mC].time)
		{
			stave.addTimeSignature(""+timesig.top+'/'+timesig.bottem)
			timesig =inM[mC].time
		}

		if(inM[mC].key!=undefined)
		{
			keysig.name =inM[mC].key
			keysig.Accidental=[]
			//stave.addKeySignature(keysig.name)
		}

		stave.addKeySignature(keysig.name)
		stave.setContext(ctx).draw()

		//create notes from inM
		var notes = []
		
		var forbeamnotes=[],
		allbeams=[],
		lengthofbeam=0;
		
		var tuplets = []
		var tripletCount = 0 //count to 3, then will create a triplet object
		
		for (var n = 0, i=0; n < inM[mC].m.length; n++) //loop through notes
		{
			//console.log(inM[mC].m[n])
			var decDur = inM[mC].m[n].note
			var pit = pitToStr(inM[mC].m[n].pitch)
			var dur = durToWhole(decDur)
			var dotted = false
			var irregularNote = true
			var tosmall = true

			//Determine if the note is at least normal or dotted
			//for (var p = 0; p < 8 && irregularNote; p++) 
			for (var p = 0; p < 7 && irregularNote; p++) //p = power of 2 to check against
			{
				if (inM[mC].m[n].note * 2 / 3 == 1 / Math.pow(2,p)) //regular dotted
				{
					dur = durToWhole((2/3)*(decDur))
					dur = dur + 'd'
					dotted = true
					irregularNote = false
				}
				else if (decDur == 1 / Math.pow(2,p)) //regular
				{
					irregularNote = false
				}
				else if (decDur == 1 / (3 * Math.pow(2,p))) //regular triplet
				{
					dur = Math.pow(2, p+1)
					tripletCount++
					irregularNote = false
				}
			}
			
			//irregular, triplet or regular
			
			if (irregularNote) //Create a collection of mini-notes to sum to the irregular note
			{
				//console.log('irregular note')
				decDur = quantizeNote(decDur) //round the duration to the nearest 1/128th

				var collection = [] //holds integers of the notes to be added

				for (var t = 0; t < 8 && decDur > 0; t++)
				{
					while (decDur >= 1 / Math.pow(2,t))
					{
						collection.push(Math.pow(2,t))
						decDur -= 1 / Math.pow(2,t)
					}
				}

				//push the notes
				for (var col = 0; col < collection.length; col++)
					notes.push(new Vex.Flow.StaveNote({ keys: [pit], duration: collection[col].toString()}))
			}
			else if (tripletCount > 0)
			{
				//console.log('triplet note')
				
				//console.log('pit ' + pit)
				//console.log('dur ' + dur)
				dur += ''
				notes.push(new Vex.Flow.StaveNote({ keys: [pit], duration: dur }))
				
				if (tripletCount == 3)
				{
					//console.log('just read 3 triplets')
					tripletSet = notes.slice(notes.length-3, notes.length)
					
					tuplets.push(new Vex.Flow.Tuplet(
						tripletSet, 
						{num_notes: 3, 
						notes_occupied: 2}))
					tripletCount = 0
				}
			}
			else //Handle this note normally
			{
				//console.log('normal note')
				dur = dur + (inM[mC].m[n].pitch == -1 ? 'r' : '') //append 'r' if this note is a rest

				//console.log('note' + n + ': ' + dur + ', ' + pit + ', dotted ' + dotted + " + " + inM[mC].m[n].pitch)
				
				//console.log('pit ' + pit)
				//console.log('dur ' + dur)
				notes.push(new Vex.Flow.StaveNote({ keys: [pit], duration: dur }))

				if(dotted)
					notes[notes.length-1].addDotToAll()

				if(!keysig.acidentals.includes(pit) && pit.includes('#'))
					notes[notes.length-1].addAccidental(0, new Vex.Flow.Accidental("#"))
			}
		} //end looping through notes
		//console.log('')
		
		
		
		//Add beams
		allbeams = Vex.Flow.Beam.generateBeams(notes)

		// Create a voice in 4/4
		function create_voice(sig)
		{
			return new Vex.Flow.Voice(
			{
				num_beats:	sig.top,
				beat_value:	sig.bottem,
				resolution:	Vex.Flow.RESOLUTION
			})
		}

		// Create voices and add notes to each of them
		var voice = create_voice(timesig).addTickables(notes)
		
		voice.setMode(2)

		// Format and justify the notes
		var formatter = new Vex.Flow.Formatter().joinVoices([voice]).format([voice], STAFF_WIDTH)

		// Render voice
		voice.draw(ctx, stave)

		// Render beams
		while(allbeams.length)
			allbeams.pop().setContext(ctx).draw()
		
		// Render tuplets
		while(tuplets.length)
			tuplets.pop().setContext(ctx).draw()
		
	} //end looping through measures

	console.log("Successful run!")
    currentMeasures()

}

function startBasicFollow(tempo){
    FOLLOW_TEMPO=tempo/60*1000
    follow()
}

function follow(){
    timer=setTimeout(follow,FOLLOW_TEMPO)
    STARTING_MEASURE++
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    createSheetMusic(string)
    
    //currentMeasures()
}

function turnPage(dir){
    STARTING_MEASURE+= LINE_COUNT*MEASURES_PER_LINE*dir
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    createSheetMusic(string)
    //currentMeasures()
}

function singleMeasure(dir ){
    STARTING_MEASURE+= dir
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    createSheetMusic(string)
}

function singleLine(dir){
    STARTING_MEASURE+= dir*MEASURES_PER_LINE
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    createSheetMusic(string)
    
}
function goToMeasure(meas){
    STARTING_MEASURE=meas
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    createSheetMusic(string)
    
}

function setMeasurePerLine(num){
    MEASURES_PER_LINE=num
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    createSheetMusic(string)
}
function setLineCount(num){
    LINE_COUNT=num
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    createSheetMusic(string)
}


function stopTimer(){
    clearTimeout(timer)
    
    
}
