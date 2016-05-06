isAlive
========

Script for scheduled check of servers availability and email report. Suited for crontab job.

## Config
1. Create ```emails.lst``` file and fill it with each email in new line . leave an empty line in the end.
2. Create ```servers.lst``` file and fill it with each website in a new line . leave an empty line in the end.

## Add to crontab
Add the following lines to crontab config ($ crontab -e) 

```
THIS_IS_CRON=1
*/30 * * * * /path/to/isAlive/checker.sh
```

in this example crontab will run ```checker.sh``` every 30min.
