function instlister()
{

for(num in parsedEvents.instruments)
{

//wrap "s around the identifying name
var identifyingName = '"' + num + '"'
var displayName = num

$("#instrumentlist")[0].innerHTML += '<input type=checkbox name=instrument value='+identifyingName+'>'+displayName+'<br>'

console.log($("#instrumentlist")[0].innerHTML)
}
$("#instrumentlist")[0].innerHTML+="<input type=button onclick= instclicked() value= submit><br>"
}
function instclicked() {

//document.querySelector("#tester1").innerText="string"
string=document.querySelector('input:checked').value
//document.querySelector("#tester1").innerText=string
document.querySelector("#instrumentlist").innerHTML=""

//
console.log(string)

//document.querySelector("#tester1").innerText=""
createSheetMusic(string)
// body...
}
function getInstruments() {
var instruments=[]

for (instrument in parsedEvents.instruments)
instruments.push(instrument)
return instruments.toString()
}
