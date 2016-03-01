# Capstone2015

things that still need to be fixed in the music:
Currently we populate everything as 4/4 and treat the time signature that way
but as we are creating the measures in the function populateMeasure() we need to take into acount the actual time signature

So the vex can generate notes when given one of these numbers  1,2,4,8,16,32,64,128 so i am going to think of these as the vex standard notes

  we also need to deal with not standard notes
  
    dotted i think i have working correctly but its notes that 50% greater then a standard note size
      so basicly a dotted half note would take up .75 of a 4/4 messure or three beats
      
    triplets these are notes that take three to make a standard note
      so it would take three triplet quarter notes to make one half note
      
    tied notes so ties are when a note continues and you add on another notes value to the length
      so this is for note lengths that arent standard or either of the two above we have to combine notes will we get soemthing of the         right length
