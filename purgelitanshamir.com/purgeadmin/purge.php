<?php
#
# Parameters
$dir = "paramdir";
$file_to_write = "paramfile";
$content_to_write_domain = $_POST['domain'];
#
# Checks if parameter directory already exists and creates
if( is_dir($dir) === false )
{
mkdir($dir);
 $file = fopen($dir . '/' . $file_to_write,"w");
  fwrite($file, $content_to_write_domain);
  fclose($file);
  shell_exec('sudo ./purge.sh');
  header('Location: https://purgeadmin/purge.txt');
}
else
{
 echo "Directory already exists!!!";
}
?>
