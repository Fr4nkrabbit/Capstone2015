<?php
if (PHP_SAPI === 'cli') {
    $SONGTITLE = $argv[1];
}
else {
    $SONGTITLE = $_GET['title'];
}
$HOSTNAME = "mysql.eecs.ku.edu";
$NAME     = "Users";
$USER     = "eraygoro";
$PASSWORD = "Password123!";
$TABLE    = "MIDI";

$CONNECTION = @mysql_connect($HOSTNAME,$USER,$PASSWORD);

if(!$CONNECTION){
	die('Connection Failed\n'.mysql_error());
}
if(!mysql_select_db($USER,$CONNECTION)){
	die('Could not connect: ' . mysql_error());
}
	
	$PULLSONG = mysql_query("SELECT data FROM $TABLE WHERE mime = '$SONGTITLE' ") or die (mysql_error());	
	
	while($row = mysql_fetch_assoc($PULLSONG)){
		foreach($row as $cname => $cvalue){
			print "$cvalue\t";
		}
		print "\r\n";
	}
	
?>
