# Capstone2015

## errors in the music parsing/generating 

- [ ] currently when we are setting up the measures in the function populateMeasure() we are treating everything like it has a 4/4 time signature we need to start taking into acount the actual time signature and generate the measures with correct time signature

We also need to deal with not standard notes ( the vex can generate notes when given one of these numbers  1,2,4,8,16,32,64,128 so i am going to think of these as the vex standard notes)
    
- [x] dotted notes are notes that are 50% greater then a standard note size 
  - so basicly a dotted half note would take up .75 of a 4/4 messure or three beats
      
- [ ] triplets these are notes that take three to make a standard note
  - so it would take three triplet quarter notes to make one half note
      
- [ ] tied notes so ties are when a note continues and you add on another notes value to the length
  - so this is for note lengths that arent standard or either of the two above we have to combine notes will we get something of the         right length

- [x] some times notes dont go all the way to the end and will instead earlier by a tick which sometimes makes us add unescary rest and make not durations a little weird
- [ ] i have seen it where notes go over and intrude into the next note 
    - this might be a something we need to add as a possiblity cause some instruments can have it like piano and percussian
    - that or we need to go through and fix it so nottes have one after another
