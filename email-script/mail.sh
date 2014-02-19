#! /bin/bash

#A simple sendmail script. Creates a html email with the graph as an attachment and an embedded image, and attaches the human friendly csv output of temperatues too.
#You can customise the message to be what you want.
#Will include in the body that the temperature exceeded the threshold as specified in the make_them_graph.sh file

#Change the TO and FROM fields to suit your needs.
sendmail -t <<EOT
TO: example@example.com
FROM: <example@example.com>
SUBJECT: Temperature
MIME-Version: 1.0
Content-Type: multipart/related;boundary="XYZ"

--XYZ
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-15">
</head>
<body bgcolor="#ffffff" text="#000000">
<p>Hi,<br/>
The temperature today exceeded $1 degrees celsius. This does not provide an acceptable working condition for us.
</p>
<p>The graph below, and attached, shows the temperature during the course of the day, and the attached csv shows the temperature at different times. </p>
<p>Please can you work to reduce the temperature on the 3rd floor of Hotham House</p>
<img src="cid:part1.06090408.01060107" alt="">
</body>
</html>

--XYZ
Content-Type: image/png;name="temperature.png"
Content-Transfer-Encoding: base64
Content-ID: <part1.06090408.01060107>
Content-Disposition: inline; filename="temperature.png"

$(base64 temperature.png)
--XYZ
Content-Type: image/png; name="temperature.png"
Content-Transfer-Encoding: base64
Content-ID: <part1.06090408.01060107>
Content-Disposition: attachment; filename="temperature.png"

$(base64 temperature.png)

--XYZ
Content-Type: text/csv; name="temperatures.csv"
Content-Disposition: attachment; filename="temperatures.csv"

$(cat temperatures.human)
--XYZ--
EOT

