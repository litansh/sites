<?php 
$link .= "$_SERVER[HTTP_HOST]"; 
echo $link;
?>

<?php
#
# Parameters
$dir = "/var/www/paramdir";
$file_to_write = "paramfile";
$content_to_write_email = $_POST['email'];
$content_to_write_key = $_POST['key'];

#
# Checks if parameter directory already exists and creates
if( is_dir($dir) === false )
{
mkdir($dir, 0777, TRUE);
 $file = fopen($dir . '/' . $file_to_write,"w");
  fwrite($file, $link);
  fwrite($file, "\n");
  fwrite($file, $content_to_write_email);
  fwrite($file, "\n");
  fwrite($file, $content_to_write_key);
  fwrite($file, "\n");
 fclose($file);
shell_exec('sudo ./purge.sh');
header('Location: https://'.$link.'/purge.txt');
}
else
{
 echo "Directory already exists!!!";
}
?>
