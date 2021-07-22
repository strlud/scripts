# scripts

This repo will contains useful scripts

## Summary

* [Export a db faster](#exportDb.sh)

### exportDb.sh

This script allow you to export a mysql database (for now).
You could export a db from a docker or your local machine. Compressed or not.
The dump's name will be : db_name-year_month_day-hour_minute_second

Example : 

* Export from your local machine NOT compressed : ```./exportDb.sh --user=root --db=my_db --path=/tmp/dump```
* Export from your local machine compressed: ```./exportDb.sh --user=root --db=my_db --path=/tmp/dump -ziped```
* Export from a docker NOT compressed : ```./exportDb.sh --user=root --db=my_db --path=/tmp/dump --docker-name=db_docker```
* Export from a docker compressed : ```./exportDb.sh --user=root --db=my_db --path=/tmp/dump --docker-name=db_docker -ziped```

Good to know: 
* ```--user``` is an alias of ```--db-user``` : is the name of your user db
* ```--db``` is an alias of ```--db-name``` : is the name of your database
* ```--path``` is an alias of ```--out-path``` : is the path on your local machin where you want the dump

