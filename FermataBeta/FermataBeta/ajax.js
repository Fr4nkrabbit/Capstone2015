function loadsong(songname)
{
    console.log(songname);
    //$.get('http://people.eecs.ku.edu/~sbenson/grabMidi.php',{
    //title: songname
    $.get('http://people.eecs.ku.edu/~sxiao/grabMidi.php',{
          id: songname
          
          },
          function(data, status){
          console.log(status)
          console.log(data)
          return stringParseMidi(data)
          });
}


function loadsongs(songname)
{
    console.log(songname);
    
    $.get('http://people.eecs.ku.edu/~sxiao/grabTitles.php',{
          //$.get('http://people.eecs.ku.edu/~sbenson/grabTitles.php',{
          },
          function(data, status)
          {
          console.log(status)
          console.log(data)
          var songs=data.split('@')
          songs.pop()//remove empty one at end
          console.log(songs);
          for(num in songs){
          $("#songlist")[0].innerHTML+="<li onclick= songclicked('"+songs[num]+"')>"+songs[num]+"</li>"
          }
          //return parseMidi(data)
          });
}
function songclicked(string) {
    $("#songlist")[0].innerHTML=""
    loadsong(string)
    
    // body...
}