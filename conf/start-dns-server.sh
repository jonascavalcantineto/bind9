#!/bin/bash

if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then 
    /usr/sbin/named-checkconf -z "$NAMEDCONF"; 
else 
    echo "Checking of zone files is disabled"; 
fi

/usr/sbin/named -u named -c $NAMEDCONF $OPTIONS
