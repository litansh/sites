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



?>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="refresh" content="50">
<title></title>
<style type="text/css">
body{
	 background:#202020;
	 font:bold 12px Arial, Helvetica, sans-serif;
	 margin:0;
	 padding:0;
	 min-width:960px;
	 color:#bbbbbb; 
}

a { 
	text-decoration:none; 
	color:#00c6ff;
}

h1 {
	font: 4em normal Arial, Helvetica, sans-serif;
	padding: 20px;	margin: 0;
	text-align:center;
}

h1 small{
	font: 0.2em normal  Arial, Helvetica, sans-serif;
	text-transform:uppercase; letter-spacing: 0.2em; line-height: 5em;
	display: block;
}

h2 {
    font-weight:700;
    color:#bbb;
    font-size:20px;
}

h2, p {
	margin-bottom:10px;
}

@font-face {
    font-family: 'BebasNeueRegular';
    src: url('BebasNeue-webfont.eot');
    src: url('BebasNeue-webfont.eot?#iefix') format('embedded-opentype'),
         url('BebasNeue-webfont.woff') format('woff'),
         url('BebasNeue-webfont.ttf') format('truetype'),
         url('BebasNeue-webfont.svg#BebasNeueRegular') format('svg');
    font-weight: normal;
    font-style: normal;

}

.container {width: 960px; margin: 0 auto; overflow: hidden;}

.clock {width:800px; margin:0 auto; padding:30px; border:1px solid #333; color:#fff; font-size: 20px;text-align: center}

#Date { font-family:'BebasNeueRegular', Arial, Helvetica, sans-serif; font-size:36px; text-align:center; text-shadow:0 0 5px #00c6ff; }

ul { width:800px; margin:0 auto; padding:0px; list-style:none; text-align:center; }
ul li { display:inline; font-size:10em; text-align:center; font-family:'BebasNeueRegular', Arial, Helvetica, sans-serif; text-shadow:0 0 5px #00c6ff; }

#point { position:relative; -moz-animation:mymove 1s ease infinite; -webkit-animation:mymove 1s ease infinite; padding-left:10px; padding-right:10px; }

@-webkit-keyframes mymove 
{
0% {opacity:1.0; text-shadow:0 0 20px #00c6ff;}
50% {opacity:0; text-shadow:none; }
100% {opacity:1.0; text-shadow:0 0 20px #00c6ff; }	
}


@-moz-keyframes mymove 
{
0% {opacity:1.0; text-shadow:0 0 20px #00c6ff;}
50% {opacity:0; text-shadow:none; }
100% {opacity:1.0; text-shadow:0 0 20px #00c6ff; }	
}

</style>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.6.4.min.js"></script>

<link rel="canonical" href="http://www.alessioatzeni.com/wp-content/tutorials/jquery/CSS3-digital-clock/index.html" />
</head>
<body>
<div class="container">
<div class="clock">
<div id="Date"></div>
    Time Remaining For Dev Mode
<ul>
	<li id="hours"><?php echo $hours ?></li>
    <li id="point">:</li>
    <li id="min"><?php echo $minutes ?></li>


</ul>

</div>
</div>
</body>
</html>

