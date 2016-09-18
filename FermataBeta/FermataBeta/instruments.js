function instlister()
{
    
    for(num in parsedEvents.instruments)
    {
        /*for (i in num.split("")){
            var t = num.charCodeAt(i)
            if ((t>=65)&&t<=90) || (t>=97 && t<=122)){
                
            }else {
                num = num.replace(num.charAt(i)," ")
                i--;
            }
        }*/
        //wrap "s around the identifying name
        var displayName = num.split(" ").join("")
        var identifyingName = '"' + displayName + '"'
        console.log(num)
        //$("#instrumentlist")[0].innerHTML += '<input type=checkbox name=instrument value='+identifyingName+'>'+displayName+'<br>'
        $("#instrumentlist")[0].innerHTML +="<div id='"+displayName+"' class='uncheckbox' value='"+num+"' onclick=checker("+identifyingName+")><h1>"+num+"</h1></div>"
        
        console.log($("#instrumentlist")[0].innerHTML)
    }
    $("#instrumentlist")[0].innerHTML+="<input type=button onclick= instclicked() value= submit><br>"
}
function instclicked() {
    
 
    
    //document.querySelector("#tester1").innerText="string"
    string=[]//=document.querySelector('input:checked').value
    //document.querySelector("#tester1").innerText=string
    for( var i =0;i< $('.checkbox').length;i++)
        string.push($('.checkbox')[i].getAttribute("value"))
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



function style(){
    var instr = ["flute","oboe","drums","voclal"]
    for(i in instr)
        $("#instrumentlist")[0].innerHTML +='<div id="'+instr[i]+'" class="uncheckbox" onclick=checker("'+instr[i]+'")><h1>'+instr[i]+'</h1></div>'
        
        
        }

var allvals=[]
function checker(val){
    console.log(val)
    $('#'+val).toggleClass('uncheckbox');
    
    $('#'+val).toggleClass('checkbox');
    
    
}