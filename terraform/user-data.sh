#!/bin/bash
yum update -y
yum install -y nginx
cat >/usr/share/nginx/html/index.html <<"HTML"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Clock-Server</title>
  <style>
    body{font-family:sans-serif;display:flex;align-items:center;
         justify-content:center;height:100vh;margin:0;
         background:#111;color:#0f0;font-size:6vw;}
  </style>
</head>
<body>
  <div id="clock"></div>
  <script>
    const el=document.getElementById("clock");
    function tick(){ el.textContent=new Date().toLocaleTimeString(); }
    tick(); setInterval(tick,1000);
  </script>
</body>
</html>
HTML
systemctl enable --now nginx
