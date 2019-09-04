#!/bin/bash
cd /data/
tar -xvf Y*.tar.gz
cp -R /data/env-config/4GFiles/peers /etc/ppp
cp -R /data/env-config/e*/* /usr/local/
cp -R /data/env-config/sysclean/auto-del-log.sh /var/log
cd /data/env-config/modify/
./install.sh install
#echo "so-configure>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

echo "/usr/local/selflibArm/lib" >> /etc/ld.so.conf
echo "/usr/local/scjsArm/lib" >> /etc/ld.so.conf
echo "/usr/local/jrtplibArm/lib" >> /etc/ld.so.conf
echo "/usr/lib/arm-linux-gnueabihf" >> /etc/ld.so.conf

echo "export LD_LIBRARY_PATH=/usr/local/selflibArm/lib:/usr/local/scjsArm/lib:/usr/local/jrtplibArm/lib:/usr/lib/arm-linux-gnueabihf:\$LD_LIBRARY_PATH" >> /etc/profile

ldconfig
source /etc/profile
#echo "supervisor>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cd /data/env-config/Supervisor/supervisor-install/meld3-0.6.10
python setup.py install
cd /data/env-config/Supervisor/supervisor-install/setuptools-0.6c11
python setup.py install
cd /data/env-config/Supervisor/supervisor-install/supervisor-3.3.1
python setup.py install

mkdir /etc/supervisor
echo_supervisord_conf > /etc/supervisor/supervisord.conf
cp /data/env-config/Supervisor/supervisor/supervisord.conf /etc/supervisor/
cp -r /data/env-config/Supervisor/supervisor/conf.d /etc/supervisor/

#echo "rc.local>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

sed -i '/^file=/,/fi$/d ' /etc/rc.local
sed -i '/sh \/etc\/ppp\/peers\/pppd-start.sh \&/d' /etc/rc.local
sed -i '/exit 0/d' /etc/rc.local
echo "/bin/sh /data/cloudboxSys/logclear.sh &" >> /etc/rc.local
echo "rm -rf /etc/ppp/peers/nohup.out" >> /etc/rc.local
echo "sleep 3" >> /etc/rc.local
echo "/bin/sh /etc/ppp/peers/pppd-start.sh >> /etc/ppp/peers/nohup.out 2>&1 &" >> /etc/rc.local
echo "sleep 10" >> /etc/rc.local
echo "/usr/bin/python /usr/local/bin/supervisord -c /etc/supervisor/supervisord.conf" >> /etc/rc.local
echo "sleep 5" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
#echo  /etc/nginx/sites-enabled/default">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"



#-----------------------------------------------------------------------------
if grep -w "NTPSERVERS=" /etc/default/ntpdate
then
	sed -i 's/^NTPSERVERS=/#NTPSERVERS=/' /etc/default/ntpdate
else
	echo "#NTPSERVERS="0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org"
" >> /etc/default/ntpdate
fi
sed -i '11i NTPSERVERS="14.204.73.189"' /etc/default/ntpdate
myfile=/etc/default/ntpdate
startLine=12
lineCnt=1
let endLine="startLine + lineCnt - 1"
sed -i $startLine','$endLine'd' $myfile
#nl /etc/default/ntpdate | sed '10a NTPSERVERS="14.204.73.189"'
#nl /etc/default/ntpdate | sed '12d'
#-----------------------------------------------------------------------------
myfile=/etc/nginx/sites-enabled/default
startLine=48
lineCnt=44
let endLine="startLine + lineCnt - 1"
sed -i $startLine','$endLine'd' $myfile
echo ' 	  charset utf-8;' >> /etc/nginx/sites-enabled/default
echo '         location / {' >> /etc/nginx/sites-enabled/default
echo '                #auth_basic "Please input password";' >> /etc/nginx/sites-enabled/default
echo '                #auth_basic_user_file /etc/nginx/htpasswd;' >> /etc/nginx/sites-enabled/default
echo '                 root   /data/cloudboxSys/upserverfiles;' >> /etc/nginx/sites-enabled/default
echo '                 index  index.html index.htm;' >> /etc/nginx/sites-enabled/default
echo '                 if ($request_filename ~* ^.*?.(txt|doc|pdf|rar|gz|zip|docx|exel|xlsx|ppt|pptx|jpg|png|mp4)$){ add_header Content-Disposition attachment;' >> /etc/nginx/sites-enabled/default
echo '                 }' >> /etc/nginx/sites-enabled/default
echo '                 autoindex on;' >> /etc/nginx/sites-enabled/default
echo '                 autoindex_exact_size off;' >> /etc/nginx/sites-enabled/default
echo '                 autoindex_localtime on;' >> /etc/nginx/sites-enabled/default
echo '         }' >> /etc/nginx/sites-enabled/default
echo '         location /logTYF {' >> /etc/nginx/sites-enabled/default
echo '                 auth_basic "access logTYF password";' >> /etc/nginx/sites-enabled/default
echo '                 auth_basic_user_file /etc/nginx/htpasswd;' >> /etc/nginx/sites-enabled/default
echo '                 root   /data/cloudboxSys;' >> /etc/nginx/sites-enabled/default
echo '                 index  index.html index.htm;' >> /etc/nginx/sites-enabled/default
echo '                 if ($request_filename ~* ^.*?.(txt|doc|pdf|rar|gz|zip|docx|exel|xlsx|ppt|pptx|jpg|png|mp4)$){ add_header Content-Disposition attachment;' >> /etc/nginx/sites-enabled/default
echo '                 }' >> /etc/nginx/sites-enabled/default
echo '                 autoindex on;' >> /etc/nginx/sites-enabled/default
echo '                 autoindex_exact_size off;' >> /etc/nginx/sites-enabled/default
echo '                 autoindex_localtime on;' >> /etc/nginx/sites-enabled/default
echo '         }' >> /etc/nginx/sites-enabled/default
echo '         # pass PHP scripts to FastCGI server' >> /etc/nginx/sites-enabled/default
echo '         #' >> /etc/nginx/sites-enabled/default
echo '         #location ~ \.php$ {' >> /etc/nginx/sites-enabled/default
echo '         #       include snippets/fastcgi-php.conf;' >> /etc/nginx/sites-enabled/default
echo '         #' >> /etc/nginx/sites-enabled/default
echo '         #       # With php-fpm (or other unix sockets):' >> /etc/nginx/sites-enabled/default
echo '         #       fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;' >> /etc/nginx/sites-enabled/default
echo '         #       # With php-cgi (or other tcp sockets):' >> /etc/nginx/sites-enabled/default
echo '         #       fastcgi_pass 127.0.0.1:9000;' >> /etc/nginx/sites-enabled/default
echo '         #}' >> /etc/nginx/sites-enabled/default
echo "         # deny access to .htaccess files, if Apache's document root" >> /etc/nginx/sites-enabled/default
echo "         # concurs with nginx's one" >> /etc/nginx/sites-enabled/default
echo '         #' >> /etc/nginx/sites-enabled/default
echo '         #location ~ /\.ht {' >> /etc/nginx/sites-enabled/default
echo '         #       deny all;' >> /etc/nginx/sites-enabled/default
echo '         #}' >> /etc/nginx/sites-enabled/default
echo ' }' >> /etc/nginx/sites-enabled/default
echo ' # Virtual Host configuration for example.com' >> /etc/nginx/sites-enabled/default
echo ' # You can move that to a different file under sites-available/ and symlink that' >> /etc/nginx/sites-enabled/default
echo ' # to sites-enabled/ to enable it.' >> /etc/nginx/sites-enabled/default
echo ' #' >> /etc/nginx/sites-enabled/default
echo ' #server {' >> /etc/nginx/sites-enabled/default
echo ' #       listen 80;' >> /etc/nginx/sites-enabled/default
echo ' #       listen [::]:80;' >> /etc/nginx/sites-enabled/default
echo ' #' >> /etc/nginx/sites-enabled/default
echo ' #       server_name example.com;' >> /etc/nginx/sites-enabled/default
echo ' #       root /var/www/example.com;' >> /etc/nginx/sites-enabled/default
echo ' #       index index.html;' >> /etc/nginx/sites-enabled/default
echo ' #       location / {' >> /etc/nginx/sites-enabled/default
echo ' #               try_files $uri $uri/ =404;' >> /etc/nginx/sites-enabled/default
echo ' #       }' >> /etc/nginx/sites-enabled/default
echo ' #}' >> /etc/nginx/sites-enabled/default
#-----------------------------------------------------------------------------
expect << EOF
spawn htpasswd -c /etc/nginx/htpasswd tyjw
expect "*New password:*"
	send "Ilovetyjw!\r";
expect "*Re-type new password:*"
	send "Ilovetyjw!\r";
expect eof
EOF

nginx -t
nginx -s reload

