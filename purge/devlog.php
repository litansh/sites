<?php
shell_exec("devlog.sh");
$json_data = file_get_contents('log.txt');
$obj = json_decode($json_data);


$devstatus = 'Dev Mode Status : ' . $obj->result->value;;
$onluyTime = $obj->result->time_remaining;


$seconds = $onluyTime ;
$hours = floor($seconds / 3600);
$seconds -= $hours * 3600;
$minutes = floor($seconds / 60);
$seconds -= $minutes * 60;

$parsing = $hours. ':' . $minutes. ':' .$seconds;
$content = 'Time Remaining For Dev Mode : ' . $parsing;





?>
