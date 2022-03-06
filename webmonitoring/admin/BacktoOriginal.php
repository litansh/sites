<?php

$file_to_write = "lvc.txt";
$content_to_write_ip = "1";

$file = fopen($file_to_write,"w");
fwrite($file, $content_to_write_ip);
fwrite($file, "\n");
fclose($file);

header( "refresh:5;url=https://webmonitor.cglms.com/index.html" );
?>

<html lang="en">
<head>
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Restoring</title>
	<body>
	<p>Thank You! In Progress...</p>
	</body>
</head>
</html>





