<?php

session_start();

    $currentDirectory = getcwd();
    $uploadDirectory = "/webmonitoring";

    $errors = []; // Store errors here

    $fileExtensionsAllowed = ['txt']; // These will be the only file extensions allowed 

    $fileName = $_FILES['the_file']['name'];
    $FileName2 = "linkstemp.txt";
    $fileSize = $_FILES['the_file']['size'];
    $fileTmpName  = $_FILES['the_file']['tmp_name'];
    $fileType = $_FILES['the_file']['type'];
    $fileExtension = strtolower(end(explode('.',$fileName)));

    $uploadPath = $currentDirectory . $uploadDirectory . basename($fileName); 

    if (isset($_POST['submit'])) {

      if (! in_array($fileExtension,$fileExtensionsAllowed)) {
        $errors[] = "This file extension is not allowed. Please upload a TXT file";
      }

      if ($fileSize > 2000000) {
        $errors[] = "File exceeds maximum size (2MB)";
      }

      if (empty($errors)) {
        $didUpload = move_uploaded_file($fileTmpName, $FileName2);

        if ($didUpload) {
          echo "The file " . basename($fileName) . " has been uploaded";
        } else {
          echo "An error occurred. Please contact the administrator.";
        }
      } else {
        foreach ($errors as $error) {
          echo $error . "These are the errors" . "\n";
        }
      }

    }
    header( "refresh:5;url=https://webmonitor.cglms.com/index.html" );

?>