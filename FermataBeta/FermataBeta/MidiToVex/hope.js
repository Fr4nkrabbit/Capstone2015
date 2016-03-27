function err(e)	{/*document.getElementById('midi').innerHTML='<span class=err>'+e+'</span>';*/}
function plzWait()	{/*document.getElementById('midi').innerHTML='<span class=wait>One moment please...</span>';*/}
function fName(s)	{/*document.getElementById('fname').innerHTML='<tt>'+s+'</tt>';*/}
var b64='\
TVRoZAAAAAYAAQADAGRNVHJrAAAAGgD/AwtMaXR0bGUgTGFtYgD/UQMKLCsA/y8ATVRyawAAAPEA/wMF\
V29yZHMA/wEYQFRNYXJ5IEhhZCBBIExpdHRsZSBMYW1iZP8BA1xNYTL/AQNyeSAy/wEEaGFkIDL/AQJh\
IDL/AQNsaXQy/wEEdGxlIDL/AQVsYW1iLGT/AQQvTGl0Mv8BBHRsZSAy/wEFbGFtYixk/wEEL0xpdDL/\
AQR0bGUgMv8BBWxhbWIsZP8BAy9NYTL/AQNyeSAy/wEEaGFkIDL/AQJhIDL/AQNsaXQy/wEEdGxlIDL/\
AQVsYW1iLGT/AQYvQmxhaC0y/wEFYmxhaC0y/wEFYmxhaC0y/wEFYmxhaC0y/wEFYmxhaCEA/y8ATVRy\
awAAALkA/wMFTXVzaWMAwAtkkEB/MkAAAD5/Mj4AADx/MjwAAD5/Mj4AAEB/MkAAAEB/MkAAAEB/WkAA\
Cj5/Mj4AAD5/Mj4AAD5/Wj4ACkB/MkAAAEN/MkMAAEN/WkMACkB/MkAAAD5/Mj4AADx/MjwAAD5/Mj4A\
AEB/MkAAAEB/MkAAAEB/WkAACj5/Mj4AAD5/Mj4AAEB/MkAAAD5/Mj4AADx/ZEBkAENkAEh/WjwAAEAA\
AEMAAEgACv8vAA=='

function fromFile()
{
    plzWait()
    fName("Bach__Invention_No._13.mid")
    
    if (window.FileReader)
    {
        var reader = new FileReader()
        var f = document.getElementById('file').files[0]
        reader.onload = function(e)
        {readMidiFile(e.target.result)}
        reader.readAsBinaryString(f)
    }
    else
        err('File API is not supported in this browser!')
        }

function readMidiFile(s)
{
    alert("HI!")
    return "hello"
    try
    {
        var mf = new JZZ.MidiFile(s)
        var outMeasures = displayMidiFile(mf)
        
        drawSheets(outMeasures)
    }
    catch(e)
    {err(e)}
}

function displayMidiFile(mf)
{
    var ppqn = mf.ppqn
    var arg = []
    var notes = []
    var tempo = []
    var keysig = []
    var timesigs = []
    var measures = []
    var meas = []
    
    //populate arg[]
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
    
    var item, thing
    var notes2 = []
    var singlemeasure = []
    
    //separate midi events by type
    for (item in arg)
    {
        var lts = arg[item].split(' ');
        
        if(lts[1] / 10 == 9)	notes.push(lts)
            if(lts[1] / 10 == 8)	notes.push(lts)
                if(lts[1] == "ff51")	tempo.push(lts)
                    if(lts[1] == "ff59")	keysig.push(lts)
                        if(lts[1] == "ff58")	timesigs.push(lts)
                            }
    
    //populate notes2
    for (item = 0; item < notes.length; item++)
    {
        if (notes[item][6] == "On")
        {
            for (thing = item+1; thing < notes.length; thing++)
            {
                if (notes[item][2] == notes[thing][2])
                {
                    notes2.push(
                                {
                                start:	notes[item][0],
                                finish:	notes[thing][0],
                                pitch:	notes[item][2],
                                note:	((notes[thing][0]-notes[item][0])/ppqn)/4
                                })
                    break
                }
            }
        }
    }
    
    var laststart = -1
    var lastfinish = 0
    var ppqmeas = ppqn*4
    var holder
    
    //populate measures
    for (noter in notes2)
    {
        if (lastfinish < notes2[noter].start)
        {
            //add rests here will need to loop
            while (lastfinish != notes2[noter].start)
            {
                if (ppqmeas < notes2[noter].start)
                {
                    meas.push(
                              {
                              start:	lastfinish,
                              finish:	ppqmeas,
                              pitch:	-1,
                              note:	((ppqmeas-lastfinish)/ppqn)/4
                              })
                    lastfinish = ppqmeas<notes2[noter].start ? ppqmeas : notes2[noter].start
                    measures.push(meas)
                    ppqmeas += ppqn*4
                    meas = []
                }
                else
                {
                    meas.push(
                              {
                              start:	lastfinish,
                              finish:	notes2[noter].start,
                              pitch:	-1,
                              note:	((notes2[noter].start-lastfinish)/ppqn)/4
                              })
                    lastfinish = notes2[noter].start
                }
            }
        }
        
        if (notes2[noter].finish > ppqmeas)
        {
            //split note between measure will need to loop
            while (notes2[noter].finish > ppqmeas)
            {
                meas.push(
                          {
                          start:	notes2[noter].start,
                          finish:	ppqmeas,
                          pitch:	notes2[noter][2],
                          note:	((ppqmeas-notes2[noter].start)/ppqn)/4
                          })
                notes2[noter].start = ppqmeas
                ppqmeas += ppqn*4
                measures.push(meas)
                meas = []
            }
            lastfinish = notes2[noter].finish
        }
        else if (notes2[noter].finish == ppqmeas)
        {
            //add note and add meas
            meas.push(notes2[noter])
            measures.push(meas)
            ppqmeas += ppqn*4
            meas = []
            lastfinish = notes2[noter].finish
        }
        else
        {
            //add note
            meas.push(notes2[noter])
            lastfinish = notes2[noter].finish
        }
    }
    return measures
}
</script>

<!-- Measures to VexFlow -->
<script>
function durToWhole(inFloat) //.125 > 8
{
    return 1 / inFloat
}

function pitToStr(inHex) //5C > G#6
{
    if (inHex == -1) 
        return 'B/4' //rest position
        
        var note = Vex.Flow.integerToNote(parseInt(inHex, 16) % 12)
        var octave = parseInt(parseInt(inHex, 16) / 12)
        
        return note + '/' + octave
        }

function drawSheets(inM)
{
    for (var mC = 0; mC < inM.length; mC++)
    {
        var canvas = $("canvas")[0]
        //var canvas = $("canvas")[mC]
        var renderer = new Vex.Flow.Renderer(canvas, Vex.Flow.Renderer.Backends.CANVAS)
        var ctx = renderer.getContext()
        var stave = new Vex.Flow.Stave(STAFF_OFFSET_X, STAFF_OFFSET_Y * mC, CANVAS_WIDTH)
        
        // Add a treble clef
        stave.addClef("treble")
        stave.setContext(ctx).draw()
        
        //create notes from inM
        var notes = []
        
        console.log('measure ' + mC)
        for (var n = 0; n < inM[mC].length; n++)
        {	
            var pit = pitToStr(inM[mC][n].pitch)
            var dur = durToWhole(inM[mC][n].note) + (inM[mC][n].pitch == -1 ? 'r' : '') //append 'r' if this note is a rest
            console.log('note' + n + ': ' + dur + ', ' + pit)
            notes.push(new Vex.Flow.StaveNote({ keys: [pit], duration: dur }))
        }
        console.log('')
        
        // Create a voice in 4/4
        function create_4_4_voice()
        {
            return new Vex.Flow.Voice(
                                      {
                                      num_beats:	4,
                                      beat_value:	4,
                                      resolution:	Vex.Flow.RESOLUTION
                                      })
        }
        
        // Create voices and add notes to each of them
        var voice = create_4_4_voice().addTickables(notes)
        
        // Format and justify the notes
        var formatter = new Vex.Flow.Formatter().joinVoices([voice]).format([voice], CANVAS_WIDTH)
        
        // Render voice
        voice.draw(ctx, stave)
    }
    console.log("Successful run!")
}