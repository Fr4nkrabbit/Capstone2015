function durToWhole(inFloat) //.125 > 8
{
    return parseInt(1 / inFloat)
}

function pitToStr(inHex,clef) //5C > G#6
{
    if (inHex == -1&&clef=="treble")
        return 'B/4' //rest position
        else if (inHex == -1&&clef=="bass")
            return 'd/3' //rest position
            
            
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

function generateStaveNotes(measure,keysig,clef){
    
    
    
    var notes = []
    
    var forbeamnotes=[],
    allbeams=[],
    lengthofbeam=0;
    
    var tuplets = []
    var tripletCount = 0 //count to 3, then will create a triplet object
    
    for (var n = 0, i=0; n < measure.length; n++) //loop through notes
    {
        //console.log(inM[mC].m[n])
        var decDur = measure[n].note
        var pit = pitToStr(measure[n].pitch,clef)
        var dur = durToWhole(decDur)
        var dotted = false
        var irregularNote = true
        var tosmall = true
        
        //Determine if the note is at least normal or dotted
        //for (var p = 0; p < 8 && irregularNote; p++)
        for (var p = 0; p < 7 && irregularNote; p++) //p = power of 2 to check against
        {
            if (measure[n].note * 2 / 3 == 1 / Math.pow(2,p)) //regular dotted
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
                notes.push(new Vex.Flow.StaveNote({clef:clef,  keys: [pit], duration: collection[col].toString()}))
                }
        else if (tripletCount > 0)
        {
            //console.log('triplet note')
            
            //console.log('pit ' + pit)
            //console.log('dur ' + dur)
            dur += ''
            notes.push(new Vex.Flow.StaveNote({ clef:clef, keys: [pit], duration: dur }))
            
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
            dur = dur + (measure[n].pitch == -1 ? 'r' : '') //append 'r' if this note is a rest
            
            //console.log('note' + n + ': ' + dur + ', ' + pit + ', dotted ' + dotted + " + " + inM[mC].m[n].pitch)
            
            //console.log('pit ' + pit)
            //console.log('dur ' + dur)
            notes.push(new Vex.Flow.StaveNote({clef:clef, keys: [pit], duration: dur }))
            
            if(dotted)
                notes[notes.length-1].addDotToAll()
                
                if(!keysig.acidentals.includes(pit) && pit.includes('#'))
                    notes[notes.length-1].addAccidental(0, new Vex.Flow.Accidental("#"))
                    }
    } //end looping through notes
    //console.log('')
    return [notes,tuplets]
    
    
}

function create_voice(sig)
{
    return new Vex.Flow.Voice(
                              {
                              num_beats:	sig.top,
                              beat_value:	sig.bottem,
                              resolution:	Vex.Flow.RESOLUTION
                              }).setMode(2)
}


function drawSheets(inM)
{
    /*
     for each line create a new struct that will have each instruments list of measures
     for that line
     
     */
    console.log("inM")
    console.log(inM)
    var canvas = document.querySelector("canvas")
    var renderer = new Vex.Flow.Renderer(canvas, Vex.Flow.Renderer.Backends.CANVAS)
    var ctx = renderer.getContext()
    
    var timesig =
    {
    top: 4,
    bottem: 4
    };
    timesig=inM[Object.keys(inM)[0]].measures[0].time
    
    var keysig =
    {
    name: "C",
    acidentals:[]
    }
    var instrnum=0
    var stoppingPoint = Math.min(inM.length, (LINE_COUNT+STARTING_MEASURE)* MEASURES_PER_LINE)
    
    for(var line =0;((line+1)*Object.keys(inM).length)<LINE_COUNT;line++){
        //console.log("line "+line)
        
        
        for (var mC = 0; mC < MEASURES_PER_LINE; mC++) //loop through measures
        {
            //	console.log("meaure "+mC)
            instrnum=0
            var measNum=mC+line*MEASURES_PER_LINE+STARTING_MEASURE
            var staves=[]
            
            for (var instr in inM){//for the different instruments
                //console.log("instr "+instr);
                //Decide where to draw the measure, or "staff" as Vexflow calls it
                var offsetX = STAFF_OFFSET_X + mC * STAFF_WIDTH
                var offsetY = STAFF_OFFSET_Y * ((line*Object.keys(inM).length)+instrnum)
                var stave = new Vex.Flow.Stave(offsetX, offsetY, STAFF_WIDTH)
                var shift=60
                
                staves.push(stave)
                instrnum++
                // Add a treble clef if it's the first measure of the line
                if (mC % MEASURES_PER_LINE == 0){
                    stave.addClef(inM[instr].clef)
                    shift+=50
                }
                
                if(inM[instr].measures[measNum].time)
                {
                    stave.addTimeSignature(""+timesig.top+'/'+timesig.bottem)
                    timesig =inM[instr].measures[measNum].time
                }else if (mC % MEASURES_PER_LINE == 0){
                    stave.addTimeSignature(""+timesig.top+'/'+timesig.bottem)
                    
                }else{
                    shift-=30
                }
                
                if(inM[instr].measures[measNum].key!=undefined)
                {
                    keysig.name =inM[instr].measures[measNum].key
                    keysig.Accidental=[]
                    stave.addKeySignature(keysig.name)
                }else if (mC % MEASURES_PER_LINE == 0){
                    stave.addKeySignature(keysig.name)
                    
                }else{
                    shift-=30
                }
                
                //stave.addKeySignature(keysig.name)
                stave.setContext(ctx).draw()
                
                //create notes from inM
                
                var notesAndTuplets=generateStaveNotes(inM[instr].measures[measNum].m,keysig,inM[instr].clef)
                var notes =notesAndTuplets[0]
                var tuplets =notesAndTuplets[1]
                
                //Add beams
                allbeams = Vex.Flow.Beam.generateBeams(notes)
                
                // Create a voice in 4/4
                
                // Create voices and add notes to each of them
                var voice = create_voice(timesig).addTickables(notes)
                
                
                // Format and justify the notes
                
                var formatter = new Vex.Flow.Formatter().joinVoices([voice]).format([voice], STAFF_WIDTH-shift)
                
                // Render voice
                voice.draw(ctx, stave)
                
                // Render beams
                while(allbeams.length)
                    allbeams.pop().setContext(ctx).draw()
                    
                    // Render tuplets
                    while(tuplets.length)
                        tuplets.pop().setContext(ctx).draw()
                        
                        } //end looping through measures
            if(Object.keys(inM).length!=1){
                new Vex.Flow.StaveConnector(staves[0],staves[staves.length-1]).setType(1).setContext(ctx).draw()
                
                if(mC==0){
                    new Vex.Flow.StaveConnector(staves[0],staves[staves.length-1]).setType(3).setContext(ctx).draw()
                }else if(mC+1==MEASURES_PER_LINE){
                    new Vex.Flow.StaveConnector(staves[0],staves[staves.length-1]).setType(0).setContext(ctx).draw()
                    
                }
            }
            
        }
    }
    console.log("Successful run!")
    currentMeasures()
    
}

function startBasicFollow(tempo){
    FOLLOW_TEMPO=tempo/60*1000
    follow()
    
    
}

function follow(){
    timer=setTimeout(follow,FOLLOW_TEMPO*MEASURES_PER_LINE)
    STARTING_MEASURE++
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    drawSheets(TO_DRAW)
    
    //currentMeasures()
}

function turnPage(dir){
    STARTING_MEASURE+= LINE_COUNT*MEASURES_PER_LINE*dir
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    drawSheets(TO_DRAW)
    //currentMeasures()
}

function singleMeasure(dir ){
    STARTING_MEASURE+= dir
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    drawSheets(TO_DRAW)
}

function singleLine(dir){
    STARTING_MEASURE+= dir*MEASURES_PER_LINE
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    drawSheets(TO_DRAW)
    
}
function goToMeasure(meas){
    STARTING_MEASURE=meas
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    drawSheets(TO_DRAW)
    
}

function setMeasurePerLine(num){
    MEASURES_PER_LINE=num
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    drawSheets(TO_DRAW)
}
function setLineCount(num){
    LINE_COUNT=num
    $('canvas').parent()[0].innerHTML='<canvas width=' + (CANVAS_WIDTH+25) + ' height=' + CANVAS_HEIGHT + '></canvas>'
    
    drawSheets(TO_DRAW)
}


function stopTimer(){
    clearTimeout(timer)
    
    
}