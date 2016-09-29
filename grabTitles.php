<?php

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

	
	$PULLTITLES = mysql_query("SELECT mime FROM $TABLE") or die (mysql_error());	
	
	while($row = mysql_fetch_assoc($PULLTITLES)){
		foreach($row as $cname => $cvalue){
			print "$cvalue,";
		}
		print "\r\n";
	}
	
?>
