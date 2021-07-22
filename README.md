# scripts

This repo will contains useful scripts

## Summary

* [Export a db faster](#exportdbsh)
* [Import a db](#importdbsh)

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
* ```--user``` is an alias of ```--db-user``` is the name of your user db
* ```--db``` is an alias of ```--db-name``` is the name of your database
* ```--path``` is an alias of ```--out-path``` is the path on your local machin where you want the dump
* ```--docker``` is an alias of ```--docker-name``` is the name of your docker which contains the mysql server (optional)
* ```-ziped``` is an option to tell to export the db compressed (optional)
  
### importDb.sh

This script allow you to import a mysql database (for now)
It should be used after the export. 

Example of how to use it : 

* Import database with a mysql local : ```./importDb.sh --user=root --db=my_db --path=/tmp/dump/my_db.sql```
* Import database into a docker : ```./importDb.sh --user=root --db=my_db --path=/tmp/dump/my_db.sql --docker=gt_bdd```

Good to know:
* ```--user``` is an alias of ```--db-user``` is the name of your user db
* ```--db``` is an alias of ```--db-name``` is the name of your database
* ```--path``` is an alias of ```--from-path``` is the path on your local machin where the dump is. 
  The extension must be ```.sql``` or ```.sql.gz```
* ```--docker``` is an alias of ```--docker-name``` is the name of your docker which contains the mysql server (optional)
