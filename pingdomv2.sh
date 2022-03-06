#!/bin/bash
#!/bin/sh -
#
########################################
 #             CURL MONITOR            #
########################################
#
 ####################
 # Global Variables #
 ####################
#
function variables_ () {
  SM='litan.shamir@cglms.com'
  main_path='/var/www/webmonitoring'
  links="$main_path/links.txt"
  failed="$main_path/failedlinks.txt"
  index="$main_path/index.html"
  indexu="$main_path/Conf/update.html"
  mkdir -p $main_path
  mkdir -p $main_path/admin
  IPL=`hostname -I | awk '{print $1,"\n"$2,"\n",$3  }' | sed  '/:/d' |  awk 'NF > 0' | sed 's/^[ \t]*//' | sed 's/[[:blank:]]*$//'`
  HN=`hostname -I`
}
#
 ###############
 # Apache conf #
 ###############
# Creates a new httpd.conf file in conf.d dir (lpnl01)
function apache_conf_ () {
pingdomconf='/etc/httpd/conf.d/pingdom.conf'
  if [ ! -s "$pingdomconf" ]; then
  echo "Creating conf.d/pingdom.conf!"
  cat > /etc/httpd/conf.d/pingdom.conf <<-"EOF"
  <VirtualHost *:443>
  SSLEngine On
  SSLCertificateFile /etc/SSLtoWWW/marketing-tefs.crt
  SSLCertificateKeyFile /etc/SSLtoWWW/marketing-tefs.key
  SSLProtocol all -SSLv2 -SSLv3
  SSLHonorCipherOrder on
  SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS"
  DocumentRoot "/var/www/webmonitoring"
  ServerName webmonitor.cglms.com
  Header always edit Set-Cookie "(?i)^((?:(?!;\s?HttpOnly).)+)$" "$1; HttpOnly"
  Header always edit Set-Cookie "(?i)^((?:(?!;\s?secure).)+)$" "$1; secure"
  <Directory "/var/www/webmonitoring">
  RedirectMatch ^/$ https://webmonitor.cglms.com/index.html
  </Directory>
  </VirtualHost>
EOF
  check_apache_
  else
   echo "conf.d/pingdom.conf already exist!"
  fi
}

#
#
 #################
 # Apache status #
 #################
# Checks apache status
function check_apache_ () {
 pingdomconf='/etc/httpd/conf.d/pingdom.conf'
 pingdomlog='/etc/httpd/conf.d/pingdom.log'
 counter=1
 while "$counter" < "4" ; do
  systemctl restart httpd
  checka=`systemctl status httpd | grep "active (running)" | wc -l`
  if [ "$checka" == '0' ]; then
   mv -f $pingdomconf $pingdomlog
   systemctl restart httpd
   counter=$((counter+1))
   if [ "$counter" == "3" ]; then
    systemctl restart httpd
    checka=`systemctl status httpd | grep "active (running)" | wc -l`
  if [ "$checka" == '0' ]; then
   echo -e "FAILED restarting apache! $hostname" | mail -s "FAILED restarting apache on $IPL!" $SM
  fi
   fi
  else
   echo "apache status is fine!"
   counter=4
  fi
 done
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
if [ -s "$linkstemp" ]; then
 while read lines; do
  echo $lines >> $links
 done < $linkstemp
 rm -rf $linkstemp
fi
if [ ! -s "$links" ]; then
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
else
 echo "links list already exist!"
 sum=`cat /var/www/webmonitoring/sum.txt`
 newsum=$((sum+5))
 echo $newsum > /var/www/webmonitoring/sum.txt
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
history="$main_path/history.txt"
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
   echo $line >> $history
 fi
done < $links

if [ ! -s "$failed" ];
 then
  echo "Nothing to do"
else
 create_dashboard_main_
 alert_dashboard_
fi
}
#
 #############
 # Dashboard #
 #############
#
function create_dashboard_main_ () {
 index="$main_path/index.html"
 cat > $index <<-"EOF"
 <!DOCTYPE html>
 <html>
 <title>Colmex Israel - Web Monitor</title>
 <meta charset="UTF-8">
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
 <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
 <style>
 html,body,h1,h2,h3,h4,h5 {font-family: "Raleway", sans-serif}
 </style>
 <body class="w3-light-grey">

 <!-- Top container -->
 <div class="w3-bar w3-top w3-black w3-large" style="z-index:4">
   <span class="w3-bar-item w3-left"><p>Colmex Israel - Web Monitor</p></span>
   <span class="w3-bar-item w3-right"><img src="Logos/colmexlogo.png" alt="Colmex" width="70" height="60"></span>
 </div>

 <!-- Sidebar/menu -->
 <nav class="w3-sidebar w3-collapse w3-white w3-animate-left" style="z-index:3;width:300px;" id="mySidebar"><br>

   <hr>
   <div class="w3-container">
     <h5>Dashboard</h5>
   </div>
   <div class="w3-bar-block">
     <a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" onclick="w3_close()" title="close menu"><i class="fa fa-remove fa-fw"></i>  Close Menu</a>
     <a href="index.html" class="w3-bar-item w3-button w3-padding w3-blue"><i class="fa fa-users fa-fw"></i>  Dashboard</a>
     <a href="Config/update.html" class="w3-bar-item w3-button w3-padding"><i class="fa fa-eye fa-fw"></i>  Configuration</a>
   </div>
 </nav>


 <!-- Overlay effect when opening sidebar on small screens -->
 <div class="w3-overlay w3-hide-large w3-animate-opacity" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>

 <!-- !PAGE CONTENT! -->
 <div class="w3-main" style="margin-left:300px;margin-top:43px;">

   <!-- Header -->
   <header class="w3-container" style="padding-top:22px"><br>
     <h5><b><i class="fa fa-dashboard"></i> My Dashboard</b></h5>
   </header>

   <div class="w3-row-padding w3-margin-bottom">
     <div class="w3-quarter">
       <div class="w3-container w3-red w3-padding-16">
         <div class="w3-left"></div>
         <div class="w3-right">
           <h3>Last check: 52</h3>
         </div>
         <div class="w3-clear"></div>
         <h4>Messages</h4>
       </div>
     </div>
  
 <!--!-->
   <div class="w3-panel">
     <div class="w3-row-padding" style="margin:0 -16px">
     
   <hr>
   <div class="w3-container">
     <h5>Uptime</h5>
       <!---->
     <p>New Visitors</p>
     <div class="w3-grey">
       <div class="w3-container w3-center w3-padding w3-green" style="width:25%">+25%</div>
     </div>

     <p>New Users</p>
     <div class="w3-grey">
       <div class="w3-container w3-center w3-padding w3-orange" style="width:50%">50%</div>
     </div>

     <p>Bounce Rate</p>
     <div class="w3-grey">
       <div class="w3-container w3-center w3-padding w3-red" style="width:75%">75%</div>
     </div>
   </div>
   <hr>

  
   <!-- End page content -->
 </div>

 <script>
 // Get the Sidebar
 var mySidebar = document.getElementById("mySidebar");

 // Get the DIV with overlay effect
 var overlayBg = document.getElementById("myOverlay");

 // Toggle between showing and hiding the sidebar, and add overlay effect
 function w3_open() {
   if (mySidebar.style.display === 'block') {
     mySidebar.style.display = 'none';
     overlayBg.style.display = "none";
   } else {
     mySidebar.style.display = 'block';
     overlayBg.style.display = "block";
   }
 }

 // Close the sidebar with the close button
 function w3_close() {
   mySidebar.style.display = "none";
   overlayBg.style.display = "none";
 }
 </script>

 </body>
 </html>
EOF
}
#
function create_dashboard_config_ () {
 indexu="$main_path/Conf/update.html"
 cat > $indexu <<-"EOF"
 <!DOCTYPE html>
<html>
<title>Colmex Israel - Web Monitor</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
html,body,h1,h2,h3,h4,h5 {font-family: "Raleway", sans-serif}
</style>
<body class="w3-light-grey">

<!-- Top container -->
<div class="w3-bar w3-top w3-black w3-large" style="z-index:4">
  <button class="w3-bar-item w3-button w3-hide-large w3-hover-none w3-hover-text-light-grey" onclick="w3_open();"><i class="fa fa-bars"></i>  Menu</button>
  <span class="w3-bar-item w3-left"><p>Colmex Israel - Web Monitor</p></span>
  <span class="w3-bar-item w3-right"><img src="../Logos/colmexlogo.png" alt="Colmex" width="70" height="60"></span>
</div>

<!-- Sidebar/menu -->
<nav class="w3-sidebar w3-collapse w3-white w3-animate-left" style="z-index:3;width:300px;" id="mySidebar"><br>

  </div>
  <hr>
  <div class="w3-container">
    <h5>Configuration Menu</h5>
  </div>
  <div class="w3-bar-block">
    <a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" onclick="w3_close()" title="close menu"><i class="fa fa-remove fa-fw"></i>  Close Menu</a>
    <a href="../index.html" class="w3-bar-item w3-button w3-padding"><i class="fa fa-users fa-fw"></i>  Dashboard</a>
    <a href="update.html" class="w3-bar-item w3-button w3-padding w3-blue"><i class="fa fa-eye fa-fw"></i>  Configuration</a>
  </div>
</nav>


<!-- Overlay effect when opening sidebar on small screens -->
<div class="w3-overlay w3-hide-large w3-animate-opacity" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>

<!-- !PAGE CONTENT! -->
<div class="w3-main" style="margin-left:300px;margin-top:43px;">

  <!-- Header -->
  <header class="w3-container" style="padding-top:22px"><br>
    <h5><b> Add or Remove links</b></h5>
    <h5><b> Changes will appear after 5-10 minutes.. Please be patient</b></h5>
  </header>
  <div class="w3-panel">
    <div class="w3-row-padding" style="margin:0 -16px">
      <h5><b style="color:blue;"> Add a link to monitor</b></h5>
      <h5><b> (You may enter more than one)</b></h5>
      <form method="post" action="createfiletoadd.php">
        <b>Link/s to add:</b>
        <div id="dat"><textarea name="thedata" id="thedata" cols="50" rows="3"></textarea></div><br>
        <input type="submit" value=" Add ">
        </div>
        </form>
        <br>
      <h5><b style="color:blue;"> Remove a link from monitoring</b></h5>
      <h5><b> (check the relevant boxes and click "Remove")</b></h5>
     <form action="/createfiletoremove.php" method="get">
       <input type="checkbox" name="######" value="######">
      <label for="######"> ######</label><br><br>
      <!---->
       <input type="submit" value=" Remove ">
    </form>
   </div>
  </div>
 
  <div class="w3-panel">
    <div class="w3-row-padding" style="margin:0 -16px">

  <!-- End page content -->
</div>

<script>
// Get the Sidebar
var mySidebar = document.getElementById("mySidebar");

// Get the DIV with overlay effect
var overlayBg = document.getElementById("myOverlay");

// Toggle between showing and hiding the sidebar, and add overlay effect
function w3_open() {
  if (mySidebar.style.display === 'block') {
    mySidebar.style.display = 'none';
    overlayBg.style.display = "none";
  } else {
    mySidebar.style.display = 'block';
    overlayBg.style.display = "block";
  }
}

// Close the sidebar with the close button
function w3_close() {
  mySidebar.style.display = "none";
  overlayBg.style.display = "none";
}
</script>

</body>
</html>
EOF
}
#
 ##########
 # Alerts #
 ##########
#
function alert_dashboard_ () {
main_path='/var/www/webmonitoring'
failed="$main_path/failedlinks.txt"
index="$main_path/index.html"
ld=`date | awk '{print $2, $3, $4}'`
sed -i 's/######.*/######/' $index
 while read failure; do
  rm -rf /var/www/webmonitoring/failures.txt
  checkf=`cat $index | grep $failure | wc -l`
  if [ "$checkf" == "0" ]; then
  echo -e '<div class="w3-row-padding w3-margin-bottom">
    <div class="w3-quarter">
      <div class="w3-container w3-red w3-padding-16">
        <div class="w3-left"></div>
        <div class="w3-right">
         <h3>Last check: 52</h3>
        </div>
        <div class="w3-clear"></div>
        <h4>Messages</h4>
      </div>
    </div>'  > /var/www/webmonitoring/failures.txt
sed -i "s/Messages/$failure/g" /var/www/webmonitoring/failures.txt
sed -i "s/52/$ld/g" /var/www/webmonitoring/failures.txt
sed -i '/<!--!-->/{
s/<!--!-->//g
r /var/www/webmonitoring/failures.txt
}' $index
  echo -e "https://$failure IS NOT FUNCTIONING!!!" | mail -s "$failure NOT FUNCTIONING!!!" $SM
  else
   echo -e "No new status for $failure!"
  fi
 done < $failed
}
#
function configuration_list_ () {
 while read liner; do
   echo -e ' <input type="checkbox" name="######" value="######">
      <label for="######"> ######</label><br><br>' > /var/www/webmonitoring/lineseria.txt
sed -i "s/######/$liner/g" /var/www/webmonitoring/lineseria.txt
sed -i '/<!---->/{
s/<!---->//g
r /var/www/webmonitoring/lineseria.txt
}' $indexu
echo > /var/www/webmonitoring/lineseria.txt
 done < $links
}
#
function dashboard_list_ () {
  main_path='/var/www/webmonitoring'
  failed="$main_path/failedlinks.txt"
  index="$main_path/index.html"
 while read liner; do
   counter=`cat $history | grep "$liner" | wc -l`
   sumfail=$((counter*5))
   sum=`cat /var/www/webmonitoring/sum.txt`
   percent=$((sumfail/sum*100))
   percentfin=$((100-percent))
   if [ "$percentfin" < "50" ]; then
     echo -e '
     <p>Bounce Rate</p>
         <div class="w3-grey">
           <div class="w3-container w3-center w3-padding w3-red" style="width:75%">75%</div>
         </div>
        </div> ' > /var/www/webmonitoring/status.txt
        sed -i "s/Bounce Rate/$liner/g" /var/www/webmonitoring/status.txt
        sed -i "s/75/$percentfin/g" /var/www/webmonitoring/status.txt
sed -i '/<!---->/{
s/<!---->//g
r /var/www/webmonitoring/status.txt
}' $index
   elif [ "$percentfin" > "50" ] && [ "$percentfin" < "100" ]; then
     echo -e '
     <p>New Users</p>
         <div class="w3-grey">
           <div class="w3-container w3-center w3-padding w3-orange" style="width:50%">50%</div>
         </div>
       </div> ' > /var/www/webmonitoring/status.txt
       sed -i "s/New Users/$liner/g" /var/www/webmonitoring/status.txt
       sed -i "s/50/$percentfin/g" /var/www/webmonitoring/status.txt
sed -i '/<!---->/{
s/<!---->//g
r /var/www/webmonitoring/status.txt
}' $index
   else
     echo -e '
     <p>New Visitors</p>
       <div class="w3-grey">
       <div class="w3-container w3-center w3-padding w3-green" style="width:100%">100%</div>
      </div>
     </div> ' > /var/www/webmonitoring/status.txt
sed -i "s/New Visitors/$liner/g" /var/www/webmonitoring/status.txt
sed -i '/<!---->/{
s/<!---->//g
r /var/www/webmonitoring/status.txt
}' $index
   fi
   echo > /var/www/webmonitoring/status.txt
   echo > /var/www/webmonitoring/sum.txt
 done < $links
}
#
 ##############
 # Start here #
 ##############
#
 #Prep
variables_               #<-- (G-0)
 #Build
  #apache_conf_
  links_file_
  configuration_list_
  dashboard_list_
 #CheckFunctions
  curl_
  rm -rf /var/www/webmonitoring/failedlinks.txt
  rm -rf /var/www/webmonitoring/failures.txt
#
 ###########
 # THE END #
 ###########
