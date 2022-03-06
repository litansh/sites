<?php
$dir = "paramdir";
$file_to_write = "paramfile";
$content_to_write_domain = $_POST['domain'];
$content_to_write_email = $_POST['email'];
$content_to_write_key = $_POST['key'];
#
# Checks if parameter directory already exists and creates 
if( is_dir($dir) === false )
{
mkdir($dir);	
$file = fopen($dir . '/' . $file_to_write,"w");
fwrite($file, $content_to_write_domain;
fwrite($file, "\n");
fwrite($file, $content_to_write_email);
fwrite($file, "\n");
fwrite($file, $content_to_write_key);
fwrite($file, "\n");
fclose($file);
shell_exec("./purge.sh");
header('Location: http://www.'.$content_to_write_domain.'./purge.txt');
}
else
{
echo "Directory already exists!!!";	
}
?>

