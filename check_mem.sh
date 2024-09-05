#!/bin/sh

WARNLEVEL=$1
CRITLEVEL=$2

UNKNOWN_STATE=3
CRITICAL_STATE=2
WARNING_STATE=1
OK_STATE=0

BC=/usr/bin/bc
GREP=/bin/grep
AWK=/bin/awk
FREE=/usr/bin/free
TAIL=/usr/bin/tail
HEAD=/usr/bin/head

set `$FREE |$HEAD -2 |$TAIL -1`

MEMTOTAL=$2
MEMUSED=$3
MEMFREE=$4
MEMBUFFERS=$6
MEMCACHED=$7

REALMEMUSED=`echo $MEMUSED - $MEMBUFFERS - $MEMCACHED | $BC`
USEPCT=`echo "scale=2; $MEMUSED / $MEMTOTAL * 100" |$BC -l`

WARNMEM=`echo "scale=2; $WARNLEVEL / 100 *$MEMTOTAL" |$BC -l`
CRITMEM=`echo "scale=2; $CRITLEVEL / 100 *$MEMTOTAL" |$BC -l`

WARNMEMMB=`echo "scale=2; $WARNMEM / 1024" |$BC -l`
CRITMEMMB=`echo "scale=2; $CRITMEM / 1024" |$BC -l`
MEMTOTALMB=`echo "scale=2; $MEMTOTAL / 1024" |$BC -l`
REALMEMUSEDMB=`echo "scale=2; $MEMUSED / 1024" |$BC -l`

if [ `echo "$USEPCT > $CRITLEVEL" |bc` -eq "1" ]
then echo "CRITICAL: physical memory: ${REALMEMUSEDMB}MB |'physical memory %'=${USEPCT}%;${WARNLEVEL};${CRITLEVEL} 'physical memory'=${REALMEMUSEDMB}MB;${WARNMEMMB};${CRITMEMMB};0;${MEMTOTALMB}"
     exit ${CRITICAL_STATE}
elif [ `echo "$USEPCT > $WARNLEVEL" |bc` -eq "1" ]
then echo "WARNING: physical memory: ${REALMEMUSEDMB}MB |'physical memory %'=${USEPCT}%;${WARNLEVEL};${CRITLEVEL} 'physical memory'=${REALMEMUSEDMB}MB;${WARNMEMMB};${CRITMEMMB};0;${MEMTOTALMB}"
     exit ${WARNING_STATE}
elif [ `echo "$USEPCT < $WARNLEVEL" |bc` -eq "1" ]
then echo "OK: physical memory: ${REALMEMUSEDMB}MB |'physical memory %'=${USEPCT}%;${WARNLEVEL};${CRITLEVEL} 'physical memory'=${REALMEMUSEDMB}MB;${WARNMEMMB};${CRITMEMMB};0;${MEMTOTALMB}"
     exit ${OK_STATE}
else echo "Unable to determine memory usage. |'physical memory %'=${USEPCT}%;${WARNLEVEL};${CRITLEVEL} 'physical memory'=${REALMEMUSEDMB}MB;${WARNMEMMB};${CRITMEMMB};0;${MEMTOTALMB}"
     exit ${UNKNOWN_STATE}
fi
echo "Unable to determine memory usage."
exit ${UNKNOWN_STATE}
