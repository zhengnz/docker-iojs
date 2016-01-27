#!/bin/bash
echo 8096 > /writable-proc/sys/net/core/somaxconn
echo "files = /web/$SUPERVISOR_INI/supervisor/*.ini" >> /etc/supervisord.conf
/usr/local/bin/supervisord -n