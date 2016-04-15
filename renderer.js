
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

	    var stoppingPoint = Math.min(inM.length, LINE_COUNT* MEASURES_PER_LINE)

            for (var mC = 0; mC < stoppingPoint; mC++)
            {
		var canvas = document.querySelector("canvas")

                //var canvas = $("canvas")[mC]
                var renderer = new Vex.Flow.Renderer(canvas, Vex.Flow.Renderer.Backends.CANVAS)
                var ctx = renderer.getContext()

		//Decide where to draw the measure, or "staff" as Vexflow calls it
		var offsetX = STAFF_OFFSET_X + (mC % MEASURES_PER_LINE) * STAFF_WIDTH
		var offsetY = STAFF_OFFSET_Y * Math.floor(mC / MEASURES_PER_LINE)
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

                //console.log('measure ' + mC)
                var forbeamnotes=[],
                allbeams=[],
                lengthofbeam=0;

    for (var n = 0, i=0; n < inM[mC].m.length; n++)
    {
                    //console.log(inM[mC].m[n])
			var decDur = inM[mC].m[n].note
			var pit = pitToStr(inM[mC].m[n].pitch)
			var dur = durToWhole(decDur)
			var dotted = false
			var irregularNote = true
			var tosmall = true

			//Determine if the note is at least normal or dotted
			for (var p = 0; p < 8 && irregularNote; p++)
			{
				if (inM[mC].m[n].note * 2 / 3 == 1 / Math.pow(2,p))
				{
					dur = durToWhole((2/3)*(decDur))
					dur = dur + 'd'
					dotted = true
					irregularNote = false
				}
				else if (decDur == 1 / Math.pow(2,p))
				{
					irregularNote = false
				}
			}


			if (irregularNote)
			{
				//Create a collection of mini-notes to sum to the irregular note

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
			else
			{
				//Handle this note normally
				dur = dur + (inM[mC].m[n].pitch == -1 ? 'r' : '') //append 'r' if this note is a rest

				//console.log('note' + n + ': ' + dur + ', ' + pit + ', dotted ' + dotted + " + " + inM[mC].m[n].pitch)
				notes.push(new Vex.Flow.StaveNote({ keys: [pit], duration: dur }))

				if(dotted)
					notes[notes.length-1].addDotToAll()

				if(!keysig.acidentals.includes(pit) && pit.includes('#'))
					notes[notes.length-1].addAccidental(0, new Vex.Flow.Accidental("#"))
			}
    }
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

                // Format and justify the notes
                var formatter = new Vex.Flow.Formatter().joinVoices([voice]).format([voice], STAFF_WIDTH)

                // Render voice
                voice.draw(ctx, stave)

                while(allbeams.length)
		{
			allbeams.pop().setContext(ctx).draw();
		}
            }

		console.log("Successful run!")
        }
