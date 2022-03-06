<?php
$file_to_write = "dfl.txt";
$content_to_write_ip  = $_POST['thedata'] ;
$file = fopen($file_to_write,"w");
fwrite($file, $content_to_write_ip);
fwrite($file, "\n");
fclose($file);

header( "refresh:5;url=https://webmonitor.cglms.com/index.html" );
?>