
function fromFile()
{
    //plzWait();
    //fName(document.getElementById('file').value);

    if(window.FileReader)
    {
        var reader=new FileReader();
        var f=document.getElementById('file').files[0];
        reader.onload=function(e){
            //console.log(e.target.result)

            parseMidi(e.target.result);};

        reader.readAsBinaryString(f);
    }
    else err('File API is not supported in this browser!');
}





var parsedEvents


function parseMidi(s)
{
  var jzzmf=JZZ.MidiFile.fromBase64(s)
  var mf = new JZZ.MidiFile(jzzmf)
  //console.log(mf)
  var trans=translateMfEvents(mf);
  //console.log(trans)
  var events =gatherEvents(trans)
  //console.log(events)
  var instruments=[]

  for (instrument in events.instruments)
  instruments.push(instrument)

  console.log('instrument list: ')
  console.log(instruments)

  parsedEvents=events
  if(instruments.length==1)
    createSheetMusic(instruments[0])
  else{
      instlister()
      return instruments
  }
}

function createSheetMusic(instrument)
{
  if(parsedEvents==undefined)
    return "no events"

  var notesToShow = combineNotes(parsedEvents.instruments[instrument], parsedEvents.ppqn)

//fix overlapping notes
  notesToShow = forceMonophonic(notesToShow, parsedEvents.ppqn)

//add in rests where there are gaps
  notesToShow = createRest(notesToShow, parsedEvents.ppqn,parsedEvents.timesig)

//console.log(notesToShow)
  var measures=populateMeasures(notesToShow,parsedEvents.ppqn,parsedEvents.keysig,parsedEvents.timesig)

  console.log(measures);
  drawSheets(measures)
}

        //takes a midi file that has been parsed into a 64 bit string and generates sheet music
function readMidiFile(s)
{
    //console.log(s)
    try
    {
        var mf = new JZZ.MidiFile(s)

        //console.log(mf)
        var outMeasures = displayMidiFile(mf)

        drawSheets(outMeasures)
    }
    catch(e){ err(e) }
}


//this takes in a list of midi tracks and there events and returns a list of all the events in string format
var globalppqn;
function translateMfEvents(mf)
{
    globalppqn=mf.ppqn
    var arg =[];

    for (var i = 0; i < mf.length; i++)
    {
        if (mf[i] instanceof JZZ.MidiFile.MTrk)
        {
            for (var j = 0; j < mf[i].length; j++)
            {
                var evt = mf[i][j]
                var s = evt.toString().replace(/&/g,'&amp;').replace(/>/g,'&gt;').replace(/</g,'&lt;')
                arg.push(evt.time + " " + s)
            }
        }
    }
    return arg;
}

function gatherEvents(arg)
{
    var instruments = {}
    var events = {}
    events.notes = []
    events.tempo = []
    events.keysig = []
    events.timesig = []
    events.ppqn = globalppqn
    var lasttime = 0;
    var hitnote = false;
    var title;
    var notes = [];

    for (item in arg)
    {
        var lts = arg[item].split(' ');

//console.log('lts:')
//console.log(lts)

if(lasttime>parseInt(lts[0])&&hitnote)
        {
//console.log('assigning notes to an instrument')
//console.log(title)

console.log('title is '); console.log(title)
var pendingName = "invalid title given"
if (title) pendingName = title.splice(4).join(" ")

            instruments[pendingName] = events.notes;
            events.notes=[]
            hitnote=false
        }
        lasttime=parseInt(lts[0]);

        if(parseInt(lts[1]/10) == 9)
        {
            events.notes.push(lts)
            hitnote=true
        }

if(parseInt(lts[1]/10) == 8)	events.notes.push(lts)
        if(lts[1] == "ff51")	events.tempo.push(lts)
        if(lts[1] == "ff59")	events.keysig.push(lts)
        if(lts[1] == "ff58")	events.timesig.push(lts)

if(lts[1] == "ff03")
        {
            title=lts
//console.log('saw ff03')
//console.log(title)
        }

    }
    if(hitnote)
    {
console.log('title is '); console.log(title)

var pendingName = "invalid title given"
if (title) pendingName = title.splice(4).join(" ")

instruments[pendingName] = events.notes;
        //events.notes=[]
        hitnote=false
    }
    events.instruments=instruments
    return events
}

//this needs to be handed a list of that contains the starts and stops of notes and also the pulse per quater note
function combineNotes(notes,ppqn)
{
    var combined=[]

    //go though and combine the note start and stops
    for (item = 0; item < notes.length; item++)
    {
        if (notes[item][6] == "On")
        {
            for (thing = item+1; thing < notes.length; thing++)
            {
                if (notes[item][2] == notes[thing][2])
                {
                    combined.push(
                                  {
                                  start:	parseInt(notes[item][0]),
                                  finish:	parseInt(notes[thing][0]),
                                  pitch:	notes[item][2],
                                  note:	((notes[thing][0]-notes[item][0])/ppqn)/4
                                  })
                                  break
                }
            }
        }
    }
    return combined
}

//resize notes that overlap
function forceMonophonic(notes, ppqn)
{
	var lastTime = 0

	//console.log('notes: ')
	for (n in notes)
	{
		//console.log(notes[n])
		if (lastTime > notes[n].start)
		{
			///console.log(lastTime + ' vs ' + notes[n].start)
			notes[n-1].finish = notes[n].start //truncate the previous note.finish to end when this note starts
			notes[n-1].note = ((notes[n-1].finish - notes[n-1].start) / ppqn) / 4
		}

		lastTime = notes[n].finish
	}

	//console.log(notes)

	return notes
}

//fills in the gap between notes with rest
function createRest(notes,ppqn,timesig)
{
  //console.log('inside createRest ' + ppqn)
  //console.log(notes)
  var lasttime=0
  var notesWithRest=[]

  for (note in notes)
  {
      //checks to see if the last notes ended when the current note starts
      //to check to see if we need to add something to fill in that gap
      //I used greater that 10 because i noticed that would be a gap of
      // 1 sometimes between notes so i figured we could just use a buffer
      //to make sure we dont create unnescarry rest
      //console.log('note starts at ' + notes[note].start)

      //if (lasttime - notes[note].start <= -10)
      if (notes[note].start - lasttime > 0)
      {
          //console.log ('gap of size ' + (notes[note].start - lasttime))
          notesWithRest.push({
                             start:	lasttime,
                             finish:	notes[note].start,
                             pitch:	-1,
                             note:	((notes[note].start- lasttime)/ppqn) / 4
                             })
      }
      notesWithRest.push(notes[note])
      lasttime=notes[note].finish

      //console.log('lasttime is now ' + lasttime)
  }

//  var trailingRest = lasttime % (ppqn * 4)
  var  lastmeas =timesig[timesig.length-1]
  var trailingRest = lasttime % (4/lastmeas[4].split('/')[0])*ppqn*lastmeas[4].split('/')[0]

  //console.log('lasttime ' + lasttime + ' and whole note ' + (ppqn * 4))

  if (trailingRest > 0)
  {
    var startT = lasttime
    var finishT = lasttime + ((ppqn * 4) - trailingRest)
    //if the last note didn't end the measure, insert a rest
    notesWithRest.push({
                       start:	startT,
                       finish:	finishT,
                       pitch:	-1,
                       note:	((finishT - startT)/ppqn)/4
                       })

                       console.log('trailing rest:')
                       console.log(notesWithRest[notesWithRest.length-1])
  }

  return notesWithRest
}



        //this will take the list of notes and the time signature and then create list
        //of notes that fit into measures
function populateMeasures(notes2,ppqn,keysig,timesig){
  var laststart = -1
  var lastfinish = 0
console.log(ppqn)
	// initial measure; added in to create the initial time measure in order to correctly create the the measures -ER
  var initMeas = {m: []}

  var lastMeas

  var holder
  var measures = []
  var meas
function newMeas(){
  meas = {m: []}

  if(keysig[0]&&lastfinish==parseInt(keysig[0][0])) {
    meas.key=keysig[0][4]
    keysig=keysig.slice(1)
  }

  if(timesig[0]&&lastfinish==parseInt(timesig[0][0]))
  {
    meas.time =
    {
        top:		timesig[0][4].split('/')[0],
        bottem:	timesig[0][4].split('/')[1]
    }
    lastMeas =
    {
      top: timesig[0][4].split('/')[0],
      bottom: timesig[0][4].split('/')[1]
    }

    timesig=timesig.slice(1)
  }


}

  newMeas()
  var ppqmeas = (lastMeas.top/lastMeas.bottom)*ppqn*4 // running counter of the ending pulse of the currently read measures

    //populate measures
    for (noter in notes2)
    {
      if(notes2[noter].start >= ppqmeas)
      {
        //adds a measures if the note we are about to look at is in another measure
        //console.log(notes2[noter].start)
        //console.log(ppqmeas)
        //console.log("push a measure")
        measures.push(meas)
        newMeas()
        console.log(lastMeas.bottom)
        console.log(lastMeas.top)
        ppqmeas += (lastMeas.top/lastMeas.bottom)*ppqn*4
      }


      if (notes2[noter].finish > ppqmeas)
      {
          //for notes that go over a measure and need to be split into notes for each indivdual measure
        while (notes2[noter].finish > ppqmeas)
        {
          meas.m.push({
                      start:	notes2[noter].start,
                      finish:	ppqmeas,
                      pitch:	notes2[noter].pitch,
                      note:	((ppqmeas-notes2[noter].start) / ppqn)/4,
                      tie: true
                      })
                      notes2[noter].start = ppqmeas
                      notes2[noter].note = ((  notes2[noter].finish-notes2[noter].start)/ppqn)/4

                      //console.log(ppqmeas)
                      measures.push(meas)

                      newMeas()
                      ppqmeas += (lastMeas.top/lastMeas.bottom)*ppqn*4

                      notes2[noter].tie=true
        }
      }

      //add note
      meas.m.push(notes2[noter])
      lastfinish = notes2[noter].finish
    }

    //console.log("pushing last measure")
    measures.push(meas)
    return measures
}
