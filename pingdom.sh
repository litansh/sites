#!/bin/bash
#!/bin/sh -
#
 ########################################
 #             CURL MONITOR             #
 ########################################
#
 ####################
 # Global Variables #
 ####################
#
function variables_ () {
 SM='litan.shamir@cglms.com'
 main_path='/var/www/webmonitoring'
 links="$main_path/links.txt"
 failed="$main_path/failedlinks.txt"
 index="$main_path/index.html"
 mkdir -p $main_path
 mkdir -p $main_path/admin
 IPL=`hostname -I | awk '{print $1,"\n"$2,"\n",$3  }' | sed  '/:/d' |  awk 'NF > 0' | sed 's/^[ \t]*//' | sed 's/[[:blank:]]*$//'`
 hostame=`hostname -I`
}
#
 ##############
 # Links file #
 ##############
# Creates the file containings the links to check if up
function links_file_ () {
main_path='/var/www/webmonitoring'
links="$main_path/links.txt"
linkstemp="$main_path/admin/linkstemp.txt"
lvc="$main_path/admin/lvc.txt"
if [ -s "$linkstemp" ]; then
 while read lines; do
  echo $lines >> $links
 done < $linkstemp
 rm -rf $linkstemp
fi
if [ ! -s "$links" ] && [ ! -s "$lvc" ]; then
cat > $links <<-"EOF"
lp.colmex.co.il/post-shorts/
lp.colmex.co.il/ilsusd/
lp.colmex.co.il/sp500/
lp.colmex.co.il/mivne-dividends/
lp.colmex.co.il/colmex-stock-trading/
lp.colmex.co.il/dubai/
lp.colmex.co.il/gold/
lp.colmex.co.il/mahanak300dollars/
lp.colmex.co.il/colmex-leverage-taboola/
lp.colmex.co.il/colmex-trading-costs-taboola/
lp.colmex.co.il/colmex-go-shorts-taboola/
lp.colmex.co.il/lowrisk/
lp.colmex.co.il/extreme/
lp.colmex.co.il/colmex-go-shorts-google/
lp.colmex.co.il/colmex-go-shorts-facebook/
lp.colmex.co.il/colmex-general/
lp.colmex.co.il/colmex-go-shorts/
lp.colmex.co.il/_colmex-leveragesponser/
lp.colmex.co.il/colmex-go-demo/
lp.colmex.co.il/2-colmex-movie-forex/
lp.colmex.co.il/colmex-football/
lp.colmex.co.il/colmex-movie-forex/
lp.colmex.co.il/colmex-leverage/
lp.colmex.co.il/2-colmex-trading-costs/
lp.colmex.co.il/a-colmex-landing-tlv35-sponser/
lp.colmex.co.il/colmex-nov2019-1/
lp.colmex.co.il/colmex-landing-tlv35-j/
lp.colmex.co.il/colmex-landing-tlv35-sponser/
lp.colmex.co.il/colmex-landing-tlv35-media/
lp.colmex.co.il/colmex-landing-tlv35-e/
lp.colmex.co.il/colmex-nov2019-2/
lp.colmex.co.il/colmex-trading-costs/
lp.colmex.co.il/colmex-article-e/
lp.colmex.co.il/colmex-article-d/
lp.colmex.co.il/colmex-landing-tlv35-d/
lp.colmex.co.il/colmex-landing-tlv35-c/
lp.colmex.co.il/colmex-article-c/
lp.colmex.co.il/colmex-article-b/
lp.colmex.co.il/colmex-landing-tlv35-b/
lp.colmex.co.il/colmex-landing-fortvision/
lp.colmex.co.il/colmex-article-a/
lp.colmex.co.il/colmex-landing-tlv35-a/
lp.colmex.co.il/colmex-landing-f/
lp.colmex.co.il/colmex-landing-ea/
lp.colmex.co.il/colmex-landing-da/
lp.colmex.co.il/colmex-landing-a-2/
lp.colmex.co.il/colmex-thank-you-page-guide/
lp.colmex.co.il/colmex-landing-e/
lp.colmex.co.il/colmex-landing-d/
lp.colmex.co.il/colmex-landing-c/
lp.colmex.co.il/colmex-landing-b/
lp.colmex.co.il/colmex-thank-you-page/
lp.colmex.co.il/colmex-landing-a/
book.megamot.co.il/
brand.megamot.co.il/
college.megamot.co.il/
www.colmex.co.il/
www.tradenetacademy.ru/
www.marketing-tefs.de/
www.megamot.co.il/
mts.colmexpro.com/
online.tradenet.com/
realestate.megamot.co.il/
services.colmexpro.com/deposit/
services.colmexpro.com/registration/
services.colmexpro.com/warmupservice/
sign.colmexpro.com/
tefsec.com/
www.tradenetacademy.ru/
www.colmexpro.com/
www.crpbycolmex.co.il/
mts.tefsec.com/
www.tradenet.com/
EOF
rm -rf $lvc
else
echo "links list already exist!"
fi
}
#
 #################
 # Main function #
 #################
#
function curl_ () {
main_path='/var/www/webmonitoring'
failed="$main_path/failedlinks.txt"
rm -rf $failed
links="$main_path/links.txt"
rm -rf $failed
while read line; do
 sleep 1
 live="$(curl -Is https://$line | head -1 | grep "OK" | wc -l)"
 if [ "$live" != "0" ];
 then
   echo "https://$line is up!"
 else
   echo $line >> $failed
 fi
done < $links

if [ ! -s "$failed" ];
 then
  echo "Nothing to do"
else
 build_dashboard_
 build_dashboard_update_
fi
}
#
 #############
 # dashboard #
 #############
#
function build_dashboard_ () {
main_path='/var/www/webmonitoring'
index="$main_path/index.html"
cat > $index <<-"EOF"
<!doctype html>
 <html lang="en">
 <style>
  body {
    background-color:black;
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-size: 100% 100%;
  }
  form {
    background-color:white;
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-size: 100% 100%;
  }
  div.opacity {
    opacity: 0.8;
    font-weight: 900;
  }
  table, th, td {
    background-color:red;
    border: 1px solid black;
  }
 </style>

 <head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="30">
   <title>CGLMS - PingMonitor</title>
    <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="css/bootstrap.min.css">
 </head>

 <body class="body">

  <table style="width:100%" class="table">
   <tr>
######
  </table>

<form id="form" method="get">
  Go to upload menu
  <button type="submit" formaction="admin/update.html">Go</button>
</form> 
 </body>

</html>
EOF
}
#
 #############
 # dashboard #
 #############
#
function build_dashboard_update_ () {
main_path='/var/www/webmonitoring'
indexu="$main_path/admin/update.html"
cat > $indexu <<-"EOF"
<!doctype html>
 <html lang="en">
 <style>
  body {
    background-color:black;
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-size: 100% 100%;
  }
  form {
    background-color:white;
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-size: 100% 100%;
  }
  div.opacity {
    opacity: 0.8;
    font-weight: 900;
  }
  table, th, td {
    background-color:red;
    border: 1px solid black;
  }
 </style>

 <head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="30">
   <title>CGLMS - PingMonitor</title>
    <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="css/bootstrap.min.css">
 </head>

 <body class="body">

  <table style="width:100%" class="table">
   <tr>
######
  </table>
<form action="fileUploadScript.php" method="post" enctype="multipart/form-data">
    Upload a File with URLs to Monitor (Add to existing file!!!):
    <input type="file" name="the_file" id="fileToUpload">
    <input type="submit" name="submit" value="Start Upload">
</form>
<form action="fileUploadScriptW.php" method="post" enctype="multipart/form-data">
  Upload a File with URLs to Monitor (OVERWRITES!!!):
  <input type="file" name="the_file" id="fileToUpload">
  <input type="submit" name="submit" value="Start Upload">
</form>
<form action="BacktoOriginal.php" method="post" enctype="multipart/form-data">
  Restoring to Original version:
  <input type="submit" name="submit">
</form>
<form id="form" method="get">
  Go back to dashboard
  <button type="submit" formaction="../index.html">Go</button>
</form> 
 </body>

</html>
EOF
}
#
 #########
 # Alert #
 #########
#
function alert_ () {
main_path='/var/www/webmonitoring'
failed="$main_path/failedlinks.txt"
index="$main_path/index.html"
sed -i 's/######.*/######/' $index
indexu="$main_path/admin/update.html"
sed -i 's/######.*/######/' $indexu
 while read failure; do
  rm -rf /var/www/webmonitoring/failures.txt
  checkf=`cat $index | grep $failure | wc -l`
  if [ "$checkf" == "0" ]; then
  echo -e "<tr><th>$failure</th></tr>######" > /var/www/webmonitoring/failures.txt
sed -i '/######/{
s/######//g
r /var/www/webmonitoring/failures.txt
}' $index
sed -i '/######/{
s/######//g
r /var/www/webmonitoring/failures.txt
}' $indexu
  echo -e "https://$failure IS NOT FUNCTIONING!!!" | mail -s "$failure NOT FUNCTIONING!!!" $SM
  else
   echo -e "No new status for $failure!"
  fi
 done < $failed
}
#
 ##############
 # Start here #
 ##############
#
 #Prep
  variables_               #<-- (G-0)
 #Build
  links_file_
  bto_
  fus_
 #CheckFunctions
  curl_
  alert_
  rm -rf /var/www/webmonitoring/failedlinks.txt
  rm -rf /var/www/webmonitoring/failures.txt
#
 ###########
 # THE END #
 ###########
