#!/bin/bash

if [ "$AUTOINDEX" = "OFF" ] ; then
	cat /srcs/autoindex_off.sh > /etc/nginx/sites-available/config > /etc/nginx/sites-enabled/config
elif [ "$AUTOINDEX" = "ON" ] ; then
	cat /srcs/autoindex_on.sh > /etc/nginx/sites-available/config > /etc/nginx/sites-enabled/config
fi
service nginx restart