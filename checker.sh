#!/bin/bash
# Server status checker.

WORKSPACE=/script/isAlive
# list of servers. each server in new line. leave an empty line in the end.
LISTFILE=$WORKSPACE/servers.lst
# Send mail in case of failure to. leave an empty line in the end.
EMAILLISTFILE=$WORKSPACE/emails.lst
# Temporary dir
TEMPDIR=$WORKSPACE/cache
LOG=$WORKSPACE/log
#THIS_IS_CRON=1

# `Quiet` is true when in crontab; show output when it's run manually from shell.
# Set THIS_IS_CRON=1 in the beginning of your crontab -e.
# else you will get the output to your email every time
if [ -n "$THIS_IS_CRON" ]; then QUIET=true; else QUIET=false; fi

function test {
  server="$1"
  response=$(ping -c 1 -W 1 $server)
  status="$?"
  filename=$( echo $1 | cut -f1 -d"/" )
  if [ "$QUIET" = false ] ; then echo -n "$p "; fi
    if [ $status -eq 0 ] ; then
    # server working
      if [ "$QUIET" = false ] ; then
      echo -n "$response ";
      fi
    if [ -f $TEMPDIR/$filename ]; then 
      rm -f $TEMPDIR/$filename
    # create .log file if not exist 
      if [ ! -f $LOG/"$filename".log ]; then touch $LOG/"$filename".log; fi
      echo $(date "+%m/%d/%Y %H:%M:%S") UP >> $LOG/"$filename".log
    else      
      if [ ! -f $LOG/"$filename".log ]; then 
        echo $(date "+%m/%d/%Y %H:%M:%S") UP > $LOG/"$filename".log
      fi
    fi
  else
    # server down
    if [ "$QUIET" = false ] ; then echo -n "$response "; fi
    if [ ! -f $TEMPDIR/$filename ]; then 
        touch $TEMPDIR/$filename
        # create .log file if not exist 
        if [ ! -f $LOG/"$filename".log ]; then touch $LOG/"$filename".log; fi
        echo $(date "+%m/%d/%Y %H:%M:%S") $server DOWN >> $LOG/"$filename".log
            while read e; do
                # using mailx command
                message=$(tail -n1 $LOG/"$filename".log)
                echo "$message
Details :
$response" | mailx -s "$server SERVER DOWN" $e
                # using mail command
                #mail -s "$p SERVER DOWN" "$EMAIL"
            done < $EMAILLISTFILE
    fi
  fi
}

# main loop
while read p; do
  test $p
done < $LISTFILE
